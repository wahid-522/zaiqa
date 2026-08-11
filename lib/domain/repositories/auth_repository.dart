import '../entities/user_profile.dart';
import '../../core/utils/result.dart';

abstract class AuthRepository {
  Future<Result<AppFailure, UserProfile>> loginWithEmail({
    required String email,
    required String password,
    UserRole? role,
  });

  Future<Result<AppFailure, UserProfile>> signupWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
    UserRole role = UserRole.customer,
  });

  Future<Result<AppFailure, UserProfile?>> getCurrentUser();

  Future<Result<AppFailure, void>> logout();

  Future<Result<AppFailure, UserProfile>> updateProfile(UserProfile profile);
}
