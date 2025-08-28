import {setGlobalOptions} from "firebase-functions/v2";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import axios, {isAxiosError} from "axios";
import {
  getKiotVietAccessToken,
  KiotVietToken,
} from "./kiotviet/kiotVietApiClient";
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";

// Initialize Firebase Admin SDK
initializeApp();
const db = getFirestore();

// Set global options for functions
setGlobalOptions({maxInstances: 10, region: "asia-southeast1"});

// In-memory cache for the KiotViet access token
// Since config is now global, we can simplify the cache
let kiotVietToken: KiotVietToken | null = null;
let cachedRetailer: string | null = null;


/**
 * Fetches KiotViet configuration (retailer, clientId, clientSecret)
 * from Firestore.
 * @return {Promise<{retailer: string, clientId: string,
 *   clientSecret: string}>}
 */
async function getKiotVietConfig() {
  logger.info("Fetching KiotViet configuration from 'settings/kiotviet'");
  const configDoc = await db.collection("settings").doc("kiotviet").get();

  if (!configDoc.exists) {
    logger.error("KiotViet configuration document " +
      "'settings/kiotviet' not found.");
    throw new HttpsError(
      "not-found",
      "KiotViet configuration not found on the server."
    );
  }

  const configData = configDoc.data();
  const {retailer, clientId, clientSecret} =
    configData as {
      retailer: string,
      clientId: string,
      clientSecret: string
    };

  if (!retailer || !clientId || !clientSecret) {
    logger.error("Incomplete KiotViet configuration in 'settings/kiotviet'.");
    throw new HttpsError(
      "internal",
      "Server configuration error: Incomplete KiotViet credentials."
    );
  }

  return {retailer, clientId, clientSecret};
}


/**
 * A callable function that acts as a proxy to the KiotViet API.
 * It fetches a global configuration from Firestore, handles authentication,
 * and forwards GET requests from the client app.
 */
export const kiotVietGetProxy = onCall(async (request) => {
  logger.info("kiotVietGetProxy function triggered", {
    data: request.data,
  });

  try {
    // Validate that data was sent and contains the required 'endpoint'
    if (!request.data || !request.data.endpoint) {
      logger.error(
        "Request rejected: Missing 'endpoint' in request data.",
        {data: request.data}
      );
      throw new HttpsError(
        "invalid-argument",
        "The function must be called with an 'endpoint' in the data payload."
      );
    }
    const {endpoint, params} = request.data;

    // Get the global KiotViet configuration from Firestore
    const {retailer, clientId, clientSecret} = await getKiotVietConfig();

    // If the retailer in the config has changed, clear the cache.
    if (cachedRetailer !== retailer) {
      logger.info("Retailer config changed from " +
        `'${cachedRetailer}' to '${retailer}'. Clearing token cache.`);
      kiotVietToken = null;
      cachedRetailer = retailer;
    }


    // Check cache for a valid token
    if (!kiotVietToken || kiotVietToken.expiresAt <= Date.now()) {
      logger.info(
        `Token for '${retailer}' is missing or expired. Fetching a new one.`,
      );
      kiotVietToken = await getKiotVietAccessToken(clientId, clientSecret);
      logger.info("Successfully fetched and cached a new token for " +
        `'${retailer}'.`);
    } else {
      logger.info(`Using cached token for '${retailer}'.`);
    }

    const apiUrl = `https://public.kiotapi.com/${endpoint}`;
    logger.info(`Making GET request to KiotViet API: ${apiUrl}`, {params});

    // Make the API call to KiotViet
    const response = await axios.get(apiUrl, {
      headers: {
        "Authorization": `Bearer ${kiotVietToken.accessToken}`,
        "Retailer": retailer, // Use the retailer from the Firestore config
      },
      params: params || {},
    });

    logger.info("Successfully received data from KiotViet API.");
    return response.data;
  } catch (error) {
    // In case of an error, reset the token to force re-authentication next
    // time.
    kiotVietToken = null;
    logger.error("Error in kiotVietGetProxy:", error);

    // If the error is already an HttpsError, re-throw it.
    // This is important for errors from getKiotVietConfig or
    // getKiotVietAccessToken.
    if (error instanceof HttpsError) {
      throw error;
    }

    // Handle Axios errors specifically to provide more context
    if (isAxiosError(error)) {
      if (error.response) {
        // The request was made and the server responded with a status code
        throw new HttpsError(
          "internal",
          `KiotViet API request failed with status ${error.response.status}`,
          error.response.data
        );
      } else if (error.request) {
        // The request was made but no response was received
        throw new HttpsError(
          "unavailable",
          "The KiotViet API did not respond.",
        );
      }
    }

    // For any other type of error, wrap it in a HttpsError.
    const errorMessage =
      error instanceof Error ? error.message : "An unknown error occurred.";
    throw new HttpsError(
      "internal",
      `An unexpected server error occurred: ${errorMessage}`,
    );
  }
});
