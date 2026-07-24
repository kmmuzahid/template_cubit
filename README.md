# Cubit Template

A highly structured, production-ready Flutter template designed for building scalable, responsive, and maintainable applications. It comes pre-configured with **Cubit (Bloc)** for state management, **AutoRoute** for declarative type-safe routing, and **CoreKit** for UI components, networking, and security.

---

## 🚀 Tech Stack & Core Libraries

- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) / **Cubit** for lightweight and robust state management.
- **Declarative Routing**: [auto_route](https://pub.dev/packages/auto_route) for automated, type-safe navigation, route guards, and deep-linking support.
- **Core Utility Package**: [core_kit](file:///Users/username/Documents/km%20muzahid/flutter_core_kit) (built-in) which provides:
  - Responsive screen scaling (`.w`, `.h`, `.sp`, `.r` utilities).
  - Production-ready UI widgets (`CkButton`, `CkText`, `CkTextField`, `CkAppBar`, etc.).
  - Robust networking Layer (`CkTransport` based on Dio) with auto-token refresh & request retries.
  - Secure storage wrapper (`CkStorage` using Keychain/Keystore and fallback).
  - Fully integrated Authentication module (`CkAuthService` / `ckAuth`).
- **Dependency Injection**: [get_it](https://pub.dev/packages/get_it) for fast service locator access.
- **Model Serialization**: [json_serializable](https://pub.dev/packages/json_serializable) for automatic code generation of models.

---

## 📁 Project Directory Structure

```lis
lib/
├── config/
│   ├── api/          # API endpoint declarations
│   ├── color/        # ThemeColor styling & extensions (Dark/Light configurations)
│   ├── dependency/   # GetIt locator configurations
│   ├── route/        # AutoRoute definitions, observers, and navigation guards
│   └── theme/        # Custom ThemeData configurations, fonts, and theme-switching Cubits
│
├── features/         # Modular feature-by-feature layout
│   ├── auth/         # Authentication flow: Screen, models, entities, and helper logic
│   ├── home/         # Home/Dashboard screen and dashboard widgets
│   ├── splash/       # Launch splash screen, timers, and initial checks
│   └── common/       # Shared project-wide widgets (e.g. AppScreenLayout)
│
├── corekit_config_impl.dart  # Custom implementations and hooks for CoreKit bootstrapping
├── my_app.dart               # Theme setup, MultiBlocProvider setup, and MaterialApp registration
└── main.dart                 # Application entry point
```

---

## 🔧 CoreKit Integration

### 1. Bootstrapping Configurations
`CorekitConfigImpl` extends `CoreKitConfig` and implements all global parameters required for networking, design dimensions, and splash delay:
- **`appbarConfig`**: Standardized default app bar alignments (e.g., center alignment).
- **`designSize`**: Base resolution for responsive scaling (default: `428 x 926`).
- **`ckTransportConfig`**: Base URLs and debug options for API networking.
- **`authConfig`**: Endpoint mappings and login request body mappings, automatically routing between authentication flows.

### 2. Global Authentication Flow
The package auto-manages authentication states dynamically:
- Upon loading, CoreKit checks credentials via `CkAuthService` and invokes handlers defined in `CorekitConfigImpl`:
  - **`onAuthenticated`**: Invoked on success, redirecting to `HomeRoute()`.
  - **`showLogin`**: Invoked if credentials are missing or expired, redirecting to `LoginRoute()`.

---

## 🛣️ Declarative Routing (AutoRoute)

Routes are defined under `lib/config/route/app_router.dart`. Annotating screen classes with `@RoutePage()` compiles them into router definitions automatically.

### Running Code Generation
To generate paths and router mappings, run the build runner command:
```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### Navigating between screens
Use the global `appRouter` instance to navigate:
```dart
appRouter.push(const LoginRoute()); // Navigate forward
appRouter.replaceAll([const HomeRoute()]); // Clear stack and navigate
```

---

## 📦 State Management Pattern (Cubit)

State management utilizes `SafeCubit` (which prevents emitting states after a controller is disposed) and `CubitScope` to initialize and bind cubits to screen widget lifecycles.

### Usage Example
```dart
CubitScope<SplashCubit, bool>(
  create: () => SplashCubit()..init(),
  builder: (context, cubit, state) {
    if (state) {
      return const CircularProgressIndicator();
    }
    return const SizedBox.shrink();
  },
);
```

---

## 🎨 Design & Layout Guidelines

- **Theme Extensibility**: Access project colors directly using `context.colors` (extends context with active theme colors, e.g. `context.colors.background`).
- **Responsive Layouts**: Use `.w` (width), `.h` (height), `.sp` (font size), `.r` (radius) on standard Flutter containers.
- **Core Widgets**: Prefer standard `Ck` prefixed UI components (`CkText`, `CkButton`, `CkTextField`) to ensure cohesive design tokens, fonts, and styles.
