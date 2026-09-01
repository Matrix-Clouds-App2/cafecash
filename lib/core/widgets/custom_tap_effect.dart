import 'package:flutter/material.dart';

class CustomTapEffect extends StatefulWidget {
  const CustomTapEffect({
    super.key,
    this.isClickable = true,
    this.enableAnimation = true,
    required this.onTap,
    this.onLongPress,
    required this.child,
  });

  final bool isClickable;
  final bool enableAnimation;
  final VoidCallback? onTap;

  final VoidCallback? onLongPress;
  final Widget child;

  @override
  State<CustomTapEffect> createState() => _TapEffectState();
}

class _TapEffectState extends State<CustomTapEffect>
    with SingleTickerProviderStateMixin {
  static const _pressedScale = 0.95;
  static const _downDuration = Duration(milliseconds: 70);
  static const _upDuration = Duration(milliseconds: 110);
  static const _debounce = Duration(milliseconds: 400);

  late final AnimationController _controller;
  DateTime _lastTap = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _downDuration,
      reverseDuration: _upDuration,
      lowerBound: _pressedScale,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void didUpdateWidget(covariant CustomTapEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enableAnimation) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _pressDown() {
    if (widget.isClickable && widget.enableAnimation) {
      _controller.animateTo(_pressedScale, curve: Curves.easeOut);
    }
  }

  void _pressUp() {
    if (widget.enableAnimation) {
      _controller.animateTo(1.0, curve: Curves.easeOut);
    }
  }

  void _handleTap() {
    if (!widget.isClickable) return;
    final now = DateTime.now();
    if (now.difference(_lastTap) < _debounce) return;
    _lastTap = now;
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onTapDown: (_) => _pressDown(),
      onTapUp: (_) => _pressUp(),
      onTapCancel: _pressUp,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.enableAnimation ? _controller.value : 1.0,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
