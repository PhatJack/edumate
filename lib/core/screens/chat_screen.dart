import 'dart:async';

import 'package:edumate/core/constants/sizes.dart';
import 'package:edumate/core/exceptions/api_exception.dart';
import 'package:edumate/core/widgets/app_layout.dart';
import 'package:edumate/core/widgets/chat/bot_message_bubble.dart';
import 'package:edumate/core/widgets/chat/exercise_list_sheet.dart';
import 'package:edumate/core/widgets/chat/manage_exercise_sheet.dart';
import 'package:edumate/core/widgets/guided_tour_modal.dart';
import 'package:edumate/data/models/chat_models.dart';
import 'package:edumate/data/models/document_models.dart';
import 'package:edumate/data/repositories/chat_repository.dart';
import 'package:edumate/data/repositories/documents_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final String documentId;
  final String documentTitle;
  final IconData documentIcon;

  const ChatScreen({
    super.key,
    required this.documentId,
    required this.documentTitle,
    required this.documentIcon,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatRepository _chatRepository = ChatRepository.create();
  final DocumentsRepository _documentsRepository = DocumentsRepository.create();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _layoutScaffoldKey = GlobalKey<ScaffoldState>();
  final DrawerTourAnchors _drawerTourAnchors = DrawerTourAnchors();
  final GlobalKey _chatInputSelectKey = GlobalKey();
  final GlobalKey _centerProblemPanelKey = GlobalKey();
  final GlobalKey _manageButtonKey = GlobalKey();
  final GlobalKey _manageDetailsSectionKey = GlobalKey();
  final GlobalKey _manageReferenceSectionKey = GlobalKey();
  final GlobalKey _manageExtendedSectionKey = GlobalKey();
  final DrawerTourController _drawerTourController = DrawerTourController();

  bool _isManageSheetOpen = false;
  bool _isExerciseSheetOpen = false;
  bool _isLoading = true;
  bool _isSending = false;
  String? _loadError;

  String? _selectedExerciseId;

  final Map<String, String> _exerciseTitlesById = {};

  final List<Map<String, dynamic>> _messages = [];

  String? get _selectedExerciseTitle {
    if (_selectedExerciseId == null) {
      return null;
    }
    return _exerciseTitlesById[_selectedExerciseId!];
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Map<String, dynamic> _toUiMessage(ChatMessage message) {
    final role = message.role == 'assistant' ? 'bot' : message.role;
    return {
      'role': role,
      'text': message.content,
      'message_type': message.messageType,
      'meta': message.meta,
      'exercise_id': message.exerciseId,
    };
  }

  Future<void> _loadInitialData() async {
    if (widget.documentId.trim().isEmpty) {
      setState(() {
        _isLoading = false;
        _loadError = 'Thiếu document_id. Không thể tải phiên trò chuyện.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final results = await Future.wait([
        _documentsRepository.listExercises(widget.documentId),
        _chatRepository.listMessages(widget.documentId),
      ]);

      final exercises = results[0] as List<Exercise>;
      final messages = (results[1] as MessagesListResponse).items;
      final exerciseTitles = <String, String>{
        for (final exercise in exercises) exercise.id: exercise.title,
      };
      final uiMessages = messages.map(_toUiMessage).toList(growable: false);

      String? selectedExerciseId;
      ChatMessage? welcomeMessage;
      for (final message in messages) {
        if (message.messageType == 'welcome') {
          welcomeMessage = message;
        }
      }
      if (welcomeMessage != null && welcomeMessage.welcomeExerciseIds.isNotEmpty) {
        selectedExerciseId = welcomeMessage.welcomeExerciseIds.first;
      }
      selectedExerciseId ??= exerciseTitles.isNotEmpty ? exerciseTitles.keys.first : null;

      if (!mounted) {
        return;
      }

      setState(() {
        _exerciseTitlesById
          ..clear()
          ..addAll(exerciseTitles);
        _messages
          ..clear()
          ..addAll(uiMessages);
        _selectedExerciseId = selectedExerciseId;
        _isLoading = false;
        _loadError = null;
      });
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _loadError = e.message;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _loadError = 'Không thể tải dữ liệu cuộc trò chuyện: $e';
      });
    }
  }

  Future<void> _updateSelectedExercise({
    String? detail,
    String? sampleSolution,
    bool? clearSampleSolutionImage,
  }) async {
    final exerciseId = _selectedExerciseId;
    if (exerciseId == null) {
      return;
    }

    await _documentsRepository.updateExercise(
      widget.documentId,
      exerciseId,
      ExerciseUpdateRequest(
        detail: detail,
        sampleSolution: sampleSolution,
        clearSampleSolutionImage: clearSampleSolutionImage,
      ),
    );
  }

  Future<void> _uploadReferenceImage(ImageSource source) async {
    final exerciseId = _selectedExerciseId;
    if (exerciseId == null) {
      return;
    }

    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 95);
    if (image == null) {
      return;
    }

    final bytes = await image.readAsBytes();
    await _documentsRepository.uploadExerciseSampleSolutionImage(
      widget.documentId,
      exerciseId,
      MultipartFile.fromBytes(
        bytes,
        filename: image.name.isEmpty
            ? 'sample-solution-${DateTime.now().millisecondsSinceEpoch}.jpg'
            : image.name,
      ),
    );
  }

  Future<void> _generateSimilarExercise(String hint) async {
    final exerciseId = _selectedExerciseId;
    if (exerciseId == null) {
      return;
    }

    final created = await _documentsRepository.generateSimilarExercise(
      widget.documentId,
      exerciseId,
      hint: hint,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _exerciseTitlesById[created.id] = created.title;
      _selectedExerciseId = created.id;
      _messages.add({
        'role': 'system',
        'message_type': 'text',
        'text': 'Đã tạo bài tương tự mới: ${created.title}',
        'exercise_id': created.id,
      });
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _drawerTourController.dispose();
    super.dispose();
  }

  void _selectExerciseByTitle(String exerciseTitle) {
    String? selectedId;
    for (final entry in _exerciseTitlesById.entries) {
      if (entry.value == exerciseTitle) {
        selectedId = entry.key;
        break;
      }
    }
    if (selectedId == null) {
      return;
    }

    setState(() {
      _selectedExerciseId = selectedId;
      // Thêm tin nhắn xác nhận
      bool hasConfirmation = _messages.any((msg) => msg['text'].toString().contains('Đã chuyển trọng tâm sang'));
      if (!hasConfirmation) {
         _messages.add({
          'role': 'system',
          'message_type': 'text',
          'text': 'Đã chuyển trọng tâm sang $exerciseTitle. Ba mẹ cần Edumate gợi ý cách giảng hay muốn kiểm tra kết quả của bé?',
          'exercise_id': _selectedExerciseId,
        });
      } else {
        // Cập nhật tin nhắn xác nhận
        final idx = _messages.lastIndexWhere((msg) => msg['text'].toString().contains('Đã chuyển trọng tâm sang'));
        if (idx != -1) {
          _messages[idx] = {
            'role': 'system',
            'message_type': 'text',
            'text': 'Đã chuyển trọng tâm sang $exerciseTitle. Ba mẹ cần Edumate gợi ý cách giảng hay muốn kiểm tra kết quả của bé?',
            'exercise_id': _selectedExerciseId,
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
    final msg = _messages.firstWhere(
      (m) => m['message_type'] == 'welcome',
      orElse: () => <String, dynamic>{},
    );
    final dynamic meta = msg['meta'];
    final dynamic rawExerciseIds =
        meta is Map<String, dynamic> ? meta['exercise_ids'] : null;
    final List<String> exerciseIds = rawExerciseIds is List
        ? rawExerciseIds.map((e) => e.toString()).toList()
        : <String>[];
    final List<String> exercises = exerciseIds
        .map((id) => _exerciseTitlesById[id])
        .whereType<String>()
        .toList();
    if (exercises.isEmpty) {
      exercises.addAll(_exerciseTitlesById.values);
    }
    if (exercises.isEmpty || _isExerciseSheetOpen) return;

    _isExerciseSheetOpen = true;
    unawaited(
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ExerciseListSheet(
          exercises: exercises,
          selectedExercise: _selectedExerciseTitle,
          onSelect: _selectExerciseByTitle,
        ),
      ).whenComplete(() {
        _isExerciseSheetOpen = false;
      }),
    );
  }

  void _showManageExerciseModal() {
    if (_selectedExerciseTitle == null) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ManageExerciseSheet(
        exerciseTitle: _selectedExerciseTitle!,
        onSaveDetails: (detail) => _updateSelectedExercise(detail: detail),
        onSaveReferenceSolution: (solution) =>
          _updateSelectedExercise(sampleSolution: solution),
        onUploadReferenceFromCamera: () =>
          _uploadReferenceImage(ImageSource.camera),
        onUploadReferenceFromGallery: () =>
          _uploadReferenceImage(ImageSource.gallery),
        onGenerateSimilar: _generateSimilarExercise,
        detailsSectionKey: _manageDetailsSectionKey,
        referenceSolutionSectionKey: _manageReferenceSectionKey,
        extendedPracticeSectionKey: _manageExtendedSectionKey,
        onAddBotMessage: (String text) {
          setState(() {
            _messages.add({
              'role': 'system',
              'message_type': 'text',
              'text': text,
              'exercise_id': _selectedExerciseId,
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

  Future<void> _openManageExerciseModalForTour() async {
    if (_isManageSheetOpen) {
      return;
    }

    if (_selectedExerciseId == null && _exerciseTitlesById.isNotEmpty) {
      setState(() {
        _selectedExerciseId = _exerciseTitlesById.keys.first;
      });
    }

    if (_selectedExerciseTitle == null) {
      return;
    }

    _isManageSheetOpen = true;
    unawaited(
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ManageExerciseSheet(
          exerciseTitle: _selectedExerciseTitle!,
          onSaveDetails: (detail) => _updateSelectedExercise(detail: detail),
          onSaveReferenceSolution: (solution) =>
            _updateSelectedExercise(sampleSolution: solution),
          onUploadReferenceFromCamera: () =>
            _uploadReferenceImage(ImageSource.camera),
          onUploadReferenceFromGallery: () =>
            _uploadReferenceImage(ImageSource.gallery),
          onGenerateSimilar: _generateSimilarExercise,
          detailsSectionKey: _manageDetailsSectionKey,
          referenceSolutionSectionKey: _manageReferenceSectionKey,
          extendedPracticeSectionKey: _manageExtendedSectionKey,
        ),
      ).whenComplete(() {
        _isManageSheetOpen = false;
      }),
    );

    await Future.delayed(const Duration(milliseconds: 350));
  }

  Future<void> _openExerciseListModalForTour() async {
    await _closeDrawerIfOpen();
    _showExerciseListModal();
    await Future.delayed(const Duration(milliseconds: 320));
  }

  Future<void> _openDrawerForTour() async {
    _layoutScaffoldKey.currentState?.openDrawer();
    await Future.delayed(const Duration(milliseconds: 280));
  }

  Future<void> _closeDrawerIfOpen() async {
    final scaffoldState = _layoutScaffoldKey.currentState;
    final scaffoldContext = _layoutScaffoldKey.currentContext;
    if (scaffoldState == null || scaffoldContext == null) {
      return;
    }

    if (scaffoldState.isDrawerOpen) {
      Navigator.of(scaffoldContext).pop();
      await Future.delayed(const Duration(milliseconds: 250));
    }
  }

  Future<void> _closeManageSheetIfOpen() async {
    if (!_isManageSheetOpen) {
      return;
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
    await Future.delayed(const Duration(milliseconds: 250));
  }

  Future<void> _closeExerciseListIfOpen() async {
    if (!_isExerciseSheetOpen) {
      return;
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
    await Future.delayed(const Duration(milliseconds: 220));
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    final exerciseId = _selectedExerciseId;
    if (text.isEmpty || exerciseId == null || _isSending) {
      return;
    }

    setState(() {
      _isSending = true;
      _messages.add({
        'role': 'user',
        'message_type': 'text',
        'text': text,
        'exercise_id': exerciseId,
      });
      _inputController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });

    try {
      final response = await _chatRepository.sendMessage(
        widget.documentId,
        message: text,
        exerciseId: exerciseId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        if (response.messages.isNotEmpty) {
          _messages
            ..clear()
            ..addAll(response.messages.map(_toUiMessage));
        } else if (response.reply.trim().isNotEmpty) {
          _messages.add({
            'role': 'bot',
            'message_type': 'text',
            'text': response.reply,
            'exercise_id': exerciseId,
          });
        }
      });
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể gửi tin nhắn: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _runGuidedTour() async {
    final steps = <_TourRuntimeStep>[
      _TourRuntimeStep(
        step: const GuidedTourStep(
          title: 'Chào mừng ba mẹ! 🌟',
          description:
              'Edumate không phải là một chiếc máy giải bài tập khô khan. Chúng mình là người bạn đồng hành, giúp ba mẹ thấu hiểu phương pháp sư phạm để tự tin hướng dẫn con tự tư duy và tìm ra đáp án.',
        ),
        forceCenter: true,
        preAction: () async {
          await _closeManageSheetIfOpen();
          await _closeDrawerIfOpen();
        },
      ),
      _TourRuntimeStep(
        step: const GuidedTourStep(
          title: '1. Gửi bài tập của con 📚',
          description:
              'Bắt đầu bằng việc tải lên sách giáo khoa, chụp ảnh phiếu bài tập hoặc kết nối với Google Drive của lớp nhé.',
        ),
        forceCenter: true,
        preAction: () async {
          await _closeManageSheetIfOpen();
          await _closeExerciseListIfOpen();
          await _openDrawerForTour();
          await _drawerTourController.openAddDocumentModal?.call();
        },
      ),
      _TourRuntimeStep(
        step: const GuidedTourStep(
          title: '2. Không gian học riêng biệt 🗂️',
          description:
              'Mỗi tài liệu sẽ nằm trong một cuộc trò chuyện riêng. Như vậy, Toán và Tiếng Việt của con sẽ không bao giờ bị lẫn lộn vào nhau!',
        ),
        targetKey: _drawerTourAnchors.managementHeaderKey,
        preAction: () async {
          await _drawerTourController.closeAddDocumentModal?.call();
          await _openDrawerForTour();
        },
      ),
      _TourRuntimeStep(
        step: const GuidedTourStep(
          title: '3. Chọn bài tập mục tiêu 🎯',
          description:
              'Sau khi AI quét xong, ba mẹ nhớ chọn một bài tập cụ thể ở đây nhé. Edumate cần biết ba mẹ đang muốn giảng bài nào để hỗ trợ chính xác nhất!',
        ),
        targetKey: _chatInputSelectKey,
        preAction: _openExerciseListModalForTour,
      ),
      _TourRuntimeStep(
        step: const GuidedTourStep(
          title: '4. Theo dõi đề bài 📖',
          description:
              'Khi đã chọn bài, nội dung chi tiết sẽ hiện ở khung này. Ba mẹ có thể vừa xem đề, vừa trò chuyện với Edumate mà không cần lật lại sách.',
        ),
        targetKey: _centerProblemPanelKey,
        forceCenter: true,
        preAction: () async {
          await _closeExerciseListIfOpen();
          await _closeDrawerIfOpen();
        },
      ),
      _TourRuntimeStep(
        step: const GuidedTourStep(
          title: '5. Hiệu chỉnh dễ dàng ✍️',
          description:
              'Đôi khi ảnh mờ khiến hệ thống đọc nhầm. Ba mẹ chỉ cần nhấn vào đây để sửa lại chữ số cho chuẩn xác nhé.',
        ),
        targetKey: _manageDetailsSectionKey,
        preAction: () async {
          await _closeDrawerIfOpen();
          await _openManageExerciseModalForTour();
        },
      ),
      _TourRuntimeStep(
        step: const GuidedTourStep(
          title: '6. Dạy đúng cách của Cô giáo 👩‍🏫',
          description:
              'Tuyệt chiêu đây! Ba mẹ hãy chụp ảnh hoặc ghi chú lại cách cô giáo chữa bài trên lớp vào đây. Edumate sẽ bám sát phương pháp đó để gợi ý, giúp con không bị rối.',
        ),
        targetKey: _manageReferenceSectionKey,
        preAction: _openManageExerciseModalForTour,
      ),
      _TourRuntimeStep(
        step: const GuidedTourStep(
          title: '7. Thực hành cho nhớ lâu 🧩',
          description:
              'Bé làm xong rồi? Ba mẹ hãy yêu cầu tạo thêm bài tương tự (ví dụ: đổi thành quả cam, số nhỏ hơn 10) để con thực hành lại nha!',
        ),
        targetKey: _manageExtendedSectionKey,
        preAction: _openManageExerciseModalForTour,
      ),
      _TourRuntimeStep(
        step: const GuidedTourStep(
          title: '8. Thấu hiểu con yêu ❤️',
          description:
              'Mỗi bé là một cá thể riêng biệt. Ba mẹ hãy cập nhật tính cách, lực học của con để Edumate có những lời khuyên tâm lý nhất',
        ),
        forceCenter: true,
        preAction: () async {
          await _closeManageSheetIfOpen();
          await _openDrawerForTour();
          await _drawerTourController.openChildrenManagerModal?.call();
        },
      ),
      _TourRuntimeStep(
        step: const GuidedTourStep(
          title: 'Sẵn sàng rồi! 🚀',
          description:
              'Chuyến tham quan kết thúc. Ba mẹ hãy tải lên tài liệu đầu tiên và cùng Edumate mang đến cho con những giờ học thật vui nhé!',
        ),
        forceCenter: true,
        preAction: () async {
          await _drawerTourController.closeChildrenManagerModal?.call();
          await _closeManageSheetIfOpen();
          await _closeExerciseListIfOpen();
          await _closeDrawerIfOpen();
        },
      ),
    ];

    var index = 0;
    while (mounted && index < steps.length) {
      final current = steps[index];

      if (current.preAction != null) {
        await current.preAction!.call();
        if (!mounted) {
          return;
        }
      }

      final action = await showGuidedTourStepModal(
        context,
        step: current.step,
        currentStep: index + 1,
        totalSteps: steps.length,
        canGoBack: index > 0,
        isLastStep: index == steps.length - 1,
        targetKey: current.targetKey,
        forceCenter: current.forceCenter,
      );

      if (!mounted) {
        return;
      }

      if (action == TourStepAction.close) {
        await _drawerTourController.closeChildrenManagerModal?.call();
        await _closeManageSheetIfOpen();
        await _closeExerciseListIfOpen();
        await _drawerTourController.closeAddDocumentModal?.call();
        await _closeDrawerIfOpen();
        return;
      }
      if (action == TourStepAction.back) {
        if (index > 0) {
          index -= 1;
        }
        continue;
      }
      index += 1;
    }

    await _drawerTourController.closeChildrenManagerModal?.call();
    await _closeManageSheetIfOpen();
    await _closeExerciseListIfOpen();
    await _drawerTourController.closeAddDocumentModal?.call();
    await _closeDrawerIfOpen();
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
            if (_selectedExerciseId != null)
              Container(
                key: _manageButtonKey,
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
                onPressed: _runGuidedTour,
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
      scaffoldKey: _layoutScaffoldKey,
      drawerTourAnchors: _drawerTourAnchors,
      drawerTourController: _drawerTourController,
      title: widget.documentTitle,
      actions: actions,
      onPlayPressed: _runGuidedTour,
      body: Column(
        children: [
          Expanded(
            key: _centerProblemPanelKey,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _loadError != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _loadError!,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.error,
                                ),
                              ),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: _loadInitialData,
                                child: const Text('Tải lại'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                
                          if (msg['role'] == 'system' ||
                              msg['role'] == 'bot' ||
                              msg['role'] == 'assistant') {
                            Widget? bottomWidget;
                  
                            if (msg['message_type'] == 'welcome') {
                              final dynamic meta = msg['meta'];
                              final dynamic rawExerciseIds =
                                  meta is Map<String, dynamic>
                                      ? meta['exercise_ids']
                                      : null;
                              final List<String> exerciseIds = rawExerciseIds is List
                                  ? rawExerciseIds
                                      .map((e) => e.toString())
                                      .toList()
                                  : <String>[];
                              final List<String> exercises = exerciseIds
                                  .map((id) => _exerciseTitlesById[id])
                                  .whereType<String>()
                                  .toList();
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
                                  for (final ex in exercises)
                                    _buildExerciseItem(context, ex),
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
                
                          if (msg['role'] == 'user') {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  constraints: const BoxConstraints(maxWidth: 320),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    msg['text']?.toString() ?? '',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          return const SizedBox.shrink();
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
                    key: _chatInputSelectKey,
                    onTap: _showExerciseListModal,
                    borderRadius: BorderRadius.circular(ESizes.radiusMd),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedExerciseId == null
                            ? colorScheme.surfaceContainerHighest
                            : colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(ESizes.radiusMd),
                        border: _selectedExerciseId != null
                            ? Border.all(color: colorScheme.primary.withValues(alpha: 0.3))
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _selectedExerciseId == null
                                ? Icons.format_list_bulleted
                                : Icons.segment,
                            size: 18,
                            color: _selectedExerciseId == null
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedExerciseTitle ??
                                  'Chọn bài tập mục tiêu để bắt đầu...',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _selectedExerciseId == null
                                    ? colorScheme.onSurfaceVariant
                                    : colorScheme.primary,
                                fontWeight: _selectedExerciseId == null
                                    ? FontWeight.normal
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 18,
                            color: _selectedExerciseId == null
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.primary,
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
                            hintText: _selectedExerciseId == null
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
                          onPressed: (_selectedExerciseId == null || _isSending)
                              ? null
                              : _sendMessage,
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
        onTap: () => _selectExerciseByTitle(title),
      ),
    );
  }
}

class _TourRuntimeStep {
  final GuidedTourStep step;
  final GlobalKey? targetKey;
  final bool forceCenter;
  final Future<void> Function()? preAction;

  const _TourRuntimeStep({
    required this.step,
    this.targetKey,
    this.forceCenter = false,
    this.preAction,
  });
}
