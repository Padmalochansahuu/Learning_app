import 'package:flutter/material.dart';
import '../data/models/course_model.dart';
import '../data/repositories/course_repository.dart';

enum DashboardState { loading, success, empty, error }

/// ViewModel managing state for Screen 2 (Course Dashboard).
/// Adheres to MVVM architecture handling Loading, Success, Empty, and Error states,
/// as well as offline cache switching.
class DashboardViewModel extends ChangeNotifier {
  final CourseRepository repository;

  DashboardViewModel({required this.repository});

  DashboardState _state = DashboardState.loading;
  List<CourseModel> _allCourses = [];
  String? _errorMessage;
  bool _isOffline = false;
  bool _isCachedData = false;
  String? _cacheNotice;

  // Getters
  DashboardState get state => _state;
  bool get isLoading => _state == DashboardState.loading;
  bool get isSuccess => _state == DashboardState.success;
  bool get isEmpty => _state == DashboardState.empty;
  bool get isError => _state == DashboardState.error;
  String? get errorMessage => _errorMessage;
  bool get isOffline => _isOffline;
  bool get isCachedData => _isCachedData;
  String? get cacheNotice => _cacheNotice;

  List<CourseModel> get courses => _allCourses;

  int get totalCoursesCount => _allCourses.length;

  int get overallProgressAverage {
    if (_allCourses.isEmpty) return 0;
    final total = _allCourses.fold<int>(0, (sum, c) => sum + c.calculatedProgress);
    return (total / _allCourses.length).round();
  }

  /// Fetches courses from repository (offline-first).
  Future<void> fetchCourses({bool forceRefresh = false}) async {
    _state = DashboardState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.getCourses(forceRefresh: forceRefresh);
      _allCourses = result.courses;
      _isCachedData = result.isFromCache;
      _cacheNotice = result.notice;

      if (_allCourses.isEmpty) {
        _state = DashboardState.empty;
      } else {
        _state = DashboardState.success;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _state = DashboardState.error;
    } finally {
      notifyListeners();
    }
  }

  /// Toggles network online/offline simulation for testing offline requirement.
  void toggleOfflineMode() {
    _isOffline = !_isOffline;
    repository.api.isNetworkAvailable = !_isOffline;
    // Trigger re-fetch under new network condition
    fetchCourses();
  }

  /// Toggles simulated API 500 failure for evaluating the Error state.
  void toggleSimulatedApiFailure() {
    final next = !repository.api.shouldSimulateFailure;
    repository.api.shouldSimulateFailure = next;
    fetchCourses();
  }

  /// Forces an empty state for evaluation.
  void simulateEmptyState() {
    _allCourses = [];
    _state = DashboardState.empty;
    notifyListeners();
  }

  /// Resets state back to standard defaults.
  Future<void> resetDefaults() async {
    repository.api.shouldSimulateFailure = false;
    repository.api.isNetworkAvailable = true;
    _isOffline = false;
    await repository.resetToDefaults();
    await fetchCourses(forceRefresh: true);
  }

  /// Updates course item in memory when modified in Screen 3.
  void updateCourse(CourseModel updated) {
    final index = _allCourses.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      _allCourses[index] = updated;
      notifyListeners();
    }
  }
}
