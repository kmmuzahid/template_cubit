import 'package:flutter/material.dart';
import '../core/graft.dart';
import 'child_slot_engine.dart';

/// Extension on [Graft<S>] providing seamless, reactive Flutter widget builders.
extension GraftWidgetsX<S> on Graft<S> {
  // ===========================================================================
  // MULTI-CHILD LAYOUTS (AUTOMATIC SLOT DIFFING)
  // ===========================================================================

  /// A reactive [Column] whose slots diff independently.
  ///
  /// - `const` children: **0 rebuilds**
  /// - Children whose state properties didn't change: **0 rebuilds**
  /// - Children with changed state: **Only that slot rebuilds!**
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

  /// A reactive [Row] whose slots diff independently.
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

  /// A reactive [Stack] whose slots diff independently.
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

  /// A reactive [Wrap] whose slots diff independently.
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

  /// A reactive [ListTile] whose slots rebuild independently.
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

  /// Builds a reactive UI that switches depending on full page state (e.g. Loading / Error / Data).
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

  /// Universal reactive adapter. Wraps any self-invented or 3rd-party widget
  /// so it automatically rebuilds whenever this [Graft]'s state changes.
  Widget watch(Widget Function(S state) builder, {Key? key}) {
    return ValueListenableBuilder<S>(
      key: key,
      valueListenable: listenable,
      builder: (_, state, __) => builder(state),
    );
  }

  /// Creates a reactive single-child slot that diffs its content.
  ///
  /// Rebuilds ONLY when the widget returned by [builder] changes properties or identity.
  Widget slot(Widget Function(S state) builder, {Key? key}) {
    return GraftSingleSlotScope<S>(
      key: key,
      graft: this,
      builder: builder,
    );
  }

  /// Selects a specific sub-slice [R] of state and only rebuilds when that slice changes.
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

class _GraftSelector<S, R> extends StatefulWidget {
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

class _GraftSelectorState<S, R> extends State<_GraftSelector<S, R>> {
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
