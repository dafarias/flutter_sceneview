import 'package:flutter/material.dart';

class TutorialOverlay extends StatefulWidget {
  final bool show;
  final String? message;
  final VoidCallback? onDismiss;

  const TutorialOverlay({
    super.key,
    required this.show,
    this.message,
    this.onDismiss,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (!widget.show) {
      _controller.value = 1.0; // Starts hidden if show is false
    }
  }

  @override
  void didUpdateWidget(covariant TutorialOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show != oldWidget.show) {
      if (!widget.show) {
        _controller.forward(); // Animate exit
      } else {
        _controller.reverse(from: 1.0); // Instant entry, reset to visible
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: widget.show ? 1.0 : _opacityAnimation.value,
          child: Container(
            // Lighter overlay for AR view visibility
            color: Colors.black87.withValues(alpha: 0.7),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'packages/flutter_sceneview/assets/images/ar_hand_prompt.png',
                    width: 64,
                    height: 64,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      widget.message ?? "Move your phone to start tracking",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
