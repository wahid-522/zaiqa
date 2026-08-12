const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();

/**
 * Callable Cloud Function proxy for Google Directions API.
 * Accepts { originLat, originLng, destLat, destLng }
 * Reads secret/env variable DIRECTIONS_API_KEY.
 * Returns directions payload (routes, polyline, distance, duration).
 */
exports.getDirections = functions.https.onCall(async (data, context) => {
  // Verify user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "The user must be authenticated to request directions."
    );
  }

  const { originLat, originLng, destLat, destLng } = data;

  if (
    originLat === undefined ||
    originLng === undefined ||
    destLat === undefined ||
    destLng === undefined
  ) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Origin and destination coordinates are required."
    );
  }

  // Get API key from environment variable / secret
  const apiKey = process.env.DIRECTIONS_API_KEY;

  if (!apiKey) {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "DIRECTIONS_API_KEY environment variable is not configured on the server."
    );
  }

  const url = `https://maps.googleapis.com/maps/api/directions/json?origin=${originLat},${originLng}&destination=${destLat},${destLng}&key=${apiKey}`;

  try {
    const response = await axios.get(url);
    const googleData = response.data;

    if (googleData.status !== "OK" || !googleData.routes.length) {
      return {
        status: googleData.status || "ZERO_RESULTS",
        distanceKm: 0,
        durationMinutes: 0,
        polyline: "",
      };
    }

    const route = googleData.routes[0];
    const leg = route.legs[0];

    const distanceMeters = leg.distance ? leg.distance.value : 0;
    const durationSeconds = leg.duration ? leg.duration.value : 0;

    return {
      status: "OK",
      distanceKm: distanceMeters / 1000.0,
      durationMinutes: Math.ceil(durationSeconds / 60.0),
      polyline: route.overview_polyline ? route.overview_polyline.points : "",
    };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      `Google Directions API proxy request failed: ${error.message}`
    );
  }
});
