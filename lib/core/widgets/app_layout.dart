import 'package:edumate/core/constants/sizes.dart';
import 'package:edumate/core/providers/documents_provider.dart';
import 'package:edumate/core/widgets/app_header.dart';
import 'package:edumate/core/widgets/confirm_action_modal.dart';
import 'package:edumate/core/widgets/guided_tour_modal.dart';
import 'package:flutter/material.dart';

/// Layout dùng chung cho tất cả màn hình (trừ Login, Register, Intro).
///
/// Cung cấp sẵn:
/// - [EAppBar] nhất quán
/// - [Drawer] với danh sách tài liệu
/// - Modal "Thêm nguồn tài liệu học tập"
///
/// Cách dùng:
/// ```dart
/// class MyScreen extends StatelessWidget {
///   Widget build(BuildContext context) {
///     return EAppLayout(
///       title: 'Tiêu đề',          // tuỳ chọn
///       body: YourBodyWidget(),
///     );
///   }
/// }
/// ```
class EAppLayout extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final VoidCallback? onPlayPressed;
  final DrawerTourAnchors? drawerTourAnchors;
  final DrawerTourController? drawerTourController;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const EAppLayout({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.onPlayPressed,
    this.drawerTourAnchors,
    this.drawerTourController,
    this.scaffoldKey,
  });

  Future<void> _runDefaultTour(BuildContext context) async {
    Future<void> openDrawerForTour() async {
      scaffoldKey?.currentState?.openDrawer();
      await Future.delayed(const Duration(milliseconds: 280));
    }

    Future<void> closeDrawerIfOpen() async {
      final scaffoldState = scaffoldKey?.currentState;
      final scaffoldContext = scaffoldKey?.currentContext;
      if (scaffoldState == null || scaffoldContext == null) {
        return;
      }

      if (scaffoldState.isDrawerOpen) {
        Navigator.of(scaffoldContext).pop();
        await Future.delayed(const Duration(milliseconds: 250));
      }
    }

    final steps = <_LayoutTourRuntimeStep>[
      _LayoutTourRuntimeStep(
        step: const GuidedTourStep(
          title: 'Chào mừng ba mẹ! 🌟',
          description:
              'Edumate không phải là một chiếc máy giải bài tập khô khan. Chúng mình là người bạn đồng hành, giúp ba mẹ thấu hiểu phương pháp sư phạm để tự tin hướng dẫn con tự tư duy và tìm ra đáp án.',
        ),
        forceCenter: true,
        preAction: () async {
          await drawerTourController?.closeChildrenManagerModal?.call();
          await drawerTourController?.closeAddDocumentModal?.call();
          await closeDrawerIfOpen();
        },
      ),
      _LayoutTourRuntimeStep(
        step: const GuidedTourStep(
          title: '1. Gửi bài tập của con 📚',
          description:
              'Bắt đầu bằng việc tải lên sách giáo khoa, chụp ảnh phiếu bài tập hoặc kết nối với Google Drive của lớp nhé.',
        ),
        forceCenter: true,
        preAction: () async {
          await closeDrawerIfOpen();
          await openDrawerForTour();
          await drawerTourController?.openAddDocumentModal?.call();
        },
      ),
      _LayoutTourRuntimeStep(
        step: const GuidedTourStep(
          title: '2. Không gian học riêng biệt 🗂️',
          description:
              'Mỗi tài liệu sẽ nằm trong một cuộc trò chuyện riêng. Như vậy, Toán và Tiếng Việt của con sẽ không bao giờ bị lẫn lộn vào nhau!',
        ),
        targetKey: drawerTourAnchors?.managementHeaderKey,
        preAction: () async {
          await drawerTourController?.closeAddDocumentModal?.call();
          await openDrawerForTour();
        },
      ),
      _LayoutTourRuntimeStep(
        step: const GuidedTourStep(
          title: '3. Chọn bài tập mục tiêu 🎯',
          description:
              'Sau khi AI quét xong, ba mẹ nhớ chọn một bài tập cụ thể ở đây nhé. Edumate cần biết ba mẹ đang muốn giảng bài nào để hỗ trợ chính xác nhất!',
        ),
        forceCenter: true,
      ),
      _LayoutTourRuntimeStep(
        step: const GuidedTourStep(
          title: '4. Theo dõi đề bài 📖',
          description:
              'Khi đã chọn bài, nội dung chi tiết sẽ hiện ở khung này. Ba mẹ có thể vừa xem đề, vừa trò chuyện với Edumate mà không cần lật lại sách.',
        ),
        forceCenter: true,
        preAction: closeDrawerIfOpen,
      ),
      _LayoutTourRuntimeStep(
        step: const GuidedTourStep(
          title: '5. Hiệu chỉnh dễ dàng ✍️',
          description:
              'Đôi khi ảnh mờ khiến hệ thống đọc nhầm. Ba mẹ chỉ cần nhấn vào đây để sửa lại chữ số cho chuẩn xác nhé.',
        ),
        forceCenter: true,
      ),
      _LayoutTourRuntimeStep(
        step: const GuidedTourStep(
          title: '6. Dạy đúng cách của Cô giáo 👩‍🏫',
          description:
              'Tuyệt chiêu đây! Ba mẹ hãy chụp ảnh hoặc ghi chú lại cách cô giáo chữa bài trên lớp vào đây. Edumate sẽ bám sát phương pháp đó để gợi ý, giúp con không bị rối.',
        ),
        forceCenter: true,
      ),
      _LayoutTourRuntimeStep(
        step: const GuidedTourStep(
          title: '7. Thực hành cho nhớ lâu 🧩',
          description:
              'Bé làm xong rồi? Ba mẹ hãy yêu cầu tạo thêm bài tương tự (ví dụ: đổi thành quả cam, số nhỏ hơn 10) để con thực hành lại nha!',
        ),
        forceCenter: true,
      ),
      _LayoutTourRuntimeStep(
        step: const GuidedTourStep(
          title: '8. Thấu hiểu con yêu ❤️',
          description:
              'Mỗi bé là một cá thể riêng biệt. Ba mẹ hãy cập nhật tính cách, lực học của con để Edumate có những lời khuyên tâm lý nhất',
        ),
        forceCenter: true,
        preAction: () async {
          await closeDrawerIfOpen();
          await openDrawerForTour();
          await drawerTourController?.openChildrenManagerModal?.call();
        },
      ),
      _LayoutTourRuntimeStep(
        step: const GuidedTourStep(
          title: 'Sẵn sàng rồi! 🚀',
          description:
              'Chuyến tham quan kết thúc. Ba mẹ hãy tải lên tài liệu đầu tiên và cùng Edumate mang đến cho con những giờ học thật vui nhé!',
        ),
        forceCenter: true,
        preAction: () async {
          await drawerTourController?.closeChildrenManagerModal?.call();
          await drawerTourController?.closeAddDocumentModal?.call();
          await closeDrawerIfOpen();
        },
      ),
    ];

    var index = 0;
    while (index < steps.length) {
      final current = steps[index];

      if (current.preAction != null) {
        await current.preAction!.call();
        if (!context.mounted) {
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

      if (action == TourStepAction.close) {
        await drawerTourController?.closeChildrenManagerModal?.call();
        await drawerTourController?.closeAddDocumentModal?.call();
        await closeDrawerIfOpen();
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

    await drawerTourController?.closeChildrenManagerModal?.call();
    await drawerTourController?.closeAddDocumentModal?.call();
    await closeDrawerIfOpen();
  }

  // ── Modal thêm tài liệu ──────────────────────────────────────────────────
  Future<void> _showAddModal(
    BuildContext context, {
    DrawerTourController? tourController,
  }) async {
    // Ngăn chặn mở modal khi đã có modal add document khác đang mở
    if (tourController?.isAddDocumentModalOpen.value ?? false) {
      return;
    }

    if (tourController != null) {
      tourController.isAddDocumentModalOpen.value = true;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddDocumentModal(
        onSelected: (doc) {
          DocumentsProvider.add(context, doc);
          Navigator.of(context).pop(); // đóng modal
          Navigator.of(context).pushNamed(
            '/chat',
            arguments: {'title': doc.title, 'icon': doc.icon},
          );
        },
      ),
    );

    if (tourController != null) {
      tourController.isAddDocumentModalOpen.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (drawerTourController != null) {
      drawerTourController!.openAddDocumentModal = () async {
        await _showAddModal(context, tourController: drawerTourController);
      };
      drawerTourController!.closeAddDocumentModal = () async {
        if (!(drawerTourController!.isAddDocumentModalOpen.value)) {
          return;
        }
        Navigator.of(context).pop();
        await Future.delayed(const Duration(milliseconds: 200));
      };
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: EAppBar(
        title: title,
        showMenuIcon: true,
        actions: actions,
        onPlayPressed: onPlayPressed ?? () => _runDefaultTour(context),
      ),
      drawer: _AppDrawer(
        onAddDocument: () => _showAddModal(context),
        tourAnchors: drawerTourAnchors,
        tourController: drawerTourController,
      ),
      body: body,
    );
  }
}

class _LayoutTourRuntimeStep {
  final GuidedTourStep step;
  final GlobalKey? targetKey;
  final bool forceCenter;
  final Future<void> Function()? preAction;

  const _LayoutTourRuntimeStep({
    required this.step,
    this.targetKey,
    this.forceCenter = false,
    this.preAction,
  });
}

class DrawerTourAnchors {
  final GlobalKey addDocumentButtonKey = GlobalKey();
  final GlobalKey managementHeaderKey = GlobalKey();
  final GlobalKey childProfileCardKey = GlobalKey();
}

class DrawerTourController {
  Future<void> Function()? openAddDocumentModal;
  Future<void> Function()? closeAddDocumentModal;
  Future<void> Function()? openChildrenManagerModal;
  Future<void> Function()? closeChildrenManagerModal;
  final ValueNotifier<bool> isAddDocumentModalOpen = ValueNotifier(false);
  final ValueNotifier<bool> isChildrenManagerModalOpen = ValueNotifier(false);

  void dispose() {
    isAddDocumentModalOpen.dispose();
    isChildrenManagerModalOpen.dispose();
  }
}

// ─── Drawer ───────────────────────────────────────────────────────────────────

class _AppDrawer extends StatefulWidget {
  final VoidCallback onAddDocument;
  final DrawerTourAnchors? tourAnchors;
  final DrawerTourController? tourController;

  const _AppDrawer({
    required this.onAddDocument,
    this.tourAnchors,
    this.tourController,
  });

  @override
  State<_AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<_AppDrawer> {
  List<_ChildProfile> _children = const [
    _ChildProfile(
      id: 'child-1',
      name: 'Bé Moon',
      className: '4A',
      learningNotes: 'Tiếp thu toán hình chậm, cần hướng dẫn bằng ví dụ thực tế.',
    ),
  ];
  String? _selectedChildId = 'child-1';

  @override
  void initState() {
    super.initState();
    _bindTourController();
  }

  @override
  void didUpdateWidget(covariant _AppDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tourController != widget.tourController) {
      oldWidget.tourController?.openChildrenManagerModal = null;
      oldWidget.tourController?.closeChildrenManagerModal = null;
      _bindTourController();
    }
  }

  @override
  void dispose() {
    widget.tourController?.openChildrenManagerModal = null;
    widget.tourController?.closeChildrenManagerModal = null;
    super.dispose();
  }

  void _bindTourController() {
    if (widget.tourController == null) {
      return;
    }

    widget.tourController!.openChildrenManagerModal = _openChildrenManagerModal;
    widget.tourController!.closeChildrenManagerModal =
        _closeChildrenManagerModalIfOpen;
  }

  _ChildProfile? get _selectedChild {
    for (final child in _children) {
      if (child.id == _selectedChildId) {
        return child;
      }
    }
    return _children.isEmpty ? null : _children.first;
  }

  Future<void> _openChildrenManagerModal() async {
    if (widget.tourController?.isChildrenManagerModalOpen.value ?? false) {
      return;
    }

    if (widget.tourController != null) {
      widget.tourController!.isChildrenManagerModalOpen.value = true;
    }

    final result = await showModalBottomSheet<_ChildrenManagerResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChildrenManagerModal(
        initialChildren: _children,
        selectedChildId: _selectedChildId,
      ),
    );

    if (widget.tourController != null) {
      widget.tourController!.isChildrenManagerModalOpen.value = false;
    }

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _children = result.children;
      _selectedChildId = result.selectedChildId;
    });
  }

  Future<void> _closeChildrenManagerModalIfOpen() async {
    if (!(widget.tourController?.isChildrenManagerModalOpen.value ?? false)) {
      return;
    }

    Navigator.of(context).pop();
    await Future.delayed(const Duration(milliseconds: 220));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.school,
                      color: colorScheme.onPrimary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Edumate',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            Divider(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              height: 1,
            ),

            // ── Nút thêm tài liệu ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: widget.tourController == null
                  ? ElevatedButton.icon(
                      key: widget.tourAnchors?.addDocumentButtonKey,
                      onPressed: () {
                        Navigator.pop(context); // đóng drawer trước
                        widget.onAddDocument();
                      },
                      icon: Icon(Icons.add, color: colorScheme.onPrimary, size: 20),
                      label: Text(
                        'Thêm tài liệu học',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: ESizes.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ESizes.sm),
                        ),
                        elevation: 0,
                      ),
                    )
                  : ValueListenableBuilder<bool>(
                      valueListenable: widget.tourController!.isAddDocumentModalOpen,
                      builder: (context, isModalOpen, _) {
                        return ElevatedButton.icon(
                          key: widget.tourAnchors?.addDocumentButtonKey,
                          onPressed: isModalOpen
                              ? null
                              : () {
                                  Navigator.pop(context); // đóng drawer trước
                                  widget.onAddDocument();
                                },
                          icon: Icon(Icons.add, color: colorScheme.onPrimary, size: 20),
                          label: Text(
                            'Thêm tài liệu học',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: ESizes.md),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ESizes.sm),
                            ),
                            elevation: 0,
                          ),
                        );
                      },
                    ),
            ),

            // ── Tiêu đề danh sách ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                key: widget.tourAnchors?.managementHeaderKey,
                'DANH SÁCH QUẢN LÝ',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            // ── Danh sách tài liệu động ─────────────────────────────────────
            Expanded(
              child: ValueListenableBuilder<List<DocumentItem>>(
                valueListenable: DocumentsProvider.of(context),
                builder: (context, docs, _) {
                  if (docs.isEmpty) {
                    return Center(
                      child: Text(
                        'Chưa có tài liệu nào',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: docs.length,
                    itemBuilder: (context, index) => _DrawerItem(
                      doc: docs[index],
                      onView: () {
                        Navigator.pop(context); // đóng drawer
                        Navigator.pushNamed(
                          context,
                          '/chat',
                          arguments: {
                            'title': docs[index].title,
                            'icon': docs[index].icon,
                          },
                        );
                      },
                      onDelete: () async {
                        final confirmed = await showConfirmDeleteModal(
                          context,
                          title: 'Xoa tai lieu',
                          message:
                              'Ban co chac chan muon xoa tai lieu "${docs[index].title}"?',
                        );

                        if (!confirmed || !context.mounted) {
                          return;
                        }

                        DocumentsProvider.removeAt(context, index);
                      },
                    ),
                  );
                },
              ),
            ),

            // ── User profile ─────────────────────────────────────────────────
            Divider(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                key: widget.tourAnchors?.childProfileCardKey,
                borderRadius: BorderRadius.circular(16),
                onTap: _openChildrenManagerModal,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            (_selectedChild?.name.isNotEmpty ?? false)
                                ? _selectedChild!.name[0].toUpperCase()
                                : 'N',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedChild?.name ?? 'Chưa có hồ sơ bé',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selectedChild?.className ??
                                  'Nhấn để thêm thông tin học tập',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.settings_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: _openChildrenManagerModal,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChildProfile {
  final String id;
  final String name;
  final String className;
  final String learningNotes;

  const _ChildProfile({
    required this.id,
    required this.name,
    required this.className,
    required this.learningNotes,
  });

  _ChildProfile copyWith({
    String? id,
    String? name,
    String? className,
    String? learningNotes,
  }) {
    return _ChildProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      className: className ?? this.className,
      learningNotes: learningNotes ?? this.learningNotes,
    );
  }
}

class _ChildrenManagerResult {
  final List<_ChildProfile> children;
  final String? selectedChildId;

  const _ChildrenManagerResult({
    required this.children,
    required this.selectedChildId,
  });
}

class _ChildrenManagerModal extends StatefulWidget {
  final List<_ChildProfile> initialChildren;
  final String? selectedChildId;

  const _ChildrenManagerModal({
    required this.initialChildren,
    required this.selectedChildId,
  });

  @override
  State<_ChildrenManagerModal> createState() => _ChildrenManagerModalState();
}

class _ChildrenManagerModalState extends State<_ChildrenManagerModal> {
  late List<_ChildProfile> _children;
  late String? _selectedChildId;

  @override
  void initState() {
    super.initState();
    _children = List<_ChildProfile>.from(widget.initialChildren);
    _selectedChildId = widget.selectedChildId;
  }

  Future<void> _openChildForm({_ChildProfile? child}) async {
    final edited = await showModalBottomSheet<_ChildProfile>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChildProfileFormModal(child: child),
    );

    if (edited == null || !mounted) {
      return;
    }

    setState(() {
      final idx = _children.indexWhere((c) => c.id == edited.id);
      if (idx >= 0) {
        _children[idx] = edited;
      } else {
        _children = [..._children, edited];
      }
      _selectedChildId = edited.id;
    });
  }

  void _deleteChild(String childId) {
    setState(() {
      _children = _children.where((c) => c.id != childId).toList(growable: false);
      if (_selectedChildId == childId) {
        _selectedChildId = _children.isEmpty ? null : _children.first.id;
      }
    });
  }

  Future<void> _confirmAndDeleteChild(_ChildProfile child) async {
    final confirmed = await showConfirmDeleteModal(
      context,
      title: 'Xoa ho so be',
      message: 'Ban co chac chan muon xoa ho so "${child.name}"?',
      confirmText: 'Xoa con',
    );

    if (!confirmed || !mounted) {
      return;
    }

    _deleteChild(child.id);
  }

  void _closeWithResult() {
    Navigator.of(context).pop(
      _ChildrenManagerResult(
        children: _children,
        selectedChildId: _selectedChildId,
      ),
    );
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Danh sách học sinh',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _closeWithResult,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_children.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Chưa có hồ sơ bé. Hãy nhấn "Thêm con" để tạo mới.',
                  style: theme.textTheme.bodyMedium,
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _children.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final child = _children[index];
                    final isSelected = child.id == _selectedChildId;
                    return Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primaryContainer.withValues(alpha: 0.35)
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary.withValues(alpha: 0.45)
                              : colorScheme.outlineVariant.withValues(alpha: 0.45),
                        ),
                      ),
                      child: ListTile(
                        onTap: () => _openChildForm(child: child),
                        title: Text(
                          child.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          child.className.isEmpty ? 'Chưa có lớp học' : child.className,
                        ),
                        trailing: TextButton.icon(
                          onPressed: () => _confirmAndDeleteChild(child),
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Xoá con'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _openChildForm(),
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Thêm con'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _closeWithResult,
                child: const Text('Xong'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChildProfileFormModal extends StatefulWidget {
  final _ChildProfile? child;

  const _ChildProfileFormModal({this.child});

  @override
  State<_ChildProfileFormModal> createState() => _ChildProfileFormModalState();
}

class _ChildProfileFormModalState extends State<_ChildProfileFormModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _classController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.child?.name ?? '');
    _classController = TextEditingController(text: widget.child?.className ?? '');
    _notesController = TextEditingController(
      text: widget.child?.learningNotes ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _classController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final id = widget.child?.id ?? 'child-${DateTime.now().millisecondsSinceEpoch}';

    Navigator.of(context).pop(
      _ChildProfile(
        id: id,
        name: _nameController.text.trim(),
        className: _classController.text.trim(),
        learningNotes: _notesController.text.trim(),
      ),
    );
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
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Thông tin học tập',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'TÊN BÉ',
                        hintText: 'Nhập tên bé',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập tên bé';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _classController,
                      decoration: const InputDecoration(
                        labelText: 'LỚP HỌC',
                        hintText: 'VD: 4A',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'ĐẶC ĐIỂM HỌC TẬP',
                  hintText: 'Nhập điểm mạnh/yếu và sở thích học tập...',
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: const Text('Lưu & Cập nhật'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Drawer item ──────────────────────────────────────────────────────────────

class _DrawerItem extends StatelessWidget {
  final DocumentItem doc;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const _DrawerItem({
    required this.doc,
    required this.onView,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            child:
                Icon(doc.icon, color: colorScheme.onSurfaceVariant, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  doc.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.visibility_outlined,
                size: 20, color: colorScheme.onSurfaceVariant),
            onPressed: onView,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline,
                size: 20, color: colorScheme.onSurfaceVariant),
            onPressed: onDelete,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }
}

// ─── Modal thêm tài liệu ─────────────────────────────────────────────────────

class _AddDocumentModal extends StatelessWidget {
  final void Function(DocumentItem doc) onSelected;

  const _AddDocumentModal({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final options = [
      _SourceOption(
        icon: Icons.picture_as_pdf_outlined,
        label: 'Tải File PDF',
        documentTitle: 'Tài liệu PDF',
        documentSubtitle: 'PDF',
        documentIcon: Icons.picture_as_pdf_outlined,
      ),
      _SourceOption(
        icon: Icons.camera_alt_outlined,
        label: 'Chụp bài tập',
        documentTitle: 'Ảnh chụp bài tập mới',
        documentSubtitle: 'Ảnh chụp',
        documentIcon: Icons.camera_alt_outlined,
      ),
      _SourceOption(
        icon: Icons.image_outlined,
        label: 'Tải Ảnh Lên',
        documentTitle: 'Ảnh tài liệu mới',
        documentSubtitle: 'Hình ảnh',
        documentIcon: Icons.image_outlined,
      ),
      _SourceOption(
        icon: Icons.storage_outlined,
        label: 'Google Drive',
        documentTitle: 'Tài liệu từ Drive',
        documentSubtitle: 'Google Drive',
        documentIcon: Icons.storage_outlined,
      ),
    ];

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
                'Thêm nguồn tài liệu học tập',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
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

          // 2x2 grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: options
                .map((opt) => _SourceTile(
                      option: opt,
                      onTap: () => onSelected(DocumentItem(
                        title: opt.documentTitle,
                        subtitle: opt.documentSubtitle,
                        icon: opt.documentIcon,
                      )),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),

          // Nhập văn bản (full width)
          _SourceTileWide(
            icon: Icons.text_fields_outlined,
            label: 'Nhập văn bản trực tiếp',
            onTap: () => onSelected(const DocumentItem(
              title: 'Văn bản trực tiếp',
              subtitle: 'Văn bản',
              icon: Icons.text_fields_outlined,
            )),
          ),
        ],
      ),
    );
  }
}

// ─── Helpers modal ────────────────────────────────────────────────────────────

class _SourceOption {
  final IconData icon;
  final String label;
  final String documentTitle;
  final String documentSubtitle;
  final IconData documentIcon;

  const _SourceOption({
    required this.icon,
    required this.label,
    required this.documentTitle,
    required this.documentSubtitle,
    required this.documentIcon,
  });
}

class _SourceTile extends StatelessWidget {
  final _SourceOption option;
  final VoidCallback onTap;

  const _SourceTile({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ESizes.radiusMd),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(ESizes.radiusMd),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(option.icon, size: 32, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 10),
            Text(
              option.label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceTileWide extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceTileWide({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ESizes.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(ESizes.radiusMd),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 10),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
