# Graft 🌱

**High-performance, fine-grained reactive state management for Flutter.**

Graft combines the architectural safety of single immutable domain states with the pinpoint rebuild performance of slot-diffing and the ergonomic route-stack lifecycle management of modern Flutter apps.

---

## 🌟 Why Graft?

Most Flutter state management solutions force you into an unpleasant compromise:

- **Flutter Bloc** gives you clean architecture and observability, but punishes you with a **"Pyramid of Doom"** (nesting 5 `BlocSelector` widgets just to avoid rebuilding 5 fields in a Column), plus heavy boilerplate.
- **Riverpod** offers dependency injection, but pushes heavily toward **code generation** (`@riverpod`, `build_runner`, `.g.dart` clutter), replaces standard `StatelessWidget` with `ConsumerWidget`, and requires threading `WidgetRef` everywhere.
- **Signals / Solidart** offer fine-grained rebuilds, but **fragment your state** into dozens of loose primitive variables, destroying cohesive domain models.
- **GetX** bypasses Flutter's Element tree and route lifecycles with global mutable state and untyped string lookups, leading to memory leaks.

**Graft solves all of this.**

| Feature / Metric | Flutter Bloc | Riverpod | Signals | **Graft** |
| :--- | :--- | :--- | :--- | :--- |
| **Fine-Grained Rebuilds** | ❌ Manual `BlocSelector` per field | ⚠️ Requires `ref.watch(p.select(...))` | ✅ Rebuilds per signal | ✅ **Automatic**: `graft.column((s) => [ ... ])` diffs slots with **zero manual selectors** |
| **Widget Tree Nesting** | ❌ Deep pyramid (`BlocProvider` → `BlocBuilder`) | ⚠️ `Consumer` / `ConsumerWidget` | ⚠️ `Watch(...)` wrappers | ✅ **Zero Nesting**: `final graft = context.use<MyGraft>()` at top of standard `StatelessWidget` |
| **Code Generation** | ✅ None | ❌ Heavily pushed (`@riverpod`, `build_runner`) | ✅ None | ✅ **Strictly 0 Code-Gen** |
| **State Structure** | ✅ Single immutable class | ✅ Single immutable class | ❌ Fragmented into loose signals | ✅ **Single cohesive, immutable domain State** |
| **Route Stack Sharing** | ⚠️ Manual `BlocProvider.value` | ⚠️ AutoDispose or manual overrides | ⚠️ Manual disposal of effects | ✅ **Automatic**: Inherits from predecessor routes; auto-disposes when owner pops |
| **Subclass Boilerplate** | ⚠️ High (Events, States, Handlers) | ⚠️ High (family providers, code-gen) | ⚠️ High (declaring 10+ signals) | ✅ **Zero**: `class InfoGraft extends Graft<InfoState>` |
| **Observability** | ✅ `BlocObserver` | ⚠️ `ProviderObserver` | ❌ None built-in | ✅ **`GraftObserver` & colorized `GraftDevObserver`** |
| **Unit Testing** | ✅ Declarative `blocTest` | ⚠️ `ProviderContainer` manual tests | ⚠️ Manual effects | ✅ **Declarative `graftTest` (Pure Dart, sub-millisecond)** |

---

## ⚡ Quick Comparison: Column Rebuilds

### Traditional Flutter Bloc (35 lines of nested selectors):
```dart
// ❌ Bloc: Manual selector pyramid of doom to prevent rebuilds
Column(
  children: [
    const HeaderBanner(),
    BlocSelector<UserBloc, UserState, String>(
      selector: (s) => s.name,
      builder: (context, name) => Text(name),
    ),
    BlocSelector<UserBloc, UserState, String>(
      selector: (s) => s.email,
      builder: (context, email) => Text(email),
    ),
    BlocSelector<UserBloc, UserState, bool>(
      selector: (s) => s.isVerified,
      builder: (context, verified) => verified ? const VerifiedBadge() : const SizedBox(),
    ),
  ],
)
```

### With Graft (Clean, normal Flutter list):
```dart
// ✅ Graft: Normal list! The slot diff engine isolates each child automatically.
graft.column((s) => [
  const HeaderBanner(), // const: 0 rebuilds!
  Text(s.name),         // Only rebuilds when name changes!
  Text(s.email),        // 0 rebuilds if email didn't change!
  if (s.isVerified) const VerifiedBadge(),
])
```

---

## 🚀 Getting Started

### 1. Define Your State (Zero-Boilerplate with `GraftState`)
No `copyWith()`, no `Equatable`, and zero code generation:

```dart
import 'package:graft/graft.dart';

class UserState extends GraftState {
  String name = '';
  String email = '';
  bool isVerified = false;
  bool isLoading = false;
}
```

### 2. Create Your Graft
Extend `Graft<S extends GraftState>` and use fluent cascade mutation (`state..update()`):

```dart
import 'package:graft/graft.dart';

class UserGraft extends Graft<UserState> {
  UserGraft() : super(UserState());

  void updateName(String newName) {
    state
      ..name = newName
      ..update(); // Triggers fine-grained slot diffing!
  }

  void updateProfile({required String name, required String email}) {
    // Multi-property updates batch into a single 0-rebuild diff pass:
    state
      ..name = name
      ..email = email
      ..isLoading = false
      ..update();
  }

  void toggleVerified() {
    state
      ..isVerified = !state.isVerified
      ..update();
  }
}
```

### Need a Single Primitive Value? (Zero State Class with `ValueGraft<T>`)
For simple counters, themes, or flags, use `ValueGraft<T>` with **no state class needed**:

```dart
class CounterGraft extends ValueGraft<int> {
  CounterGraft() : super(0);

  void increment() => value++;
  void decrement() => value--;
}

class ThemeGraft extends ValueGraft<ThemeMode> {
  ThemeGraft() : super(ThemeMode.system);

  void toggle() => value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
}
```

### 3. Register in DI
Register your Graft once at app startup:

```dart
// Route-scoped (default): Created on first use, auto-disposed when owner route pops:
GraftRegistry.register(UserGraft.new);

// Global Singleton (lazy by default): Never re-created, never route-disposed!
GraftRegistry.registerSingleton(AuthGraft.new);

// Eager Singleton (instantiated immediately at startup):
GraftRegistry.registerSingleton(ThemeGraft.new, lazy: false);
```

Then in any screen, simply call:
```dart
final graft = context.use<UserGraft>();
```
Zero lambdas in the UI!

### 4. Connect to Navigator Observer (Route Lifecycle)
In your `MaterialApp` or router configuration:

```dart
MaterialApp(
  navigatorObservers: [GraftRouteObserver()],
  // ...
)
```

---

## 📱 Using Graft in Widgets

### Accessing Graft in a Screen
No `BlocProvider` wrappers needed! Simply call `context.use<T>()` at the top of your `StatelessWidget`:

```dart
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Looks in current route and previous routes in the navigation stack.
    // If not found, instantiates a new one and marks THIS screen as OWNER.
    final graft = context.use<UserGraft>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: graft.column((s) => [
        const HeaderBanner(),
        Text(s.name, style: Theme.of(context).textTheme.headlineMedium),
        Text(s.email),
        if (s.isVerified) const VerifiedBadge(),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => graft.updateName('New Name'),
          child: const Text('Change Name'),
        ),
      ]),
    );
  }
}
```

### Sharing Across the Navigation Stack
When Screen A pushes Screen B:
```dart
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Automatically reuses Screen A's active UserGraft instance!
    final graft = context.use<UserGraft>();

    return Scaffold(
      body: graft.column((s) => [ ... ]),
    );
  }
}
```
- **When Screen B pops**: `UserGraft` is **NOT** disposed (Screen B is just borrowing it).
- **When Screen A pops**: `UserGraft.dispose()` is called **automatically** (Screen A was the owner).

### Force New Instance
If you explicitly want a separate, independent instance on a new screen:
```dart
final graft = context.create<UserGraft>();
```

### Pure Lookup (Read-Only)
To find an active instance in the route stack without creating one:
```dart
final graft = context.find<UserGraft>();
```

---

## 🎨 UI Layout Engine

### Multi-Child Slot Diffing:
- `graft.column((s) => [ ... ])`
- `graft.row((s) => [ ... ])`
- `graft.stack((s) => [ ... ])`
- `graft.wrap((s) => [ ... ])`

### Non-List Widgets (Independent Slot Diffing):
- `graft.listTile(leading: (s) => ..., title: (s) => ..., subtitle: (s) => ..., trailing: const Icon(...))`
- `graft.padding(padding: EdgeInsets.all(16), child: (s) => ...)`
- `graft.card(child: (s) => ...)`
- `graft.center(child: (s) => ...)`

### Single-Slot Diffing:
```dart
// Rebuilds ONLY when the returned widget changes:
graft.slot((s) => Text(s.name))
```

### Full-Page State Switching:
```dart
graft.layout((context, s) {
  if (s.isLoading) return const CircularProgressIndicator();
  if (s.hasError) return Text(s.error);
  return ContentView(data: s.data);
})
```

### Self-Invented & 3rd-Party Custom Widgets:
Use `graft.watch` or `graft.select` anywhere in your widget tree:
```dart
graft.watch((s) => MyCustomSelfInventedWidget(
  data: s.customData,
  accentColor: s.themeColor,
))

// Granular selector: only rebuilds when `isVerified` changes:
graft.select((s) => s.isVerified, (isVerified) => VerifiedBadge(active: isVerified))
```

### Custom Slot Equivalence (`GraftEquivalent`):
For complex custom widgets in multi-child lists, implement `GraftEquivalent` to customize diffing:
```dart
class UserCard extends StatelessWidget implements GraftEquivalent {
  final String name;
  const UserCard(this.name, {super.key});

  @override
  bool isEquivalentTo(Widget other) =>
      other is UserCard && name == other.name;

  @override
  Widget build(BuildContext context) => Text(name);
}
```

---

## 🔍 Observability: `GraftObserver`

Track all creations, transitions, errors, and disposals globally:

```dart
void main() {
  // Enable colorized dev logging in console:
  Graft.observer = GraftDevObserver();

  runApp(const MyApp());
}
```

Console output:
```bash
[🌱 GRAFT CREATED]  UserGraft
[⚡ GRAFT CHANGE]   UserGraft
  UserState(name: Alice)
  ➡️ UserState(name: Bob)
[🗑️ GRAFT DISPOSED] UserGraft
```

---

## 🧪 Declarative Unit Testing: `graftTest`

Test your business logic cleanly in sub-milliseconds without widget tree overhead:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:graft/graft.dart';
import 'package:graft/testing.dart';

void main() {
  group('UserGraft', () {
    graftTest<UserGraft, UserState>(
      'emits updated name when updateName is called',
      build: () => UserGraft(),
      act: (graft) => graft.updateName('Bob'),
      expect: () => [
        const UserState(name: 'Bob'),
      ],
    );

    graftTest<UserGraft, UserState>(
      'supports async delays with wait parameter',
      build: () => UserGraft(),
      act: (graft) => graft.fetchProfile(),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        const UserState(isLoading: true),
        const UserState(isLoading: false, name: 'Alice'),
      ],
      verify: (graft) {
        // verify mocks or assertions
      },
    );
  });
}
```

---

## 📄 License

MIT License. Free to use, modify, and distribute.
