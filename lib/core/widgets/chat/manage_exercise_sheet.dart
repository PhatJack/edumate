import 'package:edumate/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class ManageExerciseSheet extends StatefulWidget {
  final String exerciseTitle;
  final Function(String)? onAddBotMessage;
  final Future<void> Function(String detail)? onSaveDetails;
  final Future<void> Function(String solution)? onSaveReferenceSolution;
  final Future<void> Function()? onUploadReferenceFromCamera;
  final Future<void> Function()? onUploadReferenceFromGallery;
  final Future<void> Function(String hint)? onGenerateSimilar;
  final GlobalKey? detailsSectionKey;
  final GlobalKey? referenceSolutionSectionKey;
  final GlobalKey? extendedPracticeSectionKey;

  const ManageExerciseSheet({
    super.key,
    required this.exerciseTitle,
    this.onAddBotMessage,
    this.onSaveDetails,
    this.onSaveReferenceSolution,
    this.onUploadReferenceFromCamera,
    this.onUploadReferenceFromGallery,
    this.onGenerateSimilar,
    this.detailsSectionKey,
    this.referenceSolutionSectionKey,
    this.extendedPracticeSectionKey,
  });

  @override
  State<ManageExerciseSheet> createState() => _ManageExerciseSheetState();
}

class _ManageExerciseSheetState extends State<ManageExerciseSheet> {
  late TextEditingController _detailsController;

  late TextEditingController _solutionController;
  late TextEditingController _similarHintController;
  late String _savedDetailsText;
  late String _savedSolutionText;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _savedDetailsText = 'Đề bài hiện tại của ${widget.exerciseTitle}...';
    _savedSolutionText = '';
    _detailsController = TextEditingController(text: _savedDetailsText);
    _solutionController = TextEditingController();
    _similarHintController = TextEditingController();
  }

  @override
  void dispose() {
    _detailsController.dispose();
    _solutionController.dispose();
    _similarHintController.dispose();
    super.dispose();
  }

  Future<void> _runSubmit(
    Future<void> Function() action,
    String successMessage,
  ) async {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await action();
      if (!mounted) {
        return;
      }
      widget.onAddBotMessage?.call(successMessage);
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thao tác thất bại: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

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
            children: [
              Icon(Icons.menu_book, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Quản lý bài tập',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
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
          const SizedBox(height: 20),

          // Exercise Details section
          Row(
            key: widget.detailsSectionKey,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CHI TIẾT ĐỀ BÀI',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(ESizes.radiusMd),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _detailsController,
                  maxLines: 5,
                  minLines: 3,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.5,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _detailsController.text = _savedDetailsText;
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.onSurfaceVariant,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('Hủy', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              await _runSubmit(
                                () async {
                                  final detail = _detailsController.text.trim();
                                  await widget.onSaveDetails?.call(detail);
                                  _savedDetailsText = detail;
                                },
                                'Nội dung đề bài đã được cập nhật thành công.',
                              );
                            },
                      icon: const Icon(Icons.save, size: 18),
                      label: const Text('Lưu', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 0,
                        minimumSize: Size.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
          const SizedBox(height: 20),

          // Reference Solution section
          Row(
            key: widget.referenceSolutionSectionKey,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: colorScheme.tertiary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Bài giải tham khảo',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Cung cấp phương pháp của giáo viên trên lớp để trợ lý đưa ra hướng dẫn đồng nhất.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(ESizes.radiusMd),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _solutionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Nhập bài giải tham khảo...',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt_outlined),
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              await _runSubmit(
                                () async {
                                  await widget.onUploadReferenceFromCamera?.call();
                                },
                                'Đã tải ảnh bài giải tham khảo từ camera.',
                              );
                            },
                      color: colorScheme.onSurfaceVariant,
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.image_outlined),
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              await _runSubmit(
                                () async {
                                  await widget.onUploadReferenceFromGallery?.call();
                                },
                                'Đã tải ảnh bài giải tham khảo từ thư viện ảnh.',
                              );
                            },
                      color: colorScheme.onSurfaceVariant,
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        _solutionController.text = _savedSolutionText;
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.onSurfaceVariant,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('Hủy', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              await _runSubmit(
                                () async {
                                  final solution = _solutionController.text.trim();
                                  await widget.onSaveReferenceSolution?.call(solution);
                                  _savedSolutionText = solution;
                                },
                                'Edumate đã ghi nhận lời giải mẫu của giáo viên. Các câu hỏi gợi mở tiếp theo sẽ được bám sát theo phương pháp này.',
                              );
                            },
                      icon: const Icon(Icons.save, size: 18),
                      label: const Text('Lưu lại', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 0,
                        minimumSize: Size.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
          const SizedBox(height: 20),

          // Extended Practice section
          Row(
            key: widget.extendedPracticeSectionKey,
            children: [
              Icon(Icons.sync, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Luyện tập mở rộng',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Yêu cầu AI tạo ra một bài tập mới cùng dạng để con ôn luyện sâu hơn.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _similarHintController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Ghi chú yêu cầu (ví dụ: đổi nhân vật, số liệu nhỏ hơn)...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ESizes.radiusMd),
              ),
              isDense: true,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: _isSubmitting
                  ? null
                  : () async {
                      await _runSubmit(
                        () async {
                          await widget.onGenerateSimilar?.call(
                            _similarHintController.text.trim(),
                          );
                        },
                        'Edumate đang tạo bài tương tự theo yêu cầu của ba mẹ.',
                      );
                    },
              icon: const Icon(Icons.add),
              label: const Text('Bắt đầu tạo bài'),
              style: TextButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
