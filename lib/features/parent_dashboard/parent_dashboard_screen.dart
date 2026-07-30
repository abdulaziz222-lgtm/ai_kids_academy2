import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/parent_mode_scaffold.dart';
import '../../models/child_profile.dart';
import '../../services/storage_service.dart';

/// Parent Dashboard Screen with fl_chart weekly analytics, subject breakdown & AI suggestions
class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  late ChildProfile _profile;
  int _studyMinutes = 45;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() async {
    final storage = await StorageService.getInstance();
    setState(() {
      _profile = storage.getProfile();
      _studyMinutes = storage.getStudyTimeMinutes();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return ParentModeScaffold(
        title: 'Parent Dashboard',
        onBack: () => Navigator.pop(context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return ParentModeScaffold(
      title: 'Parent Analytics 📊',
      onBack: () => Navigator.pop(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.secondary,
                    child: Text(_profile.avatar, style: const TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_profile.name, style: AppTextStyles.heading2),
                        Text('Age Group: ${_profile.ageGroup} | $_studyMinutes mins learned this week', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Weekly Study Chart Header
            Text('Weekly Study Time (Minutes)', style: AppTextStyles.heading2),
            const SizedBox(height: 12),
            Container(
              height: 220,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: Offset(0, 4))],
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 60,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          if (value.toInt() >= 0 && value.toInt() < days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(days[value.toInt()], style: AppTextStyles.bodySmall),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _makeBarGroup(0, 25),
                    _makeBarGroup(1, 40),
                    _makeBarGroup(2, 35),
                    _makeBarGroup(3, 50),
                    _makeBarGroup(4, 30),
                    _makeBarGroup(5, 55),
                    _makeBarGroup(6, 45),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Performance & Insights
            Text('Subject Mastery & Insights', style: AppTextStyles.heading2),
            const SizedBox(height: 12),
            _subjectProgressTile('Alphabet & Words', 0.90, AppColors.success),
            _subjectProgressTile('Fun Math', 0.75, AppColors.primary),
            _subjectProgressTile('3D Memory Game', 0.85, AppColors.secondaryDark),
            _subjectProgressTile('AI Story & Reading', 0.95, AppColors.warning),
            const SizedBox(height: 24),
            // AI Recommendations Box
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primaryLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🧠', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      Text('AI Educator Recommendation', style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_profile.name} is excelling in Alphabet recognition and AI Stories! '
                    'To strengthen mental math agility, try allocating 10 minutes to multiplication flash cards today.',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primary,
          width: 18,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }

  Widget _subjectProgressTile(String title, double progress, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.heading3.copyWith(fontSize: 16)),
              Text('${(progress * 100).toInt()}%', style: AppTextStyles.badgeText.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
