import '../../core/utils/result.dart';
import '../../domain/entities/delivery_route.dart';
import '../../domain/repositories/directions_repository.dart';
import '../datasources/google_directions_datasource.dart';

class DirectionsRepositoryImpl implements DirectionsRepository {
  final GoogleDirectionsDataSource dataSource;

  DirectionsRepositoryImpl({required this.dataSource});

  @override
  Future<Result<AppFailure, DeliveryRoute>> getDeliveryRoute({
    required LatLngPoint origin,
    required LatLngPoint destination,
  }) async {
    try {
      final route = await dataSource.getDirections(
        origin: origin,
        destination: destination,
      );
      return Success(route);
    } catch (e) {
      return Failure(AppFailure(e.toString()));
    }
  }
}
