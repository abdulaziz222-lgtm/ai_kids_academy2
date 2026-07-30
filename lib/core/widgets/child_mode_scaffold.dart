import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Container Scaffold for Child Screens featuring floating pastel shapes & clean layout
class ChildModeScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  const ChildModeScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          // Subtle Pastel background bubbles
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryLight.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -50,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.pastelPurple.withOpacity(0.3),
              ),
            ),
          ),
          SafeArea(child: body),
        ],
      ),
    );
  }
}
