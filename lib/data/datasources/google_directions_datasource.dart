import 'dart:math';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../../domain/entities/delivery_route.dart';

/// MOCK / PLACEHOLDER DATA SOURCE FOR DIRECTIONS & ROUTING
/// This data source generates realistic mock route calculations (distance, duration, polyline points)
/// using Haversine spherical distance formulas during local development.
///
/// TODO: Set [useRealCloudFunctionProxy] to true when upgrading to Firebase Blaze Plan
/// to route requests through the server-side Cloud Function proxy (functions/index.js).
class GoogleDirectionsDataSource {
  // Set to true when Firebase project is upgraded to Blaze plan
  static const bool useRealCloudFunctionProxy = false;

  final FirebaseFunctions? _customFunctions;

  FirebaseFunctions get _functions => _customFunctions ?? FirebaseFunctions.instance;

  GoogleDirectionsDataSource({FirebaseFunctions? functions})
      : _customFunctions = functions;

  Future<DeliveryRoute> getDirections({
    required LatLngPoint origin,
    required LatLngPoint destination,
  }) async {
    // ------------------------------------------------------------------------
    // REAL CLOUD FUNCTION PROXY CALL (Paused until Firebase Blaze upgrade)
    // ------------------------------------------------------------------------
    if (useRealCloudFunctionProxy) {
      try {
        final callable = _functions.httpsCallable('getDirections');
        final response = await callable.call<Map<String, dynamic>>({
          'originLat': origin.latitude,
          'originLng': origin.longitude,
          'destLat': destination.latitude,
          'destLng': destination.longitude,
        });

        final data = response.data;
        if (data['status'] == 'OK') {
          final distanceKm = (data['distanceKm'] as num? ?? 0.0).toDouble();
          final durationMinutes = (data['durationMinutes'] as num? ?? 0).toInt();
          final polylineString = data['polyline'] as String? ?? '';

          final polylinePoints = PolylinePoints();
          final decodedPoints = polylinePoints.decodePolyline(polylineString);

          final routePoints = decodedPoints
              .map((p) => LatLngPoint(p.latitude, p.longitude))
              .toList();

          return DeliveryRoute(
            distanceText: '${distanceKm.toStringAsFixed(1)} km',
            distanceKm: distanceKm,
            durationText: '$durationMinutes mins',
            durationMinutes: durationMinutes,
            polylinePoints: routePoints.isNotEmpty ? routePoints : [origin, destination],
          );
        }
      } catch (_) {
        // Fallback to mock route below if Cloud Function fails
      }
    }

    // ------------------------------------------------------------------------
    // MOCK / PLACEHOLDER ROUTE CALCULATION
    // Haversine spherical distance calculation for offline / development session
    // ------------------------------------------------------------------------
    return _calculateMockRoute(origin, destination);
  }

  DeliveryRoute _calculateMockRoute(LatLngPoint origin, LatLngPoint destination) {
    const double earthRadiusKm = 6371.0;
    final dLat = _degreesToRadians(destination.latitude - origin.latitude);
    final dLon = _degreesToRadians(destination.longitude - origin.longitude);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(origin.latitude)) *
            cos(_degreesToRadians(destination.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distanceKm = earthRadiusKm * c;
    final durationMinutes = (distanceKm * 3.5 + 5).round();

    return DeliveryRoute(
      distanceText: '${distanceKm.toStringAsFixed(1)} km (Mock)',
      distanceKm: double.parse(distanceKm.toStringAsFixed(1)),
      durationText: '$durationMinutes mins',
      durationMinutes: durationMinutes,
      polylinePoints: [
        origin,
        LatLngPoint(
          (origin.latitude + destination.latitude) / 2 + 0.002,
          (origin.longitude + destination.longitude) / 2 - 0.002,
        ),
        destination,
      ],
    );
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
