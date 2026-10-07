import '../datasources/local_storage_service.dart';
import '../datasources/mock_course_api.dart';
import '../models/user_model.dart';

/// Repository responsible for user authentication and session management.
class AuthRepository {
  final MockCourseApi api;
  final LocalStorageService storage;

  AuthRepository({
    required this.api,
    required this.storage,
  });

  /// Attempts to authenticate with email and password.
  Future<UserModel> login(String email, String password) async {
    final user = await api.login(email: email, password: password);
    await storage.saveUser(user);
    return user;
  }

  /// Gets current active user from cache.
  UserModel? getCurrentUser() {
    return storage.getUser();
  }

  /// Logs out user and cleans up stored session token.
  Future<void> logout() async {
    await storage.clearUser();
  }

  /// Checks if a user is currently logged in.
  bool get isLoggedIn => storage.getUser() != null;
}
