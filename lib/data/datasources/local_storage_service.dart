import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course_model.dart';
import '../models/user_model.dart';

/// Local persistence service utilizing SharedPreferences for offline-first caching.
class LocalStorageService {
  static const String _keyCoursesCache = 'cached_courses_json';
  static const String _keyUserSession = 'user_session_json';
  static const String _keyLastCacheTimestamp = 'last_cache_timestamp';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  /// Factory helper to initialize with SharedPreferences instance.
  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // --- Course Cache ---

  /// Caches the course list locally.
  Future<bool> saveCourses(List<CourseModel> courses) async {
    final jsonString = jsonEncode(courses.map((c) => c.toJson()).toList());
    await _prefs.setInt(_keyLastCacheTimestamp, DateTime.now().millisecondsSinceEpoch);
    return _prefs.setString(_keyCoursesCache, jsonString);
  }

  /// Retrieves cached courses from local storage.
  List<CourseModel>? getCachedCourses() {
    final jsonString = _prefs.getString(_keyCoursesCache);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    try {
      final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded
          .map((item) => CourseModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Checks if cached course data exists.
  bool hasCachedCourses() {
    return _prefs.containsKey(_keyCoursesCache);
  }

  /// Retrieves timestamp when cache was last updated.
  DateTime? getLastCacheTime() {
    final millis = _prefs.getInt(_keyLastCacheTimestamp);
    return millis != null ? DateTime.fromMillisecondsSinceEpoch(millis) : null;
  }

  /// Updates a specific course inside the cached course list.
  Future<bool> updateCachedCourse(CourseModel updatedCourse) async {
    final courses = getCachedCourses() ?? [];
    final index = courses.indexWhere((c) => c.id == updatedCourse.id);
    if (index != -1) {
      courses[index] = updatedCourse;
    } else {
      courses.add(updatedCourse);
    }
    return saveCourses(courses);
  }

  // --- User Session ---

  /// Saves current logged-in user profile & session token.
  Future<bool> saveUser(UserModel user) async {
    return _prefs.setString(_keyUserSession, jsonEncode(user.toJson()));
  }

  /// Retrieves cached user session.
  UserModel? getUser() {
    final jsonString = _prefs.getString(_keyUserSession);
    if (jsonString == null || jsonString.isEmpty) return null;
    try {
      return UserModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  /// Clears user session on logout.
  Future<bool> clearUser() async {
    return _prefs.remove(_keyUserSession);
  }

  /// Clears all local application storage.
  Future<bool> clearAll() async {
    return _prefs.clear();
  }
}
