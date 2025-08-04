import 'package:flutter/material.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/services/moodService.dart';
import 'MoodRequest.dart';
import 'UserMood.dart';
import 'UserMoodsEnum.dart';

class MoodDropdownDialog extends StatefulWidget {
  const MoodDropdownDialog({super.key});

  @override
  State<MoodDropdownDialog> createState() => _MoodDropdownDialogState();
}

class _MoodDropdownDialogState extends State<MoodDropdownDialog> {
  late UserMoodsEnum _selectedMood;
  late int _intensity;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedMood = UserMoodsEnum.neutral;
    _intensity = 5;
    _loadInitialMood();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialMood() async {
    try {
      final stored = await LocalStorageService.getCurrentMood();
      if (stored != null) {
        setState(() {
          _selectedMood = stored.type;
          _intensity = stored.intensity;
          _descriptionController.text = stored.description ?? '';
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
        description:
            _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text,
      );
      final resp = await MoodService.setMood(req);
      if (resp['success'] == true) {
        final userMood = resp['data'] as UserMood;
        await LocalStorageService.setCurrentMood(userMood);
        final cur =
            (await MoodService.getCurrentMood())['success'] == true
                ? (await MoodService.getCurrentMood())['data'] as UserMood
                : userMood;
        if (mounted) Navigator.pop(context, cur);
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = resp['message'] ?? 'Failed';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error updating mood: $e';
          _isLoading = false;
        });
      }
    }
  }

  /// Helper to get human-readable mood name
  String _humanMood(UserMoodsEnum m) {
    final name = m.name;
    return '${name[0].toUpperCase()}${name.substring(1)}';
  }

  @override
  Widget build(BuildContext context) {
    final moodIcon = MoodIcon.getIcon(_selectedMood);
    final moodColor = MoodIcon.getColor(_selectedMood);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 560),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'How are you feeling?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              /// Dropdown for mood selection
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Select Mood',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<UserMoodsEnum>(
                    isExpanded: true,
                    value: _selectedMood,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items:
                        UserMoodsEnum.values.map((m) {
                          final icon = MoodIcon.getIcon(m);
                          return DropdownMenuItem(
                            value: m,
                            child: Row(
                              children: [
                                Icon(icon, color: MoodIcon.getColor(m)),
                                const SizedBox(width: 8),
                                Text(_humanMood(m)),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged:
                        (v) => setState(() {
                          _selectedMood = v!;
                        }),
                  ),
                ),
              ),

              const SizedBox(height: 20),

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
                    label: '$_intensity',
                    onChanged: (v) {
                      setState(() {
                        _intensity = v.round();
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Description
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 20),

              /// Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
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

/// Utility to map enum -> icon & color
class MoodIcon {
  static IconData getIcon(UserMoodsEnum mood) {
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

  static Color getColor(UserMoodsEnum mood) {
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
}
