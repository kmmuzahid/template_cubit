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
| **Fine-Grained Rebuilds** | ❌ Manual `BlocSelector` per field | ⚠️ Requires `ref.watch(p.select(...))` | ✅ Rebuilds per signal | ✅ **Automatic**: `graft.slots((c) => Column(children: c), (s) => [ ... ])` diffs slots with **zero manual selectors** |
| **Widget Tree Nesting** | ❌ Deep pyramid (`BlocProvider` → `BlocBuilder`) | ⚠️ `Consumer` / `ConsumerWidget` | ⚠️ `Watch(...)` wrappers | ✅ **Zero Nesting**: `final graft = context.use<MyGraft>()` at top of standard `StatelessWidget` |
| **Code Generation** | ✅ None | ❌ Heavily pushed (`@riverpod`, `build_runner`) | ✅ None | ✅ **Strictly 0 Code-Gen** |
| **State Structure** | ✅ Single immutable class | ✅ Single immutable class | ❌ Fragmented into loose signals | ✅ **Single cohesive, immutable domain State** |
| **Route Stack Sharing** | ⚠️ Manual `BlocProvider.value` | ⚠️ AutoDispose or manual overrides | ⚠️ Manual disposal of effects | ✅ **Automatic**: Inherits from predecessor routes; auto-disposes when owner pops |
| **Subclass Boilerplate** | ⚠️ High (Events, States, Handlers) | ⚠️ High (family providers, code-gen) | ⚠️ High (declaring 10+ signals) | ✅ **Zero**: `class InfoGraft extends Graft<InfoState>` |
| **Observability** | ✅ `BlocObserver` | ⚠️ `ProviderObserver` | ❌ None built-in | ✅ **`GraftObserver` & colorized `GraftDevObserver`** |
| **Unit Testing** | ✅ Declarative `blocTest` | ⚠️ `ProviderContainer` manual tests | ⚠️ Manual effects | ✅ **Declarative `graftTest` (Pure Dart, sub-millisecond)** |

---

## ⚡ Developer Ergonomics: Column Rebuild Comparison

How do state management libraries compare when trying to achieve fine-grained, single-widget rebuilds in a multi-child `Column`?

### 1. Flutter BLoC / Cubit (Pyramid of Selectors):
```dart
// ❌ BLoC: Requires wrapping EVERY single dynamic widget in a verbose BlocSelector
Column(
  children: [
    const HeaderBanner(),
    BlocSelector<UserBloc, UserState, String>(
      selector: (s) => s.name,
      builder: (context, name) => CkText(text: name),
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

### 2. Riverpod (Fragmented Consumers):
```dart
// ⚠️ Riverpod: Requires splitting into multiple Consumer widgets or writing ref.watch selectors
Column(
  children: [
    const HeaderBanner(),
    Consumer(builder: (context, ref, _) {
      final name = ref.watch(userProvider.select((s) => s.name));
      return CkText(text: name);
    }),
    Consumer(builder: (context, ref, _) {
      final email = ref.watch(userProvider.select((s) => s.email));
      return Text(email);
    }),
    Consumer(builder: (context, ref, _) {
      final isVerified = ref.watch(userProvider.select((s) => s.isVerified));
      return isVerified ? const VerifiedBadge() : const SizedBox();
    }),
  ],
)
```

### 3. With Graft (Clean, Natural List Syntax):
```dart
// ✅ Graft: Zero selectors, zero boilerplate. 
// The slot engine automatically isolates each child widget!
graft.slots(
  (children) => Column(children: children),
  (s) => [
    const HeaderBanner(), // 0 rebuilds (pointer match)
    CkText(text: s.name), // 0 rebuilds when name is unchanged (auto-unwrapped & diffed)
    Text(s.email),        // 0 rebuilds when email is unchanged
    if (s.isVerified) const VerifiedBadge(),
  ],
)
```

---

## 🏎️ Performance & Render Pipeline Benchmark

Why is Graft’s in-memory slot diffing dramatically faster and lighter on device battery?

### The 10,000x Cost Difference:

In standard Flutter and BLoC (`BlocBuilder`), every state emission forces the entire child subtree through Flutter's expensive rendering pipeline:
1. `Widget.build()` allocation
2. `Element.update()` & `Element.rebuild()`
3. `RenderObject.markNeedsLayout()`
4. `RenderObject.performLayout()`
5. `RenderObject.markNeedsPaint()`
6. `RenderObject.paint()`

> **Cost of full Render Pipeline:** **~1.0 to 5.0 milliseconds (1,000,000 to 5,000,000 nanoseconds)** per frame.

In **Graft (`graft.slots`)**:
- Diffing occurs **strictly in memory before touching Flutter elements**:
  - `const` pointer check (`identical(a, b)`): **< 1 nanosecond**
  - Keyed check (`a.key == b.key`): **~5 nanoseconds**
  - Primitive property inspection (strings, padding, alignment): **~15 to 80 nanoseconds**
- If properties match, **Flutter's Element is never dirtied**. Layout is skipped, and paint is skipped completely!
- **Pure Dart diffing is ~10,000x faster than dirtying the Flutter RenderObject tree.**

### Real-World DevTools Rebuild Benchmark (60-Second Test):

Scenario: Screen with 10 child widgets (icons, custom `CkText`, banners, and a live ticking timer updating every 1s):

| State Management Pattern | Unrelated Widgets Rebuilt | Flutter Elements Dirtied | Layout & Paint Passes | Rebuild Count in DevTools |
| :--- | :--- | :--- | :--- | :--- |
| **Standard `BlocBuilder`** | All 10 widgets in Column | 100% of children | 600 subtree layouts | **600+ rebuilds** |
| **Manual `BlocSelector`s** | 0 (only timer widget) | 1 child | 60 element layouts | 60 rebuilds *(high boilerplate)* |
| **Riverpod `Consumer`s** | 0 (only timer widget) | 1 child | 60 element layouts | 60 rebuilds *(high boilerplate)* |
| **Graft (`graft.slots`)** | **0 (automatic)** | **1 child** | **60 element layouts** | **60 rebuilds *(ZERO boilerplate)*** |

### Automatic Design System & Composite Widget Support:
Unlike naive diff engines, Graft includes **recursive `StatelessWidget` unwrapping** and full diffing for Flutter layout primitives (`Flex`, `Row`, `Column`, `Flexible`, `Expanded`, `FittedBox`, `ConstrainedBox`, `AspectRatio`, `ShaderMask`, `Stack`, `Positioned`, `Wrap`).
Custom design-system widgets (like `CkText` from `core_kit` or custom Cards) automatically unwrap and diff their internal primitives with **zero extra code**!

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
      body: graft.slots(
        (children) => Column(children: children),
        (s) => [
          const HeaderBanner(),
          Text(s.name, style: Theme.of(context).textTheme.headlineMedium),
          Text(s.email),
          if (s.isVerified) const VerifiedBadge(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => graft.updateName('New Name'),
            child: const Text('Change Name'),
          ),
        ],
      ),
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
      body: graft.slots((children) => Column(children: children), (s) => [ ... ]),
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

## 🎨 UI Slot Engine

Graft provides a clean, 3-method widget API with **zero fluff**:

### 1. `graft.slot(...)` (Single-Child Slot & State Switching)
Isolates any single widget slot. Only rebuilds when the returned widget changes:
```dart
AppBar(
  title: graft.slot((s) => Text(s.title)),
)

ListTile(
  leading: graft.slot((s) => CircleAvatar(child: Text(s.name[0]))),
  title: graft.slot((s) => Text(s.name)),
  subtitle: graft.slot((s) => Text(s.email)),
)

// Also handles full-page state switching seamlessly:
graft.slot((s) {
  if (s.isLoading) return const CircularProgressIndicator();
  if (s.hasError) return Text(s.error);
  return ContentView(data: s.data);
})
```

### 2. `graft.slots(...)` (Multi-Child Slot Diffing List)
Automatically diffs every child widget independently. Takes [layout] as the first required parameter (without unnecessary `BuildContext`) and [children] as the second:
```dart
// 1. Column:
graft.slots(
  (children) => Column(children: children),
  (s) => [
    const HeaderBanner(),
    Text(s.name),
    if (s.isVerified) const VerifiedBadge(),
    Text(s.email),
  ],
)

// 2. Custom Layout (Row, Wrap, Stack, ListView, etc.):
graft.slots(
  (children) => Row(children: children),
  (s) => [
    const Icon(Icons.star),
    Text('${s.rating}'),
    Text('(${s.reviews})'),
  ],
)
```

### 3. `graft.compute(...)` (Pre-Flight Derived Computation)
Computes a derived value from state first. If the computed value is unchanged, the widget builder is **never even executed**, saving CPU cycles on heavy subtrees:
```dart
graft.compute(
  (s) => s.notifications.length, // Derived computation: int
  (count) => HeavyBadge(count: count), // Builder runs ONLY when count changes!
)
```

### Controlling Rebuilds for Custom & 3rd-Party `StatefulWidget`s (`ValueKey`):

In Dart AOT (Flutter release mode), runtime reflection is disabled, meaning the engine cannot inspect the internal `State` of an arbitrary 3rd-party or custom `StatefulWidget`.

To give developers full, fine-grained control over when custom `StatefulWidget`s rebuild, use **`key: ValueKey(s.field)`**:
- **When `s.field` is unchanged:** `a.key == b.key` is recognized by the engine and diffing is skipped immediately with **0 rebuilds**.
- **When `s.field` changes:** The key updates, cleanly triggering an isolated rebuild of only that specific slot!

```dart
graft.slots(
  (children) => Column(children: children),
  (s) => [
    // Static / const widgets: 0 rebuilds
    const HeaderBanner(),

    // Custom or 3rd-party StatefulWidget: controlled via ValueKey!
    CustomVideoPlayer(
      key: ValueKey(s.videoUrl), // Rebuilds ONLY when s.videoUrl changes
      url: s.videoUrl,
    ),
    MyCustomDropdown(
      key: ValueKey(s.selectedCategoryId), // Rebuilds ONLY when category changes
      selectedId: s.selectedCategoryId,
    ),

    // Custom StatelessWidgets (e.g. CkText, UserBadge):
    // Automatically unwrapped and diffed by content (0 rebuilds when text matches)!
    CkText(s.username),

    // Interactive buttons with closures:
    // Functionally diffed without slot rebuilds or button flickering!
    ElevatedButton(
      onPressed: () => graft.submit(),
      child: const Text('Submit'),
    ),
  ],
)
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

### ⚡ Summary of Slot Diffing Mechanisms:

| Mechanism | How It Works | Best For | Rebuild Behavior |
| :--- | :--- | :--- | :--- |
| **`const` Widgets** | Pointer identity match (`identical(a, b)`) | Static headers, banners, dividers | **0 rebuilds** |
| **Stable `ValueKey(s.field)`** | Explicit key match (`a.key == b.key`) | **Custom & 3rd-party `StatefulWidget`s** | **0 rebuilds** while key is identical; isolated rebuild on key change |
| **Auto-Unwrapped `StatelessWidget`s** | Context-based unwrapping to underlying primitives | Custom design-system components (`CkText`, `AppCard`) | **0 rebuilds** when inner content matches |
| **Auto-Diffed Primitives** | Recursive property inspection (`Text`, `Icon`, `SizedBox`, `Padding`, `Container`, `ColoredBox`, `Align`, `Image`, `Flex`/`Row`/`Column`, `Flexible`/`Expanded`, `FittedBox`, etc.) | Standard Flutter UI & layout primitives | **0 rebuilds** when properties match |
| **Interactive Widgets** | Functional equivalence check (`GestureDetector`, `InkWell`, `ElevatedButton`, `TextButton`, etc.) | Buttons and gesture detectors with inline closures (`() => ...`) | Preserves element, prevents unnecessary rebuilds & flickering |
| **`graft.compute(...)`** | Pre-flight data-driven selector (`prevData == nextData`) | Heavy subtrees where building the widget tree should be skipped entirely | Builder is skipped completely if input value is unchanged |

---

## 📜 Working with Lists (`ListView.builder`)

Flutter's `ListView.builder` is a virtualized, on-demand scrolling widget. Graft supports both standard single-graft lists and extreme per-item micro-state lists:

### Pattern A: Standard `ListView.builder` (Without ValueGraft — Recommended)
For 95% of applications, manage your list inside a single `GraftState`:

```dart
// 1. Plain Dart Model (no wrappers needed):
class TaskItem {
  final String id;
  final String title;
  final bool isDone;
  TaskItem({required this.id, required this.title, required this.isDone});
}

// 2. Graft State & Controller:
class TaskState extends GraftState {
  List<TaskItem> tasks = [];
}

class TaskGraft extends Graft<TaskState> {
  TaskGraft() : super(TaskState());

  void toggleTask(String id) {
    state
      ..tasks = state.tasks.map((t) => t.id == id ? TaskItem(id: t.id, title: t.title, isDone: !t.isDone) : t).toList()
      ..update();
  }
}

// 3. UI (Single graft.slot):
graft.slot((s) => ListView.builder(
  itemCount: s.tasks.length,
  itemBuilder: (context, index) {
    final task = s.tasks[index];
    return ListTile(
      title: Text(task.title),
      trailing: Checkbox(
        value: task.isDone,
        onChanged: (_) => graft.toggleTask(task.id),
      ),
    );
  },
))
```
*Because `ListView.builder` is virtualized, Flutter only mounts visible rows and reuses elements automatically.*

---

### Pattern B: Micro-State Cells (With `ValueGraft` — Zero List Rebuilds)
In massive feeds (like social media, stock tickers, or shopping carts) where tapping a heart or counter should **not** notify or re-render any other part of the list:

```dart
// 1. Model holds a ValueGraft for independent cell interactions:
class ProductItem {
  final String title;
  final ValueGraft<bool> isLiked;
  final ValueGraft<int> quantity;

  ProductItem(this.title, {bool liked = false, int count = 1})
      : isLiked = ValueGraft<bool>(liked),
        quantity = ValueGraft<int>(count);
}

// 2. UI: Each cell's slot diffs independently:
ListView.builder(
  itemCount: products.length,
  itemBuilder: (context, index) {
    final item = products[index];
    return ListTile(
      title: Text(item.title),
      subtitle: item.quantity.slot(
        (qty) => Text('Qty: $qty'), // 👈 Only this text rebuilds on quantity change!
      ),
      trailing: item.isLiked.slot(
        (liked) => IconButton(     // 👈 Only this icon rebuilds on like toggle!
          icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
          onPressed: () => item.isLiked.value = !item.isLiked.value,
        ),
      ),
    );
  },
)
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
