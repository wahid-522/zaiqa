import 'dart:convert';
import 'dart:math';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/delivery_route.dart';

class GoogleDirectionsDataSource {
  final String apiKey;
  final http.Client client;

  GoogleDirectionsDataSource({
    String? apiKey,
    http.Client? client,
  })  : apiKey = apiKey ?? const String.fromEnvironment('DIRECTIONS_API_KEY', defaultValue: ''),
        client = client ?? http.Client();

  Future<DeliveryRoute> getDirections({
    required LatLngPoint origin,
    required LatLngPoint destination,
  }) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json'
      '?origin=${origin.latitude},${origin.longitude}'
      '&destination=${destination.latitude},${destination.longitude}'
      '&key=$apiKey',
    );

    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && (data['routes'] as List).isNotEmpty) {
          final route = data['routes'][0];
          final leg = route['legs'][0];

          final distanceText = leg['distance']['text'] as String? ?? '0 km';
          final distanceMeters = (leg['distance']['value'] as num? ?? 0).toDouble();
          final distanceKm = (distanceMeters / 1000.0);

          final durationText = leg['duration']['text'] as String? ?? '0 mins';
          final durationSeconds = leg['duration']['value'] as int? ?? 0;
          final durationMinutes = (durationSeconds / 60).round();

          final polylineString = route['overview_polyline']['points'] as String? ?? '';
          final polylinePoints = PolylinePoints();
          final decodedPoints = polylinePoints.decodePolyline(polylineString);

          final routePoints = decodedPoints
              .map((p) => LatLngPoint(p.latitude, p.longitude))
              .toList();

          return DeliveryRoute(
            distanceText: distanceText,
            distanceKm: distanceKm,
            durationText: durationText,
            durationMinutes: durationMinutes,
            polylinePoints: routePoints,
          );
        }
      }
    } catch (_) {
      // Fallback calculation below if network error occurs
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
