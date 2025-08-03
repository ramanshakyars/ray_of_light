import 'package:flutter/material.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/services/moodService.dart';
import 'MoodRequest.dart';
import 'UserMood.dart';
import 'UserMoodsEnum.dart';

/// The dialog that lets the user pick a mood, intensity, and optional description.
class MoodDialog extends StatefulWidget {
  const MoodDialog({super.key});

  @override
  State<MoodDialog> createState() => _MoodDialogState();
}

class _MoodDialogState extends State<MoodDialog> {
  late UserMoodsEnum _selectedMood;
  late int _intensity;
  final TextEditingController _descriptionController = TextEditingController();

  /// Controller for the mood-name field with icon.
  late TextEditingController _moodController;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedMood = UserMoodsEnum.neutral;
    _intensity = 5;
    _moodController = TextEditingController(text: _capitalize(_selectedMood));

    _loadInitialMood();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _moodController.dispose();
    super.dispose();
  }

  /// Helper to get a capitalized human-friendly mood name.
  String _capitalize(UserMoodsEnum mood) {
    final name = mood.name;
    return '${name[0].toUpperCase()}${name.substring(1)}';
  }

  /// Updates the mood text field when a new mood is selected.
  void _updateMoodController(UserMoodsEnum mood) {
    _moodController.text = _capitalize(mood);
  }

  Future<void> _loadInitialMood() async {
    try {
      final mood = await LocalStorageService.getCurrentMood();
      if (mood != null) {
        setState(() {
          _selectedMood = mood.type;
          _intensity = mood.intensity;
          _updateMoodController(_selectedMood);
          _descriptionController.text = mood.description ?? '';
        });
      }
    } catch (_) {
      // Ignore errors in loading initial mood
    }
  }

  Future<void> _submitMood() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request = MoodRequest(
        type: _selectedMood,
        intensity: _intensity,
        description:
            _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text,
      );

      final response = await MoodService.setMood(request);

      if (response['success'] == true) {
        final userMood = response['data'] as UserMood;
        await LocalStorageService.setCurrentMood(userMood);

        final currentMoodResponse = await MoodService.getCurrentMood();
        if (currentMoodResponse['success'] == true) {
          final currentMood = currentMoodResponse['data'] as UserMood;
          await LocalStorageService.setCurrentMood(currentMood);
          if (mounted) Navigator.pop(context, currentMood);
        } else {
          if (mounted) Navigator.pop(context, userMood);
        }
      } else {
        if (!mounted) return;
        setState(() {
          _errorMessage = response['message'] ?? 'Unknown error';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to update mood: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodColor = _MoodIcon.moodColor(_selectedMood);
    final moodIcon = _MoodIcon.moodIcon(_selectedMood);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title
              const Text(
                'How are you feeling?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              /// Selected mood field with name + icon
              TextField(
                readOnly: true,
                controller: _moodController,
                decoration: InputDecoration(
                  labelText: 'Selected Mood',
                  suffixIcon: Icon(moodIcon, color: moodColor),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 12.0,
                  ),
                ),
                style: TextStyle(color: moodColor, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 16),

              /// Mood icons grid
              SizedBox(
                height: 200,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: UserMoodsEnum.values.length,
                  itemBuilder: (context, index) {
                    final mood = UserMoodsEnum.values[index];
                    return _MoodIcon(
                      mood: mood,
                      isSelected: _selectedMood == mood,
                      onTap: () {
                        setState(() {
                          _selectedMood = mood;
                          _updateMoodController(mood);
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              /// Intensity slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Intensity: $_intensity',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Slider(
                    value: _intensity.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: _intensity.toString(),
                    onChanged: (value) {
                      setState(() {
                        _intensity = value.round();
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Description field
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],

              const SizedBox(height: 16),

              /// Cancel & Save buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitMood,
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icon widget for each mood in the grid, with static icon/color mappings.
class _MoodIcon extends StatelessWidget {
  final UserMoodsEnum mood;
  final bool isSelected;
  final VoidCallback onTap;
  final double size;

  const _MoodIcon({
    required this.mood,
    required this.isSelected,
    required this.onTap,
    this.size = 40.0,
  });

  static IconData moodIcon(UserMoodsEnum mood) {
    switch (mood) {
      case UserMoodsEnum.happy:
        return Icons.sentiment_very_satisfied;
      case UserMoodsEnum.sad:
        return Icons.sentiment_very_dissatisfied;
      case UserMoodsEnum.calm:
        return Icons.self_improvement;
      case UserMoodsEnum.anxious:
        return Icons.sentiment_very_dissatisfied_outlined;
      case UserMoodsEnum.overwhelmed:
        return Icons.warning_amber;
      case UserMoodsEnum.peaceful:
        return Icons.spa;
      case UserMoodsEnum.confused:
        return Icons.help_outline;
      case UserMoodsEnum.hopeful:
        return Icons.emoji_objects;
      case UserMoodsEnum.tired:
        return Icons.hotel;
      case UserMoodsEnum.energetic:
        return Icons.bolt;
      case UserMoodsEnum.neutral:
        return Icons.sentiment_neutral;
    }
  }

  static Color moodColor(UserMoodsEnum mood) {
    switch (mood) {
      case UserMoodsEnum.happy:
        return Colors.yellow[700]!;
      case UserMoodsEnum.sad:
        return Colors.blue[700]!;
      case UserMoodsEnum.calm:
        return Colors.green[700]!;
      case UserMoodsEnum.anxious:
        return Colors.deepOrange[700]!;
      case UserMoodsEnum.overwhelmed:
        return Colors.purple[700]!;
      case UserMoodsEnum.peaceful:
        return Colors.teal[700]!;
      case UserMoodsEnum.confused:
        return Colors.orange[700]!;
      case UserMoodsEnum.hopeful:
        return Colors.pink[700]!;
      case UserMoodsEnum.tired:
        return Colors.brown[700]!;
      case UserMoodsEnum.energetic:
        return Colors.red[700]!;
      case UserMoodsEnum.neutral:
        return Colors.grey[700]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = moodIcon(mood);
    final color = moodColor(mood);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: color, width: 2.0) : null,
        ),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}
