import 'dart:async';
import 'package:flutter/material.dart';

/// Provides the single shared [ScrollController] from [AxionShell] to
/// descendant [AxionScrollReveal] widgets without creating duplicate controllers.
class AxionScrollScope extends InheritedWidget {
  const AxionScrollScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final ScrollController controller;

  static ScrollController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AxionScrollScope>()
        ?.controller;
  }

  @override
  bool updateShouldNotify(AxionScrollScope oldWidget) =>
      controller != oldWidget.controller;
}

/// Subtle viewport-triggered fade + upward reveal animation.
/// - Plays once when entering the viewport (never replays on small scroll-ups).
/// - Respects `MediaQuery.maybeDisableAnimationsOf(context)`.
/// - Leaves content 100% visible if animations are disabled or no scroll scope exists.
class AxionScrollReveal extends StatefulWidget {
  const AxionScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 420),
    this.offsetY = 14.0,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offsetY;

  @override
  State<AxionScrollReveal> createState() => _AxionScrollRevealState();
}

class _AxionScrollRevealState extends State<AxionScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curved;
  ScrollController? _scrollController;
  Timer? _delayTimer;
  bool _revealed = false;
  bool _listenerAttached = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disableAnimations) {
      _revealImmediately();
      return;
    }

    final scopeController = AxionScrollScope.maybeOf(context);
    if (scopeController != _scrollController) {
      _detachListener();
      _scrollController = scopeController;
      if (!_revealed && _scrollController != null) {
        _scrollController!.addListener(_checkVisibility);
        _listenerAttached = true;
      }
    }

    if (!_revealed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _checkVisibility();
      });
    }
  }

  void _detachListener() {
    if (_listenerAttached && _scrollController != null) {
      _scrollController!.removeListener(_checkVisibility);
      _listenerAttached = false;
    }
  }

  void _revealImmediately() {
    _revealed = true;
    _delayTimer?.cancel();
    _detachListener();
    _controller.value = 1.0;
  }

  void _checkVisibility() {
    if (!mounted || _revealed) return;

    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disableAnimations) {
      _revealImmediately();
      return;
    }

    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize) {
      return;
    }

    final viewportHeight = MediaQuery.sizeOf(context).height;
    final topY = renderObject.localToGlobal(Offset.zero).dy;
    final bottomY = topY + renderObject.size.height;

    final inViewport = topY < viewportHeight * 0.96 && bottomY > -40.0;
    if (!inViewport) return;

    _revealed = true;
    _detachListener();

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      _delayTimer = Timer(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _detachListener();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curved,
      builder: (context, child) {
        final t = _curved.value;
        if (t >= 1.0) return child!;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: widget.offsetY == 0.0
              ? child
              : Transform.translate(
                  offset: Offset(0, (1.0 - t) * widget.offsetY),
                  child: child,
                ),
        );
      },
      child: widget.child,
    );
  }
}
