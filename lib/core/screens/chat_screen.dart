import 'package:edumate/core/constants/sizes.dart';
import 'package:edumate/core/widgets/app_layout.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String documentTitle;
  final IconData documentIcon;

  const ChatScreen({
    super.key,
    required this.documentTitle,
    required this.documentIcon,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return EAppLayout(
      title: widget.documentTitle,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              children: [
                // Bot welcome message
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.smart_toy_outlined,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hệ thống đã nhận diện tài liệu. Vui lòng chọn bài tập trong danh sách bên dưới để thao tác.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'DANH SÁCH BÀI TẬP HIỆN CÓ',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildExerciseItem(
                                context, 'Bài 1: Phân tích tự động'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom input area
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: Column(
              children: [
                // Choose exercise chip
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(ESizes.radiusMd),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.format_list_bulleted,
                          size: 18,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Chọn bài tập mục tiêu để bắt đầu...',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 18,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),

                // Text input row
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          maxLines: 3,
                          minLines: 1,
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText:
                                'Ba mẹ vui lòng chọn bài tập phía trên trước...',
                            hintStyle: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.send_rounded,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(BuildContext context, String title) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: ListTile(
        dense: true,
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
        ),
        onTap: () {},
      ),
    );
  }
}
