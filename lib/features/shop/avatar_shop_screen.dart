import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/bouncy_card.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../models/child_profile.dart';
import '../../models/shop_item.dart';
import '../../services/storage_service.dart';

/// Avatar & Sticker Shop Screen
class AvatarShopScreen extends StatefulWidget {
  final VoidCallback onPurchased;
  const AvatarShopScreen({super.key, required this.onPurchased});

  @override
  State<AvatarShopScreen> createState() => _AvatarShopScreenState();
}

class _AvatarShopScreenState extends State<AvatarShopScreen> {
  late ChildProfile _profile;
  List<String> _unlockedItems = [];
  bool _isLoading = true;

  final List<ShopItem> _catalog = ShopItem.catalog;

  @override
  void initState() {
    super.initState();
    _loadShopData();
  }

  void _loadShopData() async {
    final storage = await StorageService.getInstance();
    setState(() {
      _profile = storage.getProfile();
      _unlockedItems = storage.getUnlockedItems();
      _isLoading = false;
    });
  }

  void _buyOrEquipItem(ShopItem item) async {
    final storage = await StorageService.getInstance();
    final isUnlocked = _unlockedItems.contains(item.id) || item.price == 0;

    if (isUnlocked) {
      // Equip avatar
      final updated = _profile.copyWith(avatar: item.avatarEmoji);
      await storage.saveProfile(updated);
      widget.onPurchased();
      _loadShopData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Equipped ${item.title} as your main avatar!', style: AppTextStyles.badgeText.copyWith(color: Colors.white)),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } else {
      // Buy item
      if (_profile.coins >= item.price) {
        await storage.saveCoins(_profile.coins - item.price);
        await storage.unlockItem(item.id);
        widget.onPurchased();
        _loadShopData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unlocked ${item.title}! 🎉', style: AppTextStyles.badgeText.copyWith(color: Colors.white)),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Not enough coins! Play more activities to earn 🪙', style: AppTextStyles.badgeText.copyWith(color: Colors.white)),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const ChildModeScaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ChildModeScaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
                Text('Avatar Shop 🛍️', style: AppTextStyles.heading2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 4),
                      Text('${_profile.coins}', style: AppTextStyles.badgeText),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.9,
              ),
              itemCount: _catalog.length,
              itemBuilder: (context, index) {
                final item = _catalog[index];
                final isUnlocked = _unlockedItems.contains(item.id) || item.price == 0;
                final isEquipped = _profile.avatar == item.avatarEmoji;

                return BouncyCard(
                  backgroundColor: Colors.white,
                  onTap: () => _buyOrEquipItem(item),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item.avatarEmoji, style: const TextStyle(fontSize: 48)),
                      const SizedBox(height: 8),
                      Text(item.title, style: AppTextStyles.heading3.copyWith(fontSize: 16), maxLines: 1),
                      const SizedBox(height: 8),
                      if (isEquipped)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('EQUIPPED', style: AppTextStyles.badgeText.copyWith(color: Colors.white, fontSize: 12)),
                        )
                      else if (isUnlocked)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryDark,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('EQUIP', style: AppTextStyles.badgeText.copyWith(color: Colors.white, fontSize: 12)),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🪙', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 4),
                            Text('${item.price}', style: AppTextStyles.heading3.copyWith(color: AppColors.warning)),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
