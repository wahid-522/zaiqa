import '../../core/utils/result.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_mock_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalMockDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Result<AppFailure, UserProfile>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      if (email.trim().isEmpty || password.trim().isEmpty) {
        return const Failure(AppFailure('Please enter both email and password'));
      }
      final user = await _dataSource.loginWithEmail(email, password);
      return Success(user);
    } catch (e) {
      return Failure(AppFailure('Login failed: $e'));
    }
  }

  @override
  Future<Result<AppFailure, UserProfile>> signupWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
        return const Failure(AppFailure('Please fill in all required fields'));
      }
      final user = await _dataSource.signupWithEmail(name, email, phone, password);
      return Success(user);
    } catch (e) {
      return Failure(AppFailure('Signup failed: $e'));
    }
  }

  @override
  Future<Result<AppFailure, UserProfile?>> getCurrentUser() async {
    try {
      final user = await _dataSource.getCurrentUser();
      return Success(user);
    } catch (e) {
      return Failure(AppFailure('Error fetching user profile: $e'));
    }
  }

  @override
  Future<Result<AppFailure, void>> logout() async {
    return const Success(null);
  }

  @override
  Future<Result<AppFailure, UserProfile>> updateProfile(UserProfile profile) async {
    return Success(profile);
  }
}
