import 'package:edumate/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class ExerciseListSheet extends StatelessWidget {
  final List<String> exercises;
  final String? selectedExercise;
  final ValueChanged<String> onSelect;

  const ExerciseListSheet({
    super.key,
    required this.exercises,
    this.selectedExercise,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DANH SÁCH BÀI TẬP',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Exercise List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: exercises.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                final isSelected = exercise == selectedExercise;

                return InkWell(
                  onTap: () {
                    onSelect(exercise);
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(ESizes.radiusMd),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? colorScheme.primaryContainer : colorScheme.surface,
                      borderRadius: BorderRadius.circular(ESizes.radiusMd),
                      border: Border.all(
                        color: isSelected ? colorScheme.primary : colorScheme.outlineVariant.withValues(alpha: 0.5),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        exercise,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle_outline,
                              color: colorScheme.primary,
                            )
                          : null,
                    ),
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
