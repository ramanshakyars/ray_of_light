import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/services/moodService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

import 'MoodRequest.dart';
import 'UserMood.dart';
import 'UserMoodsEnum.dart';

class MoodBottomSheet extends StatefulWidget {
  const MoodBottomSheet({super.key});

  @override
  State<MoodBottomSheet> createState() => _MoodBottomSheetState();
}

class _MoodBottomSheetState extends State<MoodBottomSheet> {
  late UserMoodsEnum _selectedMood;
  late int _selectedMoodIndex;
  late int _intensity;

  bool _isLoading = false;
  String? _errorMessage;

  final List<_MoodUI> _moods = const [
    _MoodUI(UserMoodsEnum.happy, "Happy", Icons.sentiment_satisfied_alt),
    _MoodUI(UserMoodsEnum.peaceful, "Peaceful", Icons.spa),
    _MoodUI(UserMoodsEnum.hopeful, "Inspired", Icons.auto_awesome),
    _MoodUI(UserMoodsEnum.confused, "Thoughtful", Icons.cloud_outlined),
    _MoodUI(UserMoodsEnum.hopeful, "Hopeful", Icons.wb_sunny_outlined),
    _MoodUI(UserMoodsEnum.calm, "Grateful", Icons.star_outline),
    _MoodUI(UserMoodsEnum.calm, "Gentle", Icons.local_florist_outlined),
    _MoodUI(UserMoodsEnum.calm, "Calm", Icons.waves_outlined),
    _MoodUI(UserMoodsEnum.peaceful, "Serene", Icons.air),
    _MoodUI(UserMoodsEnum.hopeful, "Dreamy", Icons.nightlight_round),
    _MoodUI(UserMoodsEnum.neutral, "Reflective", Icons.brightness_2_outlined),
    _MoodUI(UserMoodsEnum.energetic, "Bright", Icons.wb_sunny),
  ];

  @override
  void initState() {
    super.initState();
    _selectedMood = UserMoodsEnum.neutral;
    _selectedMoodIndex = _moods.indexWhere(
      (mood) => mood.type == _selectedMood,
    );
    _intensity = 5;
    _loadInitialMood();
  }

  Future<void> _loadInitialMood() async {
    try {
      final stored = await LocalStorageService.getCurrentMood();
      if (stored != null && mounted) {
        setState(() {
          _selectedMood = stored.type;
          _selectedMoodIndex = _moods.indexWhere(
            (mood) => mood.type == _selectedMood,
          );
          if (_selectedMoodIndex == -1) _selectedMoodIndex = 0;
          _intensity = stored.intensity;
        });
      }
    } catch (_) {}
  }

  Future<void> _saveMood() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final currentMoodUI =
        (_selectedMoodIndex >= 0 && _selectedMoodIndex < _moods.length)
            ? _moods[_selectedMoodIndex]
            : _moods.first;

    final moodToSave = UserMood(
      type: currentMoodUI.type,
      intensity: _intensity,
      setAt: DateTime.now(),
    );

    final req = MoodRequest(
      type: currentMoodUI.type,
      intensity: _intensity,
    );

    final result = await MoodService.setMood(req);

    if (result['success'] == true) {
      await LocalStorageService.setCurrentMood(moodToSave);
      if (mounted) Navigator.pop(context, true);
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = result['message'] ?? "Failed to save mood";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HANDLE
          Center(
            child: Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "How are you feeling?",
                style: AppTextStyles.sectionTitle(colors),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: colors.icon),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            "Choose a mood to express your moment",
            style: AppTextStyles.bodySecondary(colors),
          ),

          const SizedBox(height: 18),

          /// GRID
          Expanded(
            child: GridView.builder(
              itemCount: _moods.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (_, i) {
                final mood = _moods[i];
                final selected = i == _selectedMoodIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = mood.type;
                      _selectedMoodIndex = i;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: selected ? colors.primary : colors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          mood.icon,
                          size: 24,
                          color: selected ? colors.primaryForeground : colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mood.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.labelSmall(colors).copyWith(
                          fontSize: 11,
                          color: selected ? colors.primary : colors.textMuted,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          /// INTENSITY SLIDER
          Text(
            "Intensity: $_intensity / 10",
            style: AppTextStyles.hintText(colors),
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: colors.primary,
              inactiveTrackColor: colors.surface,
              thumbColor: colors.primary,
            ),
            child: Slider(
              value: _intensity.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (val) {
                setState(() {
                  _intensity = val.round();
                });
              },
            ),
          ),

          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: colors.error, fontSize: 13),
              ),
            ),

          const SizedBox(height: 8),

          /// SAVE BUTTON
          GestureDetector(
            onTap: _isLoading ? null : _saveMood,
            child: Container(
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(26),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.primaryForeground,
                      ),
                    )
                  : Text(
                      "Save Mood",
                      style: AppTextStyles.buttonLabel(colors),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodUI {
  final UserMoodsEnum type;
  final String label;
  final IconData icon;

  const _MoodUI(this.type, this.label, this.icon);
}
