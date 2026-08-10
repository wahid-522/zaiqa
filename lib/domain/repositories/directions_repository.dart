import '../../core/utils/result.dart';
import '../entities/delivery_route.dart';

abstract class DirectionsRepository {
  Future<Result<AppFailure, DeliveryRoute>> getDeliveryRoute({
    required LatLngPoint origin,
    required LatLngPoint destination,
  });
}
