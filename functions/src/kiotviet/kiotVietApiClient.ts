import axios, {AxiosError} from "axios";
import {HttpsError} from "firebase-functions/v2/https";

const tokenEndpoint = "https://id.kiotviet.vn/connect/token";

/**
 * Interface for the KiotViet token object, including its expiration time.
 */
export interface KiotVietToken {
  accessToken: string;
  /** The timestamp (in milliseconds since the epoch) when the token expires. */
  expiresAt: number;
}

/**
 * Interface for the KiotViet token API response.
 */
interface KiotVietTokenResponse {
  access_token: string;
  expires_in: number;
}

/**
 * Lấy Access Token từ KiotViet API.
 * @param {string} clientId - Client ID của KiotViet.
 * @param {string} clientSecret - Client Secret của KiotViet.
 * @return {Promise<KiotVietToken>} An object containing the access token and
 * its expiration time.
 */
export async function getKiotVietAccessToken(
  clientId: string,
  clientSecret: string
): Promise<KiotVietToken> {
  const params = new URLSearchParams();
  params.append("scopes", "PublicApi.Access");
  params.append("grant_type", "client_credentials");
  params.append("client_id", clientId);
  params.append("client_secret", clientSecret);

  try {
    const response = await axios.post<KiotVietTokenResponse>(
      tokenEndpoint,
      params,
      {
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
      },
    );

    if (response.data?.access_token && response.data?.expires_in) {
      const expiresInSeconds = response.data.expires_in;
      // Calculate the expiration timestamp.
      // Subtract a 60-second buffer for safety.
      const expiresAt = Date.now() + expiresInSeconds * 1000 - 60000;

      return {
        accessToken: response.data.access_token,
        expiresAt: expiresAt,
      };
    } else {
      throw new Error("Failed to retrieve access token from KiotViet.");
    }
  } catch (error) {
    let errorMessage = "Không thể kết nối hoặc lấy token từ KiotViet.";
    if (error instanceof AxiosError) {
      console.error(
        "KiotViet API error:",
        error.response?.data || error.message
      );
      const errorDesc =
        error.response?.data?.error_description || error.message;
      errorMessage = `KiotViet API error: ${errorDesc}`;
    } else {
      console.error("Lỗi khi gọi KiotViet API:", error);
    }

    throw new HttpsError("internal", errorMessage);
  }
}
