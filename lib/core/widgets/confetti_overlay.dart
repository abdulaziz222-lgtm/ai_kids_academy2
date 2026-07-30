import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

/// Celebration Confetti Overlay Controller Wrapper
class ConfettiOverlay extends StatefulWidget {
  final Widget child;
  final ConfettiController controller;

  const ConfettiOverlay({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: widget.controller,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Color(0xFF5E60CE),
              Color(0xFF64DFDF),
              Color(0xFF80FFDB),
              Color(0xFFFFD166),
              Color(0xFF06D6A0),
              Color(0xFFFFB5A7),
            ],
            numberOfParticles: 35,
            gravity: 0.25,
          ),
        ),
      ],
    );
  }
}
