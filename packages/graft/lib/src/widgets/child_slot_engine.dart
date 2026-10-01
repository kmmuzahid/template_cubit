import 'package:flutter/widgets.dart';
import '../core/graft.dart';
import '../core/graft_state.dart';

/// Optional interface for custom widgets to define fine-grained slot content equivalence.
abstract interface class GraftEquivalent {
  /// Returns whether this widget is equivalent to [other] for slot diffing.
  bool isEquivalentTo(Widget other);
}

/// Engine that performs fine-grained diffing on multi-child layout slots.
///
/// Only slots with changed content will rebuild. `const` widgets and widgets
/// whose properties remain equivalent experience 0 rebuilds.
class GraftMultiChildDiffEngine<S extends GraftState> extends StatefulWidget {
  final Graft<S> graft;
  final List<Widget> Function(S state) childrenBuilder;
  final Widget Function(BuildContext context, List<Widget> children) layoutBuilder;

  const GraftMultiChildDiffEngine({
    super.key,
    required this.graft,
    required this.childrenBuilder,
    required this.layoutBuilder,
  });

  /// Compares two widgets for content equivalence.
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
      return a.padding == b.padding;
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
    final initialWidgets = widget.childrenBuilder(widget.graft.state);
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

    final newWidgets = widget.childrenBuilder(widget.graft.state);

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
        notifier: _slotNotifiers[i],
      );
    });

    return widget.layoutBuilder(context, wrappedChildren);
  }
}

/// An isolated slot scope that rebuilds only when its specific slot notifier fires.
class _ChildSlotScope extends StatelessWidget {
  final ValueNotifier<Widget> notifier;

  const _ChildSlotScope({
    super.key,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Widget>(
      valueListenable: notifier,
      builder: (_, widget, __) => widget,
    );
  }
}

/// Single-child slot diff engine. Rebuilds only when the widget returned by [builder] changes.
class GraftSingleSlotScope<S extends GraftState> extends StatefulWidget {
  final Graft<S> graft;
  final Widget Function(S state) builder;

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
    _slotNotifier = ValueNotifier<Widget>(widget.builder(widget.graft.state));
    widget.graft.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    if (!mounted) return;
    final oldWidget = _slotNotifier.value;
    final newWidget = widget.builder(widget.graft.state);

    if (identical(oldWidget, newWidget)) return;
    if (GraftMultiChildDiffEngine.isWidgetEquivalent(oldWidget, newWidget)) return;

    _slotNotifier.value = newWidget;
  }

  @override
  void didUpdateWidget(covariant GraftSingleSlotScope<S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.graft != widget.graft) {
      oldWidget.graft.removeListener(_onStateChanged);
      _slotNotifier.value = widget.builder(widget.graft.state);
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
    return ValueListenableBuilder<Widget>(
      valueListenable: _slotNotifier,
      builder: (_, child, __) => child,
    );
  }
}
