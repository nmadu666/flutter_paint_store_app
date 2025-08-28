import {setGlobalOptions} from "firebase-functions/v2";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import axios, {isAxiosError} from "axios";
import {
  getKiotVietAccessToken,
  KiotVietToken,
} from "./kiotviet/kiotVietApiClient";

// Set global options for functions (e.g., max instances)
setGlobalOptions({maxInstances: 10, region: "asia-southeast1"});

// In-memory cache for the KiotViet access token
let kiotVietToken: KiotVietToken | null = null;

/**
 * A callable function that acts as a proxy to the KiotViet API.
 * It handles authentication and forwards GET requests from the client app.
 */
export const kiotVietGetProxy = onCall(async (request) => {
  logger.info("kiotVietGetProxy function triggered", {
    data: request.data,
  });

  const {endpoint, retailer, params} = request.data;

  // Validate required parameters
  if (!endpoint || !retailer) {
    logger.error("Missing required parameters: endpoint or retailer");
    throw new HttpsError(
      "invalid-argument",
      "The function must be called with 'endpoint' and 'retailer' arguments."
    );
  }

  // Retrieve KiotViet credentials from environment variables
  const clientId = process.env.KIOTVIET_CLIENT_ID;
  const clientSecret = process.env.KIOTVIET_CLIENT_SECRET;

  if (!clientId || !clientSecret) {
    logger.error("KiotViet credentials are not set in environment variables.");
    throw new HttpsError(
      "internal",
      "Server configuration error. Missing KiotViet credentials."
    );
  }

  try {
    // Check if the token is cached and still valid
    if (!kiotVietToken || kiotVietToken.expiresAt <= Date.now() ) {
      logger.info("Access token is missing or expired. Fetching a new one.");
      kiotVietToken = await getKiotVietAccessToken(clientId, clientSecret);
      logger.info("Successfully fetched and cached a new access token.");
    } else {
      logger.info("Using cached access token.");
    }

    const apiUrl = `https://public.kiotapi.com/${endpoint}`;

    logger.info(`Making GET request to KiotViet API: ${apiUrl}`, {params});

    // Make the API call to KiotViet
    const response = await axios.get(apiUrl, {
      headers: {
        "Authorization": `Bearer ${kiotVietToken.accessToken}`,
        "Retailer": retailer,
      },
      params: params || {}, // Provide empty object as default
    });

    logger.info("Successfully received data from KiotViet API.");
    return response.data;
  } catch (error) {
    // In case of an error, reset the token to force re-authentication next time
    kiotVietToken = null;
    logger.error("Error calling KiotViet API:", error);

    if (isAxiosError(error) && error.response) {
      throw new HttpsError(
        "internal",
        `KiotViet API request failed with status ${error.response.status}`,
        error.response.data
      );
    }

    // Re-throw other errors (like HttpsError from getKiotVietAccessToken)
    throw error;
  }
});
