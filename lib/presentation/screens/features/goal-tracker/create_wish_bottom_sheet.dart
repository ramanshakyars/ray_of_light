import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class CreateWishBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const CreateWishBottomSheet({super.key, required this.onSubmit});

  @override
  State<CreateWishBottomSheet> createState() => _CreateWishBottomSheetState();
}

class _CreateWishBottomSheetState extends State<CreateWishBottomSheet> {
  final _descController = TextEditingController();
  final _titleController = TextEditingController();
  DateTime? reminderDate;
  DateTime? targetDate;

  String selectedType = "HOPE";

  final List<_WishType> types = const [
    _WishType("HOPE", Icons.star_border),
    _WishType("DREAM", Icons.auto_awesome_outlined),
    _WishType("GRATITUDE", Icons.favorite_border),
    _WishType("INTENTION", Icons.track_changes),
  ];

  String formatDateTime(DateTime? date) {
    if (date == null) return "";
    final d = "${date.day}/${date.month}/${date.year}";
    final t = "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    return "$d  $t";
  }

  Future<void> pickReminder() async {
    final colors = context.read<ThemeProvider>().colors;

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colors.primary,
              onPrimary: colors.primaryForeground,
              surface: colors.card,
              onSurface: colors.textPrimary,
            ),
            dialogBackgroundColor: colors.card,
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colors.primary,
              onPrimary: colors.primaryForeground,
              surface: colors.card,
              onSurface: colors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time == null) return;

    final finalDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      reminderDate = finalDateTime;
    });
  }

  Future<void> pickTargetDate() async {
    final colors = context.read<ThemeProvider>().colors;

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colors.primary,
              onPrimary: colors.primaryForeground,
              surface: colors.card,
              onSurface: colors.textPrimary,
            ),
            dialogBackgroundColor: colors.card,
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => targetDate = date);
    }
  }

  @override
  void initState() {
    super.initState();
    _descController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Create a Wish", style: AppTextStyles.sectionTitle(colors)),
              IconButton(
                splashRadius: 20,
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: colors.icon),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text("Choose a type", style: AppTextStyles.hintText(colors)),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: types.map((t) {
              final selected = selectedType == t.label;

              return GestureDetector(
                onTap: () => setState(() => selectedType = t.label),
                child: Container(
                  width: 78,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: selected ? colors.primary : colors.surface,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        t.icon,
                        size: 22,
                        color: selected ? colors.primaryForeground : colors.textSecondary,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatLabel(t.label),
                        style: AppTextStyles.labelSmall(colors).copyWith(
                          color: selected ? colors.primaryForeground : colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 22),

          Container(
            decoration: BoxDecoration(
              color: colors.inputBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.inputBorder),
            ),
            child: TextField(
              controller: _descController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
              style: AppTextStyles.inputText(colors),
              decoration: InputDecoration(
                hintText: "Write your wish here...",
                hintStyle: AppTextStyles.hintText(colors),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Container(
            decoration: BoxDecoration(
              color: colors.inputBackground,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: colors.inputBorder),
            ),
            child: TextField(
              controller: _titleController,
              style: AppTextStyles.inputText(colors),
              decoration: InputDecoration(
                hintText: "Title (optional)",
                hintStyle: AppTextStyles.hintText(colors),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Text("Options", style: AppTextStyles.hintText(colors)),

          const SizedBox(height: 10),

          _OptionTile(
            icon: Icons.notifications_none,
            title: "Set reminder",
            trailing: reminderDate != null ? formatDateTime(reminderDate) : "Set time",
            colors: colors,
            onTap: pickReminder,
          ),

          const SizedBox(height: 10),

          _OptionTile(
            icon: Icons.calendar_today_outlined,
            title: "Target date",
            trailing: targetDate != null ? targetDate.toString().split(" ")[0] : "Set date",
            colors: colors,
            onTap: pickTargetDate,
          ),

          const Spacer(),

          _PrimaryButton(
            label: "Create Wish",
            enabled: _descController.text.trim().isNotEmpty && selectedType.isNotEmpty,
            colors: colors,
            onTap: () {
              final description = _descController.text.trim();
              if (description.isEmpty) return;
              widget.onSubmit({
                "title": _titleController.text.trim().isEmpty ? description : _titleController.text.trim(),
                "description": description,
                "category": selectedType,
                "reminderAt": reminderDate?.toIso8601String(),
                "targetDate": targetDate?.toIso8601String(),
              });

              Navigator.pop(context);
            },
          ),

          const SizedBox(height: 10),

          _SecondaryButton(
            label: "Cancel",
            colors: colors,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  String _formatLabel(String raw) {
    return raw[0] + raw.substring(1).toLowerCase();
  }
}

class _WishType {
  final String label;
  final IconData icon;

  const _WishType(this.label, this.icon);
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String trailing;
  final ThemeColors colors;
  final VoidCallback? onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.trailing,
    required this.colors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors.textSecondary),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: AppTextStyles.bodyText(colors))),
            Text(trailing, style: AppTextStyles.hintText(colors)),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool enabled;
  final ThemeColors colors;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
    required this.enabled,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonLabel(colors).copyWith(
            color: enabled ? colors.primaryForeground : colors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final ThemeColors colors;

  const _SecondaryButton({required this.label, required this.onTap, required this.colors});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Text(label, style: AppTextStyles.cardTitle(colors)),
      ),
    );
  }
}
