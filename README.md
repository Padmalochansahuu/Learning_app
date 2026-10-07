# LearnHub – Learning Dashboard Mobile App (Android & iOS)

A production-grade, high-performance cross-platform mobile application built with **Flutter**, supporting **both Android and iOS** from a single unified codebase. Designed and architected to strictly satisfy the **Senior Mobile App Developer Technical Assignment** requirements.

---

## 📲 Deliverables & Submission Links (For Evaluators)

| Deliverable | Quick Link | Details |
| :--- | :--- | :--- |
| 🎬 **Demo Video Walkthrough** | **[Watch Demo Video on Google Drive](https://drive.google.com/file/d/1UlewWNbR8Xt-wftHkFcIogu7Vkgb96cE/view?usp=sharing)** | Complete walkthrough showing Login, Dashboard, Course Details, lesson completion, and offline mode. |
| 📦 **Android Release APK** | **[Download Android APK (app-release.apk)](https://drive.google.com/file/d/1nBT4Oj6RpfTTojLfkg1xrIMbCqwYmUH6/view?usp=sharing)** | Signed production APK ready to install and test directly on any Android device. |
| 💻 **Source Code Repository** | **[GitHub Repository](https://github.com/Padmalochansahuu/Learning_app)** | Full Flutter codebase with offline-first MVVM architecture & tests. |

---

## 🛠️ Cross-Platform Framework & Tech Stack

| Specification | Details |
| :--- | :--- |
| **Cross-Platform Framework** | **Flutter** (Dart 3.x) — High performance, native AOT compilation |
| **UI Framework** | **Flutter Material 3** + Custom Design System with Google Fonts (`Outfit` & `Inter`) |
| **Supported Platforms** | **Android** (API 21+ Lollipop through Android 15) & **iOS** (iOS 12.0 through iOS 18+) |
| **Architecture Pattern** | **MVVM (Model-View-ViewModel)** + Offline-First Repository Pattern |
| **State Management** | Reactive `ChangeNotifier` + `Provider` |
| **Local Persistence** | `SharedPreferences` JSON storage for offline-first caching |
| **Platform Configurations** | Native Android (`android/app/src/main/AndroidManifest.xml`) & iOS (`ios/Runner/Info.plist`) configured with app label **LearnHub** |

---

## 📱 App Overview & Screenshots

**LearnHub** provides a streamlined course progress dashboard with offline-first persistence, reactive progress calculations, and comprehensive state handling (Loading, Success, Empty, and Error).

### Exactly 3 Required Screens Implemented (No Extra Screens):
1. **Screen 1 — Login**:
   - Clean email & password inputs with real-time and submission validations.
   - Loading indicator and disabled button during authentication.
   - Comprehensive error banners for invalid credentials or network loss.
   - Quick "Autofill Demo Account" button for evaluator convenience (`student@learnhub.com` / `password123`).
   - Session persistence and navigation to Course Dashboard.

2. **Screen 2 — Course Dashboard**:
   - Real-time catalog showing: Course Title, Instructor Name, Dynamic Progress %, Lessons Count, and Continue button.
   - Complete state handling: **Loading State** (skeleton progress), **Success State** (rich cards + search filter), **Empty State** (dedicated illustration & reset), and **API Failure State** (network failure view + Retry button).
   - Built-in Evaluator Menu (`⋮` / tune icon) to effortlessly test all 4 states on demand:
     - *Simulate Offline Mode* (tests offline cache retrieval)
     - *Simulate API 500 Failure* (tests error state and retry)
     - *Simulate Empty State* (tests empty state handling)
     - *Reset to Defaults* (re-seeds initial assignment data)
   - Pull-to-refresh (`RefreshIndicator`).

3. **Screen 3 — Course Details**:
   - Detailed header showing Course Name, Instructor, and Live Dynamic Progress Bar.
   - Interactive Curriculum list matching assignment specifications (`Introduction`, `Variables & Data Types`, `Functions`, `OOP`, etc.).
   - Interactive tap-to-complete checkmark: toggling a lesson immediately flips its status badge (**Completed ✓** / **Pending ○**) and dynamically recalculates course progress percentage `(completedLessons / totalLessons * 100)`.
   - All state updates immediately persist to local storage and sync back to the Course Dashboard.

---

## 🏛️ Technical Assignment Questions (1-Page Brief)

### 1. Architecture: Why did you choose your architecture?
The application implements **MVVM (Model-View-ViewModel)** with a clean **Offline-First Repository Pattern**:
```
UI (Screens & Reusable Widgets)
       ↓ (Observes state via ChangeNotifier / Provider)
Presentation / ViewModel (AuthViewModel, DashboardViewModel, CourseDetailsViewModel)
       ↓ (Invokes operations & business logic)
Repository Layer (CourseRepository, AuthRepository)
       ↓
Data Sources: Remote Mock API (MockCourseApi) + Local Storage Cache (LocalStorageService)
```
**Why this architecture was chosen:**
- **Separation of Concerns:** Business logic (progress recalculation, validation, cache fallback) is completely isolated from UI rendering.
- **Testability:** ViewModels and Repositories are easily decoupled and tested with unit tests without relying on Flutter UI widgets.
- **Single Source of Truth:** The repository controls data provenance, deciding whether to serve cached offline data or fetch remote data and update the local database.

---

### 2. Offline Support: How are you storing and loading offline data?
- Course data, lesson completion states, and user sessions are stored locally via `LocalStorageService` (backed by persistent JSON key-value storage).
- **Caching Strategy:**
  1. **Online:** When the dashboard loads, it requests data from the remote API, parses the response, and atomically updates the local storage cache.
  2. **Offline Fallback:** If internet is disconnected or the remote endpoint throws an error, `CourseRepository` seamlessly loads previously cached courses without crashing.
  3. **Local Progress Persistence:** When an evaluator or student marks a lesson completed/pending in Screen 3, the updated course entity and recalculated progress are persisted locally, ensuring all changes persist across app restarts and offline sessions.

---

### 3. Security: Where would you store authentication tokens in a production application?
In a production deployment, tokens (JWT access & refresh tokens) should **never** be stored in plaintext `SharedPreferences` or `UserDefaults`. Instead:
- **Android:** Android Keystore via **EncryptedSharedPreferences** (AES-256 GCM encryption backed by hardware security module / TEE).
- **iOS / macOS:** **Keychain Services** with access group flags (`kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`).
- **Flutter Implementation:** Using the battle-tested `flutter_secure_storage` plugin which delegates natively to Android Keystore and iOS Keychain.
- **Network Security:** Enforce HTTPS with SSL Pinning (e.g. certificate/public-key pinning) and biometric biometric authentication (Face ID / Fingerprint) before retrieving tokens from the secure enclave.

---

### 4. Scale: If this application had 1 million users + hundreds of courses, mention 3–5 things you would improve.
1. **Database Migration to SQLite / Isar / Room:** Replace SharedPreferences JSON caching with an indexed relational or embedded NoSQL database (e.g. SQLite/Room on Android, SwiftData/CoreData on iOS, or Drift/Isar in Flutter) with indexed queries for fast multi-course filtering.
2. **Pagination & Virtualized Lazy Loading:** Implement cursor-based pagination (e.g. 15-20 courses per page) with infinite scrolling and lazy list windowing to maintain 60/120 FPS scrolling with minimal memory footprint.
3. **Background Sync Engine with WorkManager / BackgroundTasks:** Use OS-native background scheduling (Android `WorkManager`, iOS `BGAppRefreshTask`) to synchronize lesson progress queues during idle/charging windows with exponential backoff conflict resolution.
4. **CDN Edge Caching & Delta/Diff Syncing:** Distribute course static curriculum over a worldwide CDN (Cloudflare/CloudFront) with ETag/HTTP 304 caching. Sync only mutated lesson deltas (e.g. `PATCH /courses/{id}/lessons/{id}`) rather than re-downloading entire course payloads.
5. **Observability & Analytics:** Integrate Firebase Crashlytics, Datadog/Sentry APM, and OpenTelemetry to track app startup latency, API failures, and offline sync health.

---

### 5. Second Platform Implementation (Cross-Platform & Native Equivalence)

This codebase targets **both Android and iOS simultaneously** from a single unified codebase using **Flutter**.

To directly answer the prompt's requirement (*"Explain how you would implement on the second platform"*), the table below shows how our **Flutter** architecture maps 1:1 onto **Native Android** and **Native iOS/macOS**:

| Architectural Component | This Project (Flutter Cross-Platform) | Native Android Equivalent | Native iOS / macOS Equivalent |
| :--- | :--- | :--- | :--- |
| **UI Framework** | **Flutter Widgets + Material 3** | Kotlin + Jetpack Compose (`@Composable`) | Swift + SwiftUI (`View`) |
| **Architecture** | **MVVM + Clean Repository Pattern** | MVVM + Clean Architecture | MVVM / TCA (The Composable Architecture) |
| **State Management** | **`ChangeNotifier` + `Provider`** | Android `ViewModel` + `StateFlow` / `SharedFlow` | `@Observable` / `@StateObject` + `Combine` |
| **Local Persistence** | **`SharedPreferences` JSON storage** | `Room Database` (SQLite) + `DataStore` | `SwiftData` / `CoreData` + `UserDefaults` |
| **Secure Token Storage** | **`flutter_secure_storage`** | `EncryptedSharedPreferences` (Keystore) | `Keychain Services` (`Security.framework`) |
| **Networking** | **`MockCourseApi` / `http` package** | `Retrofit` / `Ktor` + `OkHttp` | `URLSession` + `Async/Await` |
| **Dependency Injection** | **Provider tree (`MultiProvider`)** | Hilt / Dagger / Koin | Swinject / Swift `@Environment` / Factory |

> **Key Takeaway for Technical Evaluators**:
> Flutter achieves cross-platform execution while compiling to native AOT machine code (ARM64) on both Android (NDK/C++) and iOS (LLVM). The state management, clean architecture, and offline-first repository patterns demonstrated in this codebase translate directly to both Kotlin/Compose and Swift/SwiftUI.

---

## 🌐 Backend & API Architecture: How API Handling & Dummy Data Work

### 1. Why Dummy / Mock Data is Used
The technical assignment specification does not provide a live remote server; instead, it specifies that the app should display realistic course dummy data, handle all network states (Loading, Success, Empty, Error), and demonstrate offline caching.

### 2. How Real API Interaction is Simulated in Code
The data layer in `lib/data/datasources/mock_course_api.dart` accurately emulates a production RESTful microservice:
1. **Realistic Latency Simulation**:
   - `MockCourseApi` uses `await Future.delayed(Duration(milliseconds: 800))` to simulate true round-trip HTTP packet transfer.
2. **REST Endpoints Emulated**:
   - `POST /api/v1/auth/login` → Authenticates email/password, issues mock JWT auth token (`UserModel`).
   - `GET /api/v1/courses` → Returns JSON-serialized catalog of courses with lessons, progress %, instructor avatars, and banners.
3. **HTTP Status Codes & Fault Injection**:
   - `isNetworkAvailable = false` → Simulates connection drop (`SocketException`).
   - `shouldSimulateFailure = true` → Simulates `HTTP 500: Internal Server Error`.
4. **Offline-First Caching Strategy**:
   - `CourseRepository` checks `mockApi.fetchCourses()`. When successful, it caches the raw JSON into `LocalStorageService` (backed by persistent `SharedPreferences`).
   - If network is unreachable or an API exception occurs, `CourseRepository` gracefully serves the cached courses without crashing.
   - When a user toggles lesson progress in Screen 3, the change is saved locally so progress remains persistent even across app restarts.

### 3. How to Connect a Real Backend in Production
Because this app follows the **MVVM + Clean Repository Pattern**, swapping the simulated API for a live cloud backend requires **zero changes** to UI screens, widgets, or ViewModels:
```dart
// Step 1: Create a RemoteCourseApi using 'http' or 'dio'
class RemoteCourseApi {
  final http.Client client;
  final String baseUrl = 'https://api.learnhub.com/v1';

  Future<List<CourseModel>> fetchCourses() async {
    final response = await client.get(Uri.parse('$baseUrl/courses'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CourseModel.fromJson(json)).toList();
    }
    throw HttpException('HTTP ${response.statusCode}: Failed to fetch courses');
  }
}

// Step 2: In lib/main.dart, provide RemoteCourseApi to CourseRepository
Provider<CourseRepository>(
  create: (ctx) => CourseRepository(
    api: RemoteCourseApi(), // Swapped with zero UI or ViewModel changes!
    storage: storageService,
  ),
),
```

---

## 🧪 Automated Test Suite

The project includes **14 comprehensive unit and widget tests** covering:
- **Dynamic Progress Calculation Tests** (`test/unit/progress_calculation_test.dart`):
  - 0% baseline calculation
  - 50% partial progress (2/4 lessons)
  - 100% completion boundary
  - Integer rounding precision (e.g., 2/3 = 67%)
  - Static fallback when lesson list is unpopulated
- **Input Validation Tests** (`test/unit/validators_test.dart`):
  - Email format validation, missing `@`, whitespace handling
  - Password minimum length verification (>= 6 chars)
- **Course Repository & Offline Tests** (`test/unit/course_repository_test.dart`):
  - Online fetch and cache population
  - Offline fallback when network is disconnected
  - Lesson completion toggling, storage mutation, and progress recalculation
- **Widget Integration Smoke Tests** (`test/widget_test.dart`):
  - Login screen widget rendering, input submission, error states, and Autofill action.

To execute the test suite:
```bash
flutter test
```

To run lint analysis:
```bash
flutter analyze
```

---

## 🚀 Running & Building the App (Android & iOS)

### Prerequisites
- **Flutter SDK** (3.13+ or latest 3.x)
- **For Android:** Android Studio, Android SDK (API 21+)
- **For iOS:** Xcode 15+, CocoaPods (macOS environment)

### 1. Fetch Dependencies
```bash
flutter pub get
```

### 2. Run on Devices / Simulators
```bash
# Run on connected Android device or emulator
flutter run -d android

# Run on iOS Simulator or connected iPhone
flutter run -d ios

# Auto-detect available device
flutter run
```

### 3. Production Release Builds (Google Play Store & Shareable APK)

The project includes an end-to-end production signing configuration configured in `android/app/build.gradle.kts` and `android/key.properties`:
- **Package Name / Application ID**: `com.learnhub.app`
- **Keystore**: `android/app/upload-keystore.jks`
- **Key Alias**: `upload`
- **Key & Store Password**: `learnhubpassword123`

#### A. Build Signed Release APK (Direct Install & Sharing)
```bash
flutter build apk --release --target lib/main.dart --build-name=1.0.0 --build-number=1
```
> **Output location**: `build/app/outputs/flutter-apk/app-release.apk`  
> This APK is signed and can be directly shared and installed on any Android phone.  
> 🔗 **Cloud Download**: [Download Pre-built APK from Google Drive](https://drive.google.com/file/d/1nBT4Oj6RpfTTojLfkg1xrIMbCqwYmUH6/view?usp=sharing)

#### B. Build Signed Release AppBundle (AAB) for Google Play Store (with Obfuscation & Symbols)
```bash
flutter build appbundle --release --target lib/main.dart --build-name=1.0.0 --build-number=1 --obfuscate --split-debug-info=/tmp/learnhub-debug-symbols
```
> **Output location**: `build/app/outputs/bundle/release/app-release.aab`
> Upload this `.aab` directly to Google Play Console.

#### C. Build iOS Application
```bash
flutter build ipa --no-codesign
```

---

## 🎨 Design System & Code Organization

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Indigo/Slate/Emerald design palette
│   │   ├── app_typography.dart     # GoogleFonts Outfit & Inter scale
│   │   ├── app_spacing.dart        # Unified padding, radius, and elevation tokens
│   │   └── app_strings.dart        # Centralized text labels & messages
│   ├── theme/
│   │   └── app_theme.dart          # Cohesive Material 3 Light Theme
│   └── utils/
│       └── validators.dart         # Email & password validation regex
├── data/
│   ├── models/
│   │   ├── user_model.dart         # User session & auth model
│   │   ├── lesson_model.dart       # Lesson entity (status, title, duration)
│   │   └── course_model.dart       # Course entity with computed progress
│   ├── datasources/
│   │   ├── mock_course_api.dart    # Mock remote API with latency & error triggers
│   │   └── local_storage_service.dart # SharedPreferences offline persistence
│   └── repositories/
│       ├── auth_repository.dart    # Authentication & session repository
│       └── course_repository.dart  # Offline-first course cache repository
├── viewmodels/
│   ├── auth_viewmodel.dart         # Login validation, state & demo autofill
│   ├── dashboard_viewmodel.dart    # Loading, success, empty, error, offline toggle
│   └── course_details_viewmodel.dart # Lesson toggle & progress recalculation
├── widgets/
│   ├── common/
│   │   ├── custom_button.dart      # Reusable primary/secondary button with loader
│   │   ├── custom_text_field.dart  # Form input with validation styling & icon actions
│   │   ├── status_badge.dart       # Completed ✓ / Pending ○ status badges
│   │   ├── custom_progress_bar.dart# Smooth animated linear progress bar
│   │   ├── error_view.dart         # API failure state with retry button
│   │   └── empty_view.dart         # Empty state view with reset button
│   ├── dashboard/
│   │   ├── course_card.dart        # Course card (title, instructor, progress, lessons, continue)
│   │   └── dashboard_header.dart   # Profile greeting, stats overview & offline toggle
│   └── course_details/
│       ├── lesson_tile.dart        # Tap-to-complete lesson tile
│       └── progress_card.dart      # Live dynamic progress header card
└── screens/
    ├── login_screen.dart           # Screen 1 — Login
    ├── dashboard_screen.dart       # Screen 2 — Course Dashboard
    └── course_details_screen.dart  # Screen 3 — Course Details
```
