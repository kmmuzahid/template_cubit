import 'package:flutter/material.dart';
import '../core/graft.dart';
import '../core/graft_state.dart';
import '../core/value_graft.dart';
import 'child_slot_engine.dart';

/// Extension on [Graft<S>] providing seamless, reactive Flutter widget builders.
extension GraftWidgetsX<S extends GraftState> on Graft<S> {
  // ===========================================================================
  // MULTI-CHILD LAYOUTS (AUTOMATIC SLOT DIFFING)
  // ===========================================================================

  /// A high-performance reactive [Column] whose child slots diff independently.
  ///
  /// ### Why use `graft.column(...)`?
  /// In standard Flutter, when state changes, an entire `Column` and all its children rebuild.
  /// `graft.column` automatically isolates each child into an independent slot:
  /// - `const` children: **0 rebuilds** (completely skipped by Flutter's render pipeline).
  /// - Children with unchanged properties: **0 rebuilds** (equivalence match).
  /// - Children with changed properties: **Only that specific child rebuilds!**
  ///
  /// ### Example:
  /// ```dart
  /// graft.column((s) => [
  ///   const CardHeader(),             // 0 rebuilds (const)
  ///   Text(s.name),                   // Rebuilds ONLY when s.name changes
  ///   Text(s.email),                  // 0 rebuilds if email didn't change
  ///   if (s.isVerified) const Badge(),
  /// ])
  /// ```
  Widget column(
    List<Widget> Function(S state) children, {
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
  }) {
    return GraftMultiChildDiffEngine<S>(
      key: key,
      graft: this,
      childrenBuilder: children,
      layoutBuilder: (context, slotWidgets) => Column(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        children: slotWidgets,
      ),
    );
  }

  /// A high-performance reactive [Row] whose child slots diff independently.
  ///
  /// ### Why use `graft.row(...)`?
  /// Like `graft.column`, only slots whose properties actually changed will rebuild.
  /// `const` widgets and unchanged slots experience **0 rebuilds**.
  ///
  /// ### Example:
  /// ```dart
  /// graft.row((s) => [
  ///   const Icon(Icons.star),         // 0 rebuilds
  ///   Text('${s.rating}'),            // Rebuilds ONLY when rating changes
  ///   Text('(${s.reviewCount})'),     // 0 rebuilds if reviewCount is unchanged
  /// ])
  /// ```
  Widget row(
    List<Widget> Function(S state) children, {
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
  }) {
    return GraftMultiChildDiffEngine<S>(
      key: key,
      graft: this,
      childrenBuilder: children,
      layoutBuilder: (context, slotWidgets) => Row(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        children: slotWidgets,
      ),
    );
  }

  /// A high-performance reactive [Stack] whose child slots diff independently.
  ///
  /// ### Why use `graft.stack(...)`?
  /// Ideal for layered views, overlays, badges, and floating actions.
  /// Changing a foreground badge slot does NOT rebuild background image layers.
  ///
  /// ### Example:
  /// ```dart
  /// graft.stack((s) => [
  ///   const BackgroundBanner(),       // 0 rebuilds (heavy background cached)
  ///   Positioned(
  ///     top: 10,
  ///     right: 10,
  ///     child: Text('${s.badgeCount}'), // Rebuilds ONLY when badgeCount changes
  ///   ),
  /// ])
  /// ```
  Widget stack(
    List<Widget> Function(S state) children, {
    Key? key,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    StackFit fit = StackFit.loose,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return GraftMultiChildDiffEngine<S>(
      key: key,
      graft: this,
      childrenBuilder: children,
      layoutBuilder: (context, slotWidgets) => Stack(
        alignment: alignment,
        textDirection: textDirection,
        fit: fit,
        clipBehavior: clipBehavior,
        children: slotWidgets,
      ),
    );
  }

  /// A high-performance reactive [Wrap] whose child slots diff independently.
  ///
  /// ### Why use `graft.wrap(...)`?
  /// Perfect for chips, tags, and dynamic filters.
  /// Modifying or selecting one tag does not rebuild the other tags in the flow.
  ///
  /// ### Example:
  /// ```dart
  /// graft.wrap((s) => [
  ///   for (final tag in s.availableTags)
  ///     FilterChip(
  ///       label: Text(tag.name),
  ///       selected: tag.isSelected,
  ///       onSelected: (_) => graft.toggleTag(tag.id),
  ///     ),
  /// ])
  /// ```
  Widget wrap(
    List<Widget> Function(S state) children, {
    Key? key,
    Axis direction = Axis.horizontal,
    WrapAlignment alignment = WrapAlignment.start,
    double spacing = 0.0,
    WrapAlignment runAlignment = WrapAlignment.start,
    double runSpacing = 0.0,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    Clip clipBehavior = Clip.none,
  }) {
    return GraftMultiChildDiffEngine<S>(
      key: key,
      graft: this,
      childrenBuilder: children,
      layoutBuilder: (context, slotWidgets) => Wrap(
        direction: direction,
        alignment: alignment,
        spacing: spacing,
        runAlignment: runAlignment,
        runSpacing: runSpacing,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        clipBehavior: clipBehavior,
        children: slotWidgets,
      ),
    );
  }

  // ===========================================================================
  // NON-LIST & NAMED-SLOT WIDGETS
  // ===========================================================================

  /// A high-performance reactive [ListTile] whose named slots rebuild independently.
  ///
  /// ### Why use `graft.listTile(...)`?
  /// In standard Flutter, updating a user's status or badge inside a `ListTile` forces the
  /// entire tile (avatar, title, subtitle, trailing icon) to repaint.
  /// `graft.listTile` isolates `leading`, `title`, and `subtitle` into separate slots:
  /// - Changing `title` does NOT rebuild `leading` or `subtitle`.
  /// - Constant `trailing` widgets experience **0 rebuilds**.
  ///
  /// ### Example:
  /// ```dart
  /// graft.listTile(
  ///   leading: (s) => CircleAvatar(child: Text(s.name[0])),
  ///   title: (s) => Text(s.name),
  ///   subtitle: (s) => Text(s.statusText), // Rebuilds ONLY when statusText changes
  ///   trailing: const Icon(Icons.chevron_right), // 0 rebuilds
  /// )
  /// ```
  Widget listTile({
    Key? key,
    Widget Function(S state)? leading,
    Widget Function(S state)? title,
    Widget Function(S state)? subtitle,
    Widget? trailing,
    bool? isThreeLine,
    bool? dense,
    VisualDensity? visualDensity,
    ShapeBorder? shape,
    Color? selectedColor,
    Color? iconColor,
    Color? textColor,
    EdgeInsetsGeometry? contentPadding,
    bool enabled = true,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    bool selected = false,
    Color? focusColor,
    Color? hoverColor,
    Color? tileColor,
    Color? selectedTileColor,
    bool? enableFeedback,
    double? horizontalTitleGap,
    double? minVerticalPadding,
    double? minLeadingWidth,
  }) {
    return ListTile(
      key: key,
      leading: leading != null ? slot(leading) : null,
      title: title != null ? slot(title) : null,
      subtitle: subtitle != null ? slot(subtitle) : null,
      trailing: trailing,
      isThreeLine: isThreeLine ?? false,
      dense: dense,
      visualDensity: visualDensity,
      shape: shape,
      selectedColor: selectedColor,
      iconColor: iconColor,
      textColor: textColor,
      contentPadding: contentPadding,
      enabled: enabled,
      onTap: onTap,
      onLongPress: onLongPress,
      selected: selected,
      focusColor: focusColor,
      hoverColor: hoverColor,
      tileColor: tileColor,
      selectedTileColor: selectedTileColor,
      enableFeedback: enableFeedback,
      horizontalTitleGap: horizontalTitleGap,
      minVerticalPadding: minVerticalPadding,
      minLeadingWidth: minLeadingWidth,
    );
  }

  /// A reactive [Padding] widget whose child only rebuilds when its content changes.
  ///
  /// ### Why use `graft.padding(...)`?
  /// Wraps an isolated diffing slot with padding, ensuring the padding layout element
  /// remains stable across emissions.
  Widget padding({
    Key? key,
    required EdgeInsetsGeometry padding,
    required Widget Function(S state) child,
  }) {
    return Padding(
      key: key,
      padding: padding,
      child: slot(child),
    );
  }

  /// A reactive [Center] widget whose child only rebuilds when its content changes.
  ///
  /// ### Why use `graft.center(...)`?
  /// Centers an isolated diffing slot without rebuilding the centering layout.
  Widget center({
    Key? key,
    double? widthFactor,
    double? heightFactor,
    required Widget Function(S state) child,
  }) {
    return Center(
      key: key,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: slot(child),
    );
  }

  /// A reactive [Card] widget whose child only rebuilds when its content changes.
  ///
  /// ### Why use `graft.card(...)`?
  /// Houses an isolated diffing slot inside a Material Card. Material styling, shadows,
  /// and elevation stay cached while dynamic interior slots diff independently.
  Widget card({
    Key? key,
    Color? color,
    Color? shadowColor,
    Color? surfaceTintColor,
    double? elevation,
    ShapeBorder? shape,
    bool borderOnForeground = true,
    EdgeInsetsGeometry? margin,
    Clip? clipBehavior,
    bool semanticContainer = true,
    required Widget Function(S state) child,
  }) {
    return Card(
      key: key,
      color: color,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      elevation: elevation,
      shape: shape,
      borderOnForeground: borderOnForeground,
      margin: margin,
      clipBehavior: clipBehavior,
      semanticContainer: semanticContainer,
      child: slot(child),
    );
  }

  // ===========================================================================
  // FULL PAGE / CONDITIONAL STATE MACHINE (LOADING, ERROR, SUCCESS)
  // ===========================================================================

  /// Builds a reactive UI for full-page state switching (e.g. Loading / Error / Content).
  ///
  /// ### Why use `graft.layout(...)`?
  /// When your screen represents mutually exclusive full-page states (such as an initial spinner,
  /// a network failure screen, or loaded dashboard), use `graft.layout` to switch seamlessly.
  ///
  /// ### Example:
  /// ```dart
  /// graft.layout((context, s) {
  ///   if (s.isLoading) return const LoadingSpinner();
  ///   if (s.error != null) return ErrorBanner(message: s.error!);
  ///   return ContentDashboard(user: s.user);
  /// })
  /// ```
  Widget layout(
    Widget Function(BuildContext context, S state) builder, {
    Key? key,
  }) {
    return ValueListenableBuilder<S>(
      key: key,
      valueListenable: listenable,
      builder: (context, state, _) => builder(context, state),
    );
  }

  // ===========================================================================
  // UNIVERSAL ADAPTER (SELF-INVENTED / 3RD-PARTY WIDGETS)
  // ===========================================================================

  /// Universal reactive adapter. Rebuilds the returned widget whenever [state] changes.
  ///
  /// ### Why use `graft.watch(...)`?
  /// Use this when integrating 3rd-party widgets, complex canvas paints, or custom widgets
  /// that need access to the full state object on every update.
  ///
  /// ### Example:
  /// ```dart
  /// graft.watch((s) => Complex3rdPartyChart(data: s.chartData))
  /// ```
  Widget watch(Widget Function(S state) builder, {Key? key}) {
    return ValueListenableBuilder<S>(
      key: key,
      valueListenable: listenable,
      builder: (_, state, __) => builder(state),
    );
  }

  /// Creates an isolated single-child slot that diffs its content.
  ///
  /// ### Why use `graft.slot(...)`?
  /// Rebuilds **ONLY** when the widget returned by [builder] changes properties or identity.
  /// Unrelated state changes in other fields will result in **0 rebuilds** for this slot.
  ///
  /// ### Example:
  /// ```dart
  /// graft.slot((s) => Text('Welcome, ${s.username}!'))
  /// ```
  Widget slot(Widget Function(S state) builder, {Key? key}) {
    return GraftSingleSlotScope<S>(
      key: key,
      graft: this,
      builder: builder,
    );
  }

  /// Selects a specific sub-slice [R] of state and rebuilds **ONLY** when that slice changes.
  ///
  /// ### Why use `graft.select(...)`?
  /// Prevents unnecessary rebuilds when you only care about a single property or computed value.
  ///
  /// ### Example:
  /// ```dart
  /// graft.select(
  ///   (s) => s.notificationCount, // Only listens to notificationCount changes
  ///   (count) => Badge(label: Text('$count')),
  /// )
  /// ```
  Widget select<R>(
    R Function(S state) selector,
    Widget Function(R value) builder, {
    Key? key,
  }) {
    return _GraftSelector<S, R>(
      key: key,
      graft: this,
      selector: selector,
      builder: builder,
    );
  }
}

class _GraftSelector<S extends GraftState, R> extends StatefulWidget {
  final Graft<S> graft;
  final R Function(S state) selector;
  final Widget Function(R value) builder;

  const _GraftSelector({
    super.key,
    required this.graft,
    required this.selector,
    required this.builder,
  });

  @override
  State<_GraftSelector<S, R>> createState() => _GraftSelectorState<S, R>();
}

class _GraftSelectorState<S extends GraftState, R> extends State<_GraftSelector<S, R>> {
  late R _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selector(widget.graft.state);
    widget.graft.addListener(_onStateChange);
  }

  void _onStateChange() {
    final newValue = widget.selector(widget.graft.state);
    if (_selectedValue != newValue) {
      setState(() {
        _selectedValue = newValue;
      });
    }
  }

  @override
  void didUpdateWidget(covariant _GraftSelector<S, R> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.graft != widget.graft) {
      oldWidget.graft.removeListener(_onStateChange);
      _selectedValue = widget.selector(widget.graft.state);
      widget.graft.addListener(_onStateChange);
    }
  }

  @override
  void dispose() {
    widget.graft.removeListener(_onStateChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_selectedValue);
  }
}

/// Extension on [ValueGraft<T>] providing clean, single-value reactive widget builders.
extension ValueGraftWidgetsX<T> on ValueGraft<T> {
  /// A reactive slot that diffs and rebuilds only when [value] changes.
  ///
  /// ### Example:
  /// ```dart
  /// counterGraft.slot((count) => Text('Count: $count'))
  /// ```
  Widget slot(Widget Function(T value) builder, {Key? key}) {
    return GraftSingleSlotScope<GraftValue<T>>(
      key: key,
      graft: this,
      builder: (s) => builder(s.value),
    );
  }

  /// Rebuilds this widget tree with BuildContext whenever [value] changes.
  ///
  /// ### Example:
  /// ```dart
  /// splashCubit.watch((isLoading) => isLoading ? const Spinner() : const Dashboard())
  /// ```
  Widget watch(Widget Function(T value) builder, {Key? key}) {
    return ValueListenableBuilder<GraftValue<T>>(
      key: key,
      valueListenable: listenable,
      builder: (_, s, __) => builder(s.value),
    );
  }
}
