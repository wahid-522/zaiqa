import 'package:equatable/equatable.dart';

class LatLngPoint extends Equatable {
  final double latitude;
  final double longitude;

  const LatLngPoint(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}

/// Pure Domain Entity representing a calculated route from Directions API.
class DeliveryRoute extends Equatable {
  final String distanceText; // e.g. "4.2 km"
  final double distanceKm;
  final String durationText; // e.g. "14 mins"
  final int durationMinutes;
  final List<LatLngPoint> polylinePoints;

  const DeliveryRoute({
    required this.distanceText,
    required this.distanceKm,
    required this.durationText,
    required this.durationMinutes,
    required this.polylinePoints,
  });

  @override
  List<Object?> get props => [
        distanceText,
        distanceKm,
        durationText,
        durationMinutes,
        polylinePoints,
      ];
}
