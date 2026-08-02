import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../liquidGlass/effects/liquid_glass_effect.dart';
import '../../../liquidGlass/surfaces/liquid_surface.dart';
import '../../../liquidGlass/theme/liquid_theme.dart';
import '../../../liquidGlass/transitions/liquid_transition.dart';
import '../glass_container/exports.dart';
import '../glass_dropdown_container/exports.dart';
import 'constants.dart';
import 'models.dart';

/// Liquid Glass dropdown selector with hint, leading/trailing slots,
/// validation, loading and error states, plus a smooth open/close
/// animation. The widget never assumes the source of its items.
class GlassDropdownButton<T> extends StatefulWidget {
  const GlassDropdownButton({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
    this.leadingIcon,
    this.trailingIcon,
    this.size = GlassSize.medium,
    this.isLoading = false,
    this.enabled = true,
    this.error,
    this.searchable = false,
    this.searchHint,
    this.itemLabel,
    this.maxHeight,
    this.borderRadius,
    this.popupAlignment = AlignmentDirectional.topStart,
    this.semanticLabel,
  });

  final List<GlassDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final T? value;
  final String? hint;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final GlassSize size;
  final bool isLoading;
  final bool enabled;
  final String? error;
  final bool searchable;
  final String? searchHint;
  final String Function(GlassDropdownItem<T>)? itemLabel;
  final double? maxHeight;
  final BorderRadius? borderRadius;
  final AlignmentGeometry popupAlignment;
  final String? semanticLabel;

  @override
  State<GlassDropdownButton<T>> createState() => _GlassDropdownButtonState<T>();
}

class _GlassDropdownButtonState<T> extends State<GlassDropdownButton<T>>
    with SingleTickerProviderStateMixin {
  final GlobalKey _triggerKey = GlobalKey();
  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  late final AnimationController _openController;

  OverlayEntry? _entry;
  bool _open = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _openController = AnimationController(
      vsync: this,
      duration: GlassDropdownContainerConstants.openAnim,
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocus.dispose();
    _openController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() => _query = _searchController.text);
    _entry?.markNeedsBuild();
  }

  int? get _selectedIndex {
    if (widget.value == null) return null;
    for (var i = 0; i < widget.items.length; i++) {
      if (widget.items[i].value == widget.value) return i;
    }
    return null;
  }

  GlassDropdownItem<T>? get _selectedItem {
    final index = _selectedIndex;
    if (index == null) return null;
    return widget.items[index];
  }

  void _toggle() {
    if (!widget.enabled || widget.isLoading) return;
    if (_open) {
      _close();
    } else {
      _openOverlay();
    }
  }

  void _openOverlay() {
    final overlay = Overlay.of(context, rootOverlay: true);
    final renderBox =
        _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    _entry = OverlayEntry(
      builder: (context) => _buildOverlay(context, renderBox),
    );
    overlay.insert(_entry!);
    setState(() => _open = true);
    _openController.forward();
  }

  void _close() {
    if (_entry == null && !_open) return;
    _removeOverlay();
    if (_open) setState(() => _open = false);
    _searchController.clear();
    _query = '';
    _openController.reverse();
  }

  void _removeOverlay() {
    _entry?.remove();
    _entry = null;
  }

  void _selectItem(GlassDropdownItem<T> item) {
    widget.onChanged?.call(item.value);
    _close();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LiquidThemes.of(context);
    final palette = GlassPalette.of(context);
    final scheme = Theme.of(context).colorScheme;
    final metrics =
        GlassDropdownButtonMetrics.of(widget.size.forContext(context));
    final state = _resolveState();
    final hasError = state == GlassDropdownState.error;
    final borderColor =
        hasError ? scheme.error.withValues(alpha: 0.6) : palette.border;
    final tint = hasError
        ? scheme.error.withValues(
            alpha: GlassDropdownButtonConstants.errorTintAlpha,
          )
        : null;
    final radius =
        widget.borderRadius ?? BorderRadius.circular(GlassConstants.radiusMd);

    final trigger = Semantics(
      label: widget.semanticLabel ?? widget.hint ?? 'Dropdown',
      button: true,
      enabled: widget.enabled && !widget.isLoading,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onTap: _toggle,
          child: LiquidGlassEffect(
            key: _triggerKey,
            baseColor: tint ?? theme.surfaceTint,
            borderColor: borderColor,
            borderRadius: radius.topLeft.x,
            blurStrength: theme.blurStrength * 0.6,
            surfaceOpacity: theme.surfaceOpacity * 0.85,
            reflectionIntensity: theme.reflectionIntensity * 0.85,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: GlassDropdownButtonConstants.minTouchTarget,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: GlassDropdownButtonConstants.padH,
                  vertical: metrics.verticalPadding,
                ),
                child: Row(
                  children: [
                    if (widget.leadingIcon != null) ...[
                      Icon(
                        widget.leadingIcon,
                        size: metrics.leadingIconSize,
                        color: palette.foreground,
                      ),
                      const SizedBox(
                        width: GlassDropdownButtonConstants.searchGap,
                      ),
                    ],
                    Expanded(
                      child: _TriggerLabel(
                        item: _selectedItem,
                        hint: widget.hint,
                        state: state,
                      ),
                    ),
                    if (widget.trailingIcon != null) ...[
                      const SizedBox(
                        width: GlassDropdownButtonConstants.searchGap,
                      ),
                      Icon(
                        widget.trailingIcon,
                        size: GlassDropdownButtonConstants.trailingIconSize,
                        color: palette.mutedForeground,
                      ),
                    ],
                    _Chevron(open: _open),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        trigger,
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(
              top: GlassDropdownButtonConstants.errorGap,
            ),
            child: Text(
              widget.error!,
              style: TextStyle(
                color: scheme.error,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  GlassDropdownState _resolveState() {
    if (!widget.enabled) return GlassDropdownState.disabled;
    if (widget.isLoading) return GlassDropdownState.loading;
    if (widget.error != null) return GlassDropdownState.error;
    return GlassDropdownState.idle;
  }

  Widget _buildOverlay(BuildContext context, RenderBox renderBox) {
    final size = renderBox.size;
    final filtered = _filteredItems();
    final radius =
        widget.borderRadius ?? BorderRadius.circular(GlassConstants.radiusLg);

    return Positioned(
      width: size.width.clamp(
        GlassDropdownButtonConstants.popupMinWidth,
        GlassDropdownButtonConstants.popupMaxWidth,
      ),
      child: CompositedTransformFollower(
        link: _layerLink,
        targetAnchor: Alignment.bottomLeft,
        followerAnchor: Alignment.topLeft,
        offset: const Offset(0, GlassDropdownButtonConstants.popupGap),
        showWhenUnlinked: false,
        child: AnimatedBuilder(
          animation: _openController,
          builder: (context, child) => LiquidTransition(
            animation: _openController,
            beginScale: 0.96,
            fade: true,
            child: child,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: widget.maxHeight ??
                    GlassDropdownContainerConstants.maxHeight,
              ),
              child: LiquidSurface(
                borderRadius: radius,
                padding: EdgeInsets.zero,
                borderWidth: 0.6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.searchable)
                      _SearchField(
                        controller: _searchController,
                        focusNode: _searchFocus,
                        hint: widget.searchHint,
                      ),
                    Flexible(
                      child: GlassDropdownContainer(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          final selected =
                              _selectedItem?.value == item.value;
                          return _buildItemRow(context, item, selected);
                        },
                        selectedIndex: _selectedIndexFor(filtered),
                        onItemSelected: (index) {
                          if (index < 0 || index >= filtered.length) return;
                          _selectItem(filtered[index]);
                        },
                        isLoading: widget.isLoading,
                        borderRadius: radius,
                        empty: _query.isEmpty
                            ? null
                            : const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('কোনো মিল পাওয়া যায়নি'),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: GlassDropdownContainerConstants.openAnim,
          curve: GlassDropdownContainerConstants.openCurve,
        )
        .slideY(
          begin: -0.04,
          end: 0,
          duration: GlassDropdownContainerConstants.openAnim,
          curve: GlassDropdownContainerConstants.openCurve,
        );
  }

  Widget _buildItemRow(
    BuildContext context,
    GlassDropdownItem<T> item,
    bool selected,
  ) {
    final palette = GlassPalette.of(context);
    return Row(
      children: [
        if (item.leading != null)
          SizedBox(
            width: GlassDropdownButtonConstants.leadingIconMedium,
            child: item.leading!,
          ),
        if (item.leading != null)
          const SizedBox(width: GlassDropdownButtonConstants.searchGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (item.subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    item.subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: palette.mutedForeground,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (item.trailing != null) item.trailing!,
        if (selected) ...[
          const SizedBox(width: 8),
          Icon(
            Icons.check_rounded,
            size: 18,
            color: palette.accent,
          ),
        ],
      ],
    );
  }

  List<GlassDropdownItem<T>> _filteredItems() {
    if (!widget.searchable || _query.isEmpty) return widget.items;
    final lower = _query.toLowerCase();
    return widget.items
        .where((e) => e.label.toLowerCase().contains(lower))
        .toList(growable: false);
  }

  int? _selectedIndexFor(List<GlassDropdownItem<T>> items) {
    if (widget.value == null) return null;
    for (var i = 0; i < items.length; i++) {
      if (items[i].value == widget.value) return i;
    }
    return null;
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.hint,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GlassDropdownButtonConstants.searchHorizontalPadding,
        GlassDropdownButtonConstants.searchHorizontalPadding,
        GlassDropdownButtonConstants.searchHorizontalPadding,
        0,
      ),
      child: SizedBox(
        height: GlassDropdownButtonConstants.searchHeight,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            isDense: true,
            hintText: hint ?? 'অনুসন্ধান',
            prefixIcon: const Icon(Icons.search_rounded, size: 18),
            border: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

class _TriggerLabel extends StatelessWidget {
  const _TriggerLabel({
    required this.item,
    required this.hint,
    required this.state,
  });

  final GlassDropdownItem<dynamic>? item;
  final String? hint;
  final GlassDropdownState state;

  @override
  Widget build(BuildContext context) {
    final palette = GlassPalette.of(context);

    if (state == GlassDropdownState.loading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(palette.foreground),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'লোড হচ্ছে...',
            style: TextStyle(color: palette.mutedForeground),
          ),
        ],
      );
    }

    if (item == null) {
      return Text(
        hint ?? 'নির্বাচন করুন',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: palette.mutedForeground,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item!.leading != null) ...[
          SizedBox(
            width: 18,
            child: item!.leading!,
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            item!.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: palette.foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron({required this.open});

  final bool open;

  @override
  Widget build(BuildContext context) {
    final palette = GlassPalette.of(context);
    return AnimatedRotation(
      turns: open ? 0.5 : 0,
      duration: GlassDropdownButtonConstants.chevronAnim,
      curve: Curves.easeInOut,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Icon(
          Icons.expand_more_rounded,
          size: GlassDropdownButtonConstants.trailingIconSize,
          color: palette.mutedForeground,
        ),
      ),
    );
  }
}