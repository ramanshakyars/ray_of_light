import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/services/moodService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
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
    _intensity = 5;
    _loadInitialMood();
  }

  Future<void> _loadInitialMood() async {
    try {
      final stored = await LocalStorageService.getCurrentMood();
      if (stored != null && mounted) {
        setState(() {
          _selectedMood = stored.type;
          _intensity = stored.intensity;
        });
      }
    } catch (_) {}
  }

  Future<void> _submitMood() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final req = MoodRequest(
        type: _selectedMood,
        intensity: _intensity,
      );

      final resp = await MoodService.setMood(req);

      if (resp['success'] == true) {
        final userMood = UserMood.fromJson(resp['data']);
        await LocalStorageService.setCurrentMood(userMood);

        if (mounted) {
          Navigator.of(context).pop(userMood);
        }
      } else {
        setState(() {
          _errorMessage = resp['message'] ?? 'Failed to update mood';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error updating mood';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    final card = AppColors.getMonoCard(isDark);
    final surface = AppColors.getMonoSurface(isDark);
    final textSecondary = AppColors.getMonoTextSecondary(isDark);

    return SafeArea(
      top: false,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.86,
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        decoration: BoxDecoration(
          color: card,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(32),
          ),
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
                  color: AppColors.getMonoBorder(isDark),
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
                  style: AppTextStyles.monoBold22(isDark),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close,
                      color: AppColors.getMonoIcon(isDark)),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              "Choose a mood to express your moment",
              style: AppTextStyles.monoSecondary14(isDark),
            ),

            const SizedBox(height: 18),

            /// GRID
            Expanded(
              child: GridView.builder(
                itemCount: _moods.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (_, i) {
                  final mood = _moods[i];
                  final selected = mood.type == _selectedMood;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMood = mood.type;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 54,
                          width: 54,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.getMonoTextPrimary(isDark)
                                : surface,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            mood.icon,
                            color: selected
                                ? (isDark
                                    ? Colors.black
                                    : Colors.white)
                                : textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          mood.label,
                          style:
                              AppTextStyles.monoMuted12(isDark),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// SLIDER
            Row(
              children: [
                const Icon(Icons.favorite, color: Colors.purple),
                const SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    value: _intensity.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (v) =>
                        setState(() => _intensity = v.round()),
                  ),
                ),
              ],
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],

            const SizedBox(height: 8),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitMood,
                child: _isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child:
                            CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Save"),
              ),
            ),
          ],
        ),
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
