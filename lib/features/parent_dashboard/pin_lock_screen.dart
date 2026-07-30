import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/bouncy_card.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../services/storage_service.dart';
import 'parent_dashboard_screen.dart';

/// 4-Digit Security PIN Gateway for Parents
class PinLockScreen extends StatefulWidget {
  const PinLockScreen({super.key});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  String _enteredPin = '';
  String _errorMessage = '';

  void _onKeyPress(String digit) async {
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += digit;
        _errorMessage = '';
      });

      if (_enteredPin.length == 4) {
        final storage = await StorageService.getInstance();
        final correctPin = storage.getParentPin();

        if (_enteredPin == correctPin) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ParentDashboardScreen()),
            );
          }
        } else {
          setState(() {
            _enteredPin = '';
            _errorMessage = 'Incorrect PIN. Try default: 1234';
          });
        }
      }
    }
  }

  void _onDelete() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _errorMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChildModeScaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
                Text('Parent Control Gateway 🔒', style: AppTextStyles.heading2),
              ],
            ),
            const Spacer(),
            const Icon(Icons.lock_rounded, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text('Enter 4-Digit Parent PIN', style: AppTextStyles.headingHero),
            const SizedBox(height: 8),
            Text('Default PIN: 1234', style: AppTextStyles.bodySmall),
            const SizedBox(height: 24),
            // PIN Dots Display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isFilled = index < _enteredPin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? AppColors.primary : Colors.grey.shade300,
                  ),
                );
              }),
            ),
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(_errorMessage, style: AppTextStyles.bodyMedium.copyWith(color: Colors.redAccent)),
            ],
            const Spacer(),
            // Numeric Keypad
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
              children: [
                ...['1', '2', '3', '4', '5', '6', '7', '8', '9'].map((digit) {
                  return BouncyCard(
                    backgroundColor: Colors.white,
                    onTap: () => _onKeyPress(digit),
                    child: Center(
                      child: Text(digit, style: AppTextStyles.heading1),
                    ),
                  );
                }),
                const SizedBox(),
                BouncyCard(
                  backgroundColor: Colors.white,
                  onTap: () => _onKeyPress('0'),
                  child: Center(
                    child: Text('0', style: AppTextStyles.heading1),
                  ),
                ),
                BouncyCard(
                  backgroundColor: Colors.redAccent.shade100,
                  onTap: _onDelete,
                  child: const Center(
                    child: Icon(Icons.backspace_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
