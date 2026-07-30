import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/big_round_button.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../models/child_profile.dart';
import '../../services/storage_service.dart';

/// Child Profile Detail Screen
class ProfileScreen extends StatefulWidget {
  final VoidCallback onProfileUpdated;

  const ProfileScreen({super.key, required this.onProfileUpdated});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ChildProfile _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final storage = await StorageService.getInstance();
    setState(() {
      _profile = storage.getProfile();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const ChildModeScaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ChildModeScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
                Text('My Hero Profile', style: AppTextStyles.heading2),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(_profile.avatar, style: const TextStyle(fontSize: 60)),
              ),
            ),
            const SizedBox(height: 16),
            Text(_profile.name, style: AppTextStyles.headingHero),
            Text('Age Group: ${_profile.ageGroup} Years', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statCard('🪙 Coins', '${_profile.coins}', AppColors.warning),
                _statCard('⭐ Stars', '${_profile.stars}', AppColors.secondaryDark),
              ],
            ),
            const SizedBox(height: 32),
            BigRoundButton(
              text: 'Close Profile',
              backgroundColor: AppColors.primary,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.heading1.copyWith(color: color)),
        ],
      ),
    );
  }
}
