import 'package:edumate/core/constants/sizes.dart';
import 'package:edumate/core/widgets/app_layout.dart';
import 'package:edumate/core/widgets/chat/bot_message_bubble.dart';
import 'package:edumate/core/widgets/chat/exercise_list_sheet.dart';
import 'package:edumate/core/widgets/chat/manage_exercise_sheet.dart';
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
  
  String? _selectedExercise;

  final List<Map<String, dynamic>> _messages = [
    {
      'role': 'system',
      'text': 'Hệ thống đã phân tích phiếu bài tập. Dưới đây là các bài tập được tìm thấy, ba mẹ vui lòng chọn bài tập mục tiêu để Edumate có thể đưa ra hướng dẫn tập trung nhất.',
      'type': 'exerciseList',
      'exercises': ['Bài 1: Xác định từ láy', 'Bài 2: Đặt câu'],
    }
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _selectExercise(String exercise) {
    setState(() {
      _selectedExercise = exercise;
      // Thêm tin nhắn xác nhận
      bool hasConfirmation = _messages.any((msg) => msg['text'].toString().contains('Đã chuyển trọng tâm sang'));
      if (!hasConfirmation) {
         _messages.add({
          'role': 'system',
          'text': 'Đã chuyển trọng tâm sang $exercise. Ba mẹ cần Edumate gợi ý cách giảng hay muốn kiểm tra kết quả của bé?',
        });
      } else {
        // Cập nhật tin nhắn xác nhận
        final idx = _messages.lastIndexWhere((msg) => msg['text'].toString().contains('Đã chuyển trọng tâm sang'));
        if (idx != -1) {
          _messages[idx] = {
            'role': 'system',
            'text': 'Đã chuyển trọng tâm sang $exercise. Ba mẹ cần Edumate gợi ý cách giảng hay muốn kiểm tra kết quả của bé?',
          };
        }
      }
    });

    // Cuộn xuống
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showExerciseListModal() {
    final msg = _messages.firstWhere((m) => m['type'] == 'exerciseList', orElse: () => <String, dynamic>{});
    final dynamic rawExercises = msg['exercises'];
    final List<String> exercises = rawExercises is List ? rawExercises.map((e) => e.toString()).toList() : <String>[];
    if (exercises.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExerciseListSheet(
        exercises: exercises,
        selectedExercise: _selectedExercise,
        onSelect: _selectExercise,
      ),
    );
  }

  void _showManageExerciseModal() {
    if (_selectedExercise == null) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ManageExerciseSheet(
        exerciseTitle: _selectedExercise!,
        onAddBotMessage: (String text) {
          setState(() {
            _messages.add({
              'role': 'system',
              'text': text,
            });
          });
          
          Navigator.pop(context);
          
          Future.delayed(const Duration(milliseconds: 300), () {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Default right action + trailing Manage Exercise action if selected
    List<Widget> actions = [
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Row(
          children: [
            if (_selectedExercise != null)
              Container(
                margin: const EdgeInsets.only(right: 8),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.menu_book, color: colorScheme.secondary),
                  onPressed: _showManageExerciseModal,
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.play_circle_outline, color: colorScheme.primary),
                onPressed: () {},
                iconSize: 22,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    ];

    return EAppLayout(
      title: widget.documentTitle,
      actions: actions,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                
                if (msg['role'] == 'system') {
                  Widget? bottomWidget;
                  
                  if (msg['type'] == 'exerciseList') {
                    final dynamic rawExercises = msg['exercises'];
                    final List<String> exercises = rawExercises is List ? rawExercises.map((e) => e.toString()).toList() : <String>[];
                    bottomWidget = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          'DANH SÁCH BÀI TẬP HIỆN CÓ',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (final ex in exercises) _buildExerciseItem(context, ex),
                      ],
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: BotMessageBubble(
                      text: msg['text']?.toString() ?? '',
                      bottomWidget: bottomWidget,
                    ),
                  );
                }
                
                return const SizedBox();
              },
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
                  child: InkWell(
                    onTap: _showExerciseListModal,
                    borderRadius: BorderRadius.circular(ESizes.radiusMd),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedExercise == null 
                            ? colorScheme.surfaceContainerHighest
                            : colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(ESizes.radiusMd),
                        border: _selectedExercise != null 
                            ? Border.all(color: colorScheme.primary.withValues(alpha: 0.3))
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _selectedExercise == null ? Icons.format_list_bulleted : Icons.segment,
                            size: 18,
                            color: _selectedExercise == null ? colorScheme.onSurfaceVariant : colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedExercise ?? 'Chọn bài tập mục tiêu để bắt đầu...',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _selectedExercise == null ? colorScheme.onSurfaceVariant : colorScheme.primary,
                                fontWeight: _selectedExercise == null ? FontWeight.normal : FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 18,
                            color: _selectedExercise == null ? colorScheme.onSurfaceVariant : colorScheme.primary,
                          ),
                        ],
                      ),
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
                            hintText: _selectedExercise == null 
                                ? 'Ba mẹ vui lòng chọn bài tập phía trên trước...'
                                : 'Nhập câu hỏi để nhận hướng dẫn giảng bài...',
                            hintStyle: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                ESizes.radiusMd,
                              ),
                              borderSide: BorderSide(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                ESizes.radiusMd,
                              ),
                              borderSide: BorderSide(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                ESizes.radiusMd,
                              ),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(ESizes.radiusMd),
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
        onTap: () => _selectExercise(title),
      ),
    );
  }
}
