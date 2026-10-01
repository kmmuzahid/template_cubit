import 'package:flutter/widgets.dart';
import '../core/graft.dart';
import '../core/graft_state.dart';

/// Interface for custom widgets to declare fine-grained content equivalence for slot diffing.
///
/// ### Why implement GraftEquivalent?
/// In Flutter, `Widget.operator ==` is marked `@nonVirtual` by default linter rules.
/// Implementing [GraftEquivalent] allows your custom widgets to define custom equivalence rules
/// without triggering linter warnings, allowing [GraftMultiChildDiffEngine] to skip rebuilding
/// whenever [isEquivalentTo] returns `true`.
///
/// ### Example:
/// ```dart
/// class UserAvatar extends StatelessWidget implements GraftEquivalent {
///   final String url;
///   const UserAvatar(this.url);
///
///   @override
///   bool isEquivalentTo(Widget other) => other is UserAvatar && other.url == url;
///
///   @override
///   Widget build(BuildContext context) => Image.network(url);
/// }
/// ```
abstract interface class GraftEquivalent {
  /// Returns whether this widget is equivalent to [other] for slot diffing.
  bool isEquivalentTo(Widget other);
}

/// Engine that performs fine-grained diffing on multi-child layout slots.
///
/// ### Why use GraftMultiChildDiffEngine?
/// In standard Flutter, modifying a single field inside a state model causes every widget inside
/// a parent `Column` or `Row` to rebuild.
/// [GraftMultiChildDiffEngine] wraps each child returned by [childrenBuilder] in an isolated
/// notifier slot. When state changes:
/// - `const` children: **0 rebuilds** (pointer identity match).
/// - Content equivalent children: **0 rebuilds** (evaluated via [isWidgetEquivalent]).
/// - Only slots with modified content trigger a rebuild in Flutter's render pipeline.
///
/// Powering methods like `graft.column(...)`, `graft.row(...)`, `graft.stack(...)`, and `graft.wrap(...)`.
class GraftMultiChildDiffEngine<S extends GraftState> extends StatefulWidget {
  /// The [Graft] controller providing state updates.
  final Graft<S> graft;

  /// Layout wrapper (e.g. `(children) => Column(children: children)`) receiving isolated slot widgets.
  final Widget Function(List<Widget> children) layoutBuilder;

  /// Builder returning the list of children widgets based on current [S].
  final List<Widget> Function(S state) childrenBuilder;

  /// Creates a [GraftMultiChildDiffEngine] that manages isolated slot rebuilds.
  const GraftMultiChildDiffEngine({
    super.key,
    required this.graft,
    required this.layoutBuilder,
    required this.childrenBuilder,
  });

  /// Compares two widgets for content equivalence to prevent unnecessary slot rebuilds.
  ///
  /// ### How Slot Diffing Works:
  /// 1. **`const` Widgets:** Any widget marked `const` is skipped immediately with **0 rebuilds**
  ///    via pointer identity (`identical(a, b)`).
  /// 2. **Custom Equivalence:** Evaluates [GraftEquivalent.isEquivalentTo] or `operator ==`.
  /// 3. **Supported Primitives:** Recursively property-diffed for [Text], [Icon], [SizedBox],
  ///    [Padding], [Container], [ColoredBox], and [Align]/[Center].
  ///
  /// ⚠️ **Depth Limits & Arbitrary Widgets:**
  /// Widget-diffing can only inspect properties of widgets it explicitly understands.
  /// If a child contains unhandled widgets (e.g. `Card`, `InkWell`, `ListTile`, or 3rd-party widgets
  /// like `CkText`), or has inline closures (`onTap: () => ...`), widget equality fails and that
  /// slot rebuilds.
  ///
  /// 👉 For arbitrary widgets, deep hierarchies, or widgets with callbacks, use **`graft.compute(...)`**
  /// to achieve guaranteed 0-rebuild data-driven isolation.
  static bool isWidgetEquivalent(Widget a, Widget b) {
    if (a.runtimeType != b.runtimeType) return false;
    if (a.key != b.key) return false;

    // Custom GraftEquivalent interface
    if (a is GraftEquivalent) {
      return (a as GraftEquivalent).isEquivalentTo(b);
    }

    // Text widget comparison
    if (a is Text && b is Text) {
      return a.data == b.data &&
          a.style == b.style &&
          a.textAlign == b.textAlign &&
          a.maxLines == b.maxLines &&
          a.overflow == b.overflow;
    }

    // Icon widget comparison
    if (a is Icon && b is Icon) {
      return a.icon == b.icon &&
          a.size == b.size &&
          a.color == b.color &&
          a.semanticLabel == b.semanticLabel;
    }

    // SizedBox comparison
    if (a is SizedBox && b is SizedBox) {
      return a.width == b.width && a.height == b.height;
    }

    // Padding comparison
    if (a is Padding && b is Padding) {
      final childEqual = (a.child == null && b.child == null) ||
          (a.child != null && b.child != null && isWidgetEquivalent(a.child!, b.child!));
      return childEqual && a.padding == b.padding;
    }

    // Container comparison
    if (a is Container && b is Container) {
      final childEqual = (a.child == null && b.child == null) ||
          (a.child != null && b.child != null && isWidgetEquivalent(a.child!, b.child!));
      if (!childEqual) return false;

      return a.color == b.color &&
          a.padding == b.padding &&
          a.margin == b.margin &&
          a.alignment == b.alignment &&
          a.decoration == b.decoration &&
          a.constraints == b.constraints &&
          a.clipBehavior == b.clipBehavior;
    }

    // ColoredBox comparison
    if (a is ColoredBox && b is ColoredBox) {
      final childEqual = (a.child == null && b.child == null) ||
          (a.child != null && b.child != null && isWidgetEquivalent(a.child!, b.child!));
      return childEqual && a.color == b.color;
    }

    // Align & Center comparison
    if (a is Align && b is Align) {
      final childEqual = (a.child == null && b.child == null) ||
          (a.child != null && b.child != null && isWidgetEquivalent(a.child!, b.child!));
      return childEqual &&
          a.alignment == b.alignment &&
          a.widthFactor == b.widthFactor &&
          a.heightFactor == b.heightFactor;
    }

    // Direct object equality if overridden
    return a == b;
  }

  @override
  State<GraftMultiChildDiffEngine<S>> createState() =>
      _GraftMultiChildDiffEngineState<S>();
}

class _GraftMultiChildDiffEngineState<S extends GraftState>
    extends State<GraftMultiChildDiffEngine<S>> {
  late List<ValueNotifier<Widget>> _slotNotifiers;

  @override
  void initState() {
    super.initState();
    _initSlots();
    widget.graft.addListener(_onStateChanged);
  }

  void _initSlots() {
    final initialWidgets = GraftScopeGuard.run(
      widget.graft,
      'graft.slots',
      () => widget.childrenBuilder(widget.graft.state),
    );
    _slotNotifiers = initialWidgets.map((w) => ValueNotifier<Widget>(w)).toList();
  }

  void _disposeSlots() {
    for (final notifier in _slotNotifiers) {
      notifier.dispose();
    }
    _slotNotifiers.clear();
  }

  @override
  void didUpdateWidget(covariant GraftMultiChildDiffEngine<S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.graft != widget.graft) {
      oldWidget.graft.removeListener(_onStateChanged);
      _disposeSlots();
      _initSlots();
      widget.graft.addListener(_onStateChanged);
    }
  }

  void _onStateChanged() {
    if (!mounted) return;

    final newWidgets = GraftScopeGuard.run(
      widget.graft,
      'graft.slots',
      () => widget.childrenBuilder(widget.graft.state),
    );

    // If child count changed (e.g. conditional if-statement), rebuild container
    if (newWidgets.length != _slotNotifiers.length) {
      _disposeSlots();
      _slotNotifiers = newWidgets.map((w) => ValueNotifier<Widget>(w)).toList();
      setState(() {});
      return;
    }

    // Diff each slot individually
    for (int i = 0; i < newWidgets.length; i++) {
      final oldWidget = _slotNotifiers[i].value;
      final newWidget = newWidgets[i];

      // 1. Const identity match -> 0 rebuilds
      if (identical(oldWidget, newWidget)) {
        continue;
      }

      // 2. Content equivalence match -> 0 rebuilds
      if (GraftMultiChildDiffEngine.isWidgetEquivalent(oldWidget, newWidget)) {
        continue;
      }

      // 3. Changed slot -> update notifier to trigger isolated rebuild for slot i
      _slotNotifiers[i].value = newWidget;
    }
  }

  @override
  void dispose() {
    widget.graft.removeListener(_onStateChanged);
    _disposeSlots();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wrappedChildren = List<Widget>.generate(_slotNotifiers.length, (i) {
      return _ChildSlotScope(
        key: ValueKey(i),
        graft: widget.graft,
        notifier: _slotNotifiers[i],
      );
    });

    return widget.layoutBuilder(wrappedChildren);
  }
}

/// An isolated slot scope that rebuilds only when its specific slot notifier fires.
class _ChildSlotScope extends StatelessWidget {
  final Graft graft;
  final ValueNotifier<Widget> notifier;

  const _ChildSlotScope({
    super.key,
    required this.graft,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return InheritedGraftScope(
      graft: graft,
      caller: 'graft.slots',
      child: ValueListenableBuilder<Widget>(
        valueListenable: notifier,
        builder: (_, widget, __) => widget,
      ),
    );
  }
}

/// Single-child slot diff engine. Rebuilds only when the widget returned by [builder] changes.
///
/// ### Why use GraftSingleSlotScope?
/// Isolates a single widget builder so that modifications to unrelated fields in [GraftState]
/// do not cause this widget subtree to rebuild.
class GraftSingleSlotScope<S extends GraftState> extends StatefulWidget {
  /// The [Graft] controller providing state updates.
  final Graft<S> graft;

  /// Builder returning the child widget based on current [S].
  final Widget Function(S state) builder;

  /// Creates a [GraftSingleSlotScope] that isolates single child slot rebuilds.
  const GraftSingleSlotScope({
    super.key,
    required this.graft,
    required this.builder,
  });

  @override
  State<GraftSingleSlotScope<S>> createState() => _GraftSingleSlotScopeState<S>();
}

class _GraftSingleSlotScopeState<S extends GraftState> extends State<GraftSingleSlotScope<S>> {
  late final ValueNotifier<Widget> _slotNotifier;

  @override
  void initState() {
    super.initState();
    _slotNotifier = ValueNotifier<Widget>(
      GraftScopeGuard.run(
        widget.graft,
        'graft.slot',
        () => widget.builder(widget.graft.state),
      ),
    );
    widget.graft.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    if (!mounted) return;
    final oldWidget = _slotNotifier.value;
    final newWidget = GraftScopeGuard.run(
      widget.graft,
      'graft.slot',
      () => widget.builder(widget.graft.state),
    );

    if (identical(oldWidget, newWidget)) return;
    if (GraftMultiChildDiffEngine.isWidgetEquivalent(oldWidget, newWidget)) return;

    _slotNotifier.value = newWidget;
  }

  @override
  void didUpdateWidget(covariant GraftSingleSlotScope<S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.graft != widget.graft) {
      oldWidget.graft.removeListener(_onStateChanged);
      _slotNotifier.value = GraftScopeGuard.run(
        widget.graft,
        'graft.slot',
        () => widget.builder(widget.graft.state),
      );
      widget.graft.addListener(_onStateChanged);
    }
  }

  @override
  void dispose() {
    widget.graft.removeListener(_onStateChanged);
    _slotNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      final ancestorScope = context.getInheritedWidgetOfExactType<InheritedGraftScope>();
      if (ancestorScope != null && identical(ancestorScope.graft, widget.graft)) {
        throw FlutterError(
          '\n════════════════════════════════════════════════════════════════════════════════\n'
          '⚠️ GRAFT ANTI-PATTERN DETECTED: NESTED ELEMENT TREE SCOPE ON ${widget.graft.runtimeType}\n'
          '════════════════════════════════════════════════════════════════════════════════\n'
          'A widget inside "${ancestorScope.caller}" is trying to observe the exact same ${widget.graft.runtimeType} with "graft.slot"!\n'
          'This creates duplicate element listeners on the same controller and degrades performance.\n\n'
          'Fix: Return widgets directly inside "${ancestorScope.caller}" without wrapping them in graft.slot().\n'
          '════════════════════════════════════════════════════════════════════════════════\n',
        );
      }
      return true;
    }());

    return InheritedGraftScope(
      graft: widget.graft,
      caller: 'graft.slot',
      child: ValueListenableBuilder<Widget>(
        valueListenable: _slotNotifier,
        builder: (_, child, __) => child,
      ),
    );
  }
}

/// Internal guard that tracks active builder executions to detect and prevent anti-pattern nesting.
abstract final class GraftScopeGuard {
  static final Set<Graft> _activeBuilders = {};
  static final Map<Graft, String> _activeCallers = {};

  /// Runs [action] within the registered scope of [caller] on [graft].
  ///
  /// Throws a descriptive [FlutterError] in debug mode if [graft] is already being built
  /// by another builder.
  static R run<R>(Graft graft, String caller, R Function() action) {
    assert(() {
      if (_activeBuilders.contains(graft)) {
        final existing = _activeCallers[graft] ?? 'another builder';
        throw FlutterError(
          '\n════════════════════════════════════════════════════════════════════════════════\n'
          '⚠️ GRAFT ANTI-PATTERN DETECTED: REDUNDANT NESTING ON ${graft.runtimeType}\n'
          '════════════════════════════════════════════════════════════════════════════════\n'
          'You called "$caller" directly inside the builder of "$existing" for the exact same ${graft.runtimeType} instance!\n\n'
          'Why this is a problem:\n'
          '1. In "$existing", children/slots are already isolated or observed.\n'
          '2. Nesting another builder on the same Graft creates duplicate listeners, thrashes widget state, and degrades performance.\n\n'
          'How to fix:\n'
          '• Inside graft.slots:\n'
          '  Simply return normal widgets without wrapping them in graft.slot().\n'
          '  Example:\n'
          '    graft.slots((children) => Column(children: children), (s) => [\n'
          '      Text(s.name), // ✅ Return directly!\n'
          '    ])\n'
          '• Inside graft.compute:\n'
          '  Do not use graft.slot() inside compute, as compute already isolates the builder.\n'
          '════════════════════════════════════════════════════════════════════════════════\n',
        );
      }
      _activeBuilders.add(graft);
      _activeCallers[graft] = caller;
      return true;
    }());

    try {
      return action();
    } finally {
      assert(() {
        _activeBuilders.remove(graft);
        _activeCallers.remove(graft);
        return true;
      }());
    }
  }

  /// Verifies that [graft] is not currently inside an active builder when [caller] is invoked.
  static void verifyNotActive(Graft graft, String caller) {
    assert(() {
      if (_activeBuilders.contains(graft)) {
        final existing = _activeCallers[graft] ?? 'another builder';
        throw FlutterError(
          '\n════════════════════════════════════════════════════════════════════════════════\n'
          '⚠️ GRAFT ANTI-PATTERN DETECTED: REDUNDANT NESTING ON ${graft.runtimeType}\n'
          '════════════════════════════════════════════════════════════════════════════════\n'
          'You called "$caller" directly inside the builder of "$existing" for the exact same ${graft.runtimeType} instance!\n\n'
          'Why this is a problem:\n'
          '1. In "$existing", children/slots are already isolated or observed.\n'
          '2. Nesting another builder on the same Graft creates duplicate listeners, thrashes widget state, and degrades performance.\n\n'
          'How to fix:\n'
          '• Inside graft.slots:\n'
          '  Simply return normal widgets without wrapping them in graft.slot().\n'
          '  Example:\n'
          '    graft.slots((children) => Column(children: children), (s) => [\n'
          '      Text(s.name), // ✅ Return directly!\n'
          '    ])\n'
          '• Inside graft.compute:\n'
          '  Do not use graft.slot() inside compute, as compute already isolates the builder.\n'
          '════════════════════════════════════════════════════════════════════════════════\n',
        );
      }
      return true;
    }());
  }
}

/// An internal [InheritedWidget] to detect duplicate Graft slot scopes in the element tree.
class InheritedGraftScope extends InheritedWidget {
  /// The [Graft] instance providing state to this scope.
  final Graft graft;

  /// The caller identifier (e.g. 'graft.slots', 'graft.slot', 'graft.compute').
  final String caller;

  /// Creates an [InheritedGraftScope] wrapping [child].
  const InheritedGraftScope({
    super.key,
    required this.graft,
    required this.caller,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedGraftScope oldWidget) =>
      oldWidget.graft != graft || oldWidget.caller != caller;
}

