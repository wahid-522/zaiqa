import 'dart:math';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../../domain/entities/delivery_route.dart';

class GoogleDirectionsDataSource {
  final FirebaseFunctions? _customFunctions;

  FirebaseFunctions get _functions => _customFunctions ?? FirebaseFunctions.instance;

  GoogleDirectionsDataSource({FirebaseFunctions? functions})
      : _customFunctions = functions;

  Future<DeliveryRoute> getDirections({
    required LatLngPoint origin,
    required LatLngPoint destination,
  }) async {
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
      // Fallback calculation below if Cloud Function or network call fails
    }

    // Direct Haversine calculation fallback
    return _calculateFallbackRoute(origin, destination);
  }

  DeliveryRoute _calculateFallbackRoute(LatLngPoint origin, LatLngPoint destination) {
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
    final durationMinutes = (distanceKm * 3.5 + 5).round(); // Estimated driving time

    return DeliveryRoute(
      distanceText: '${distanceKm.toStringAsFixed(1)} km',
      distanceKm: double.parse(distanceKm.toStringAsFixed(1)),
      durationText: '$durationMinutes mins',
      durationMinutes: durationMinutes,
      polylinePoints: [origin, destination],
    );
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
