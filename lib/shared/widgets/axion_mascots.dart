import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/responsive/breakpoints.dart';

/// Decorative Creeper mascot placed beside the header WhatsApp button.
/// Desktop: 42px height, Tablet: 34px height, Mobile: hidden.
class CreeperHeaderMascot extends StatefulWidget {
  const CreeperHeaderMascot({super.key});

  @override
  State<CreeperHeaderMascot> createState() => _CreeperHeaderMascotState();
}

class _CreeperHeaderMascotState extends State<CreeperHeaderMascot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disableAnimations) {
      _controller.stop();
      _controller.value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeClass = Breakpoints.of(context);
    if (sizeClass == ScreenSizeClass.mobile) {
      return const SizedBox.shrink();
    }

    final height = sizeClass == ScreenSizeClass.desktop ? 42.0 : 34.0;

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = Curves.easeInOut.transform(_controller.value);
          final dy = (t - 0.5) * 4.0; // ±2px vertical bounce
          final angle = (t - 0.5) * 0.04; // subtle idle tilt
          return Transform.translate(
            offset: Offset(0, dy),
            child: Transform.rotate(
              angle: angle,
              alignment: Alignment.bottomCenter,
              child: child,
            ),
          );
        },
        child: Image.asset(
          'assets/images/mascots/creeper.png.png',
          height: height,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}

/// Decorative Spider-Man mascot hanging from the upper corner.
/// Desktop: 88×78px, Tablet: 68×60px, Mobile: hidden.
class SpidermanCornerMascot extends StatefulWidget {
  const SpidermanCornerMascot({super.key});

  @override
  State<SpidermanCornerMascot> createState() => _SpidermanCornerMascotState();
}

class _SpidermanCornerMascotState extends State<SpidermanCornerMascot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disableAnimations) {
      _controller.stop();
      _controller.value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeClass = Breakpoints.of(context);
    if (sizeClass == ScreenSizeClass.mobile) {
      return const SizedBox.shrink();
    }

    final isDesktop = sizeClass == ScreenSizeClass.desktop;
    final width = isDesktop ? 88.0 : 68.0;
    final height = isDesktop ? 78.0 : 60.0;

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = Curves.easeInOutSine.transform(_controller.value);
          // ±3 degrees pendulum swing anchored at topCenter
          final angle = (t - 0.5) * (6.0 * math.pi / 180.0);
          return Transform.rotate(
            angle: angle,
            alignment: Alignment.topCenter,
            child: child,
          );
        },
        child: Image.asset(
          'assets/images/mascots/spiderman_clean.png',
          width: width,
          height: height,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}

/// Decorative seated Spider-Man Noir mascot resting on the header search bar.
/// Desktop: 68×68px, Tablet: 56×56px, Mobile: hidden.
class SearchBarMascot extends StatefulWidget {
  const SearchBarMascot({super.key});

  @override
  State<SearchBarMascot> createState() => _SearchBarMascotState();
}

class _SearchBarMascotState extends State<SearchBarMascot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disableAnimations) {
      _controller.stop();
      _controller.value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeClass = Breakpoints.of(context);
    final size = switch (sizeClass) {
      ScreenSizeClass.desktop => 68.0,
      ScreenSizeClass.tablet => 56.0,
      ScreenSizeClass.mobile => 48.0,
    };

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = Curves.easeInOutSine.transform(_controller.value);
          final dy = (t - 0.5) * 2.4; // ±1.2px gentle breathing
          final angle = (t - 0.5) * (3.0 * math.pi / 180.0); // ±1.5° leg sway
          return Transform.translate(
            offset: Offset(0, dy),
            child: Transform.rotate(
              angle: angle,
              alignment: Alignment.center,
              child: child,
            ),
          );
        },
        child: Image.asset(
          'assets/images/mascots/search_mascot.png.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}
