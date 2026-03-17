import 'package:edumate/core/widgets/app_layout.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return EAppLayout(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surface,
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.menu_book,
                    size: 50,
                    color: colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Không gian làm việc trống',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ba mẹ vui lòng chọn hoặc thêm một tài liệu ở\ndanh sách bên trái để sử dụng chức năng.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
