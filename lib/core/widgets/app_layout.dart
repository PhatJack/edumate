import 'package:edumate/core/constants/sizes.dart';
import 'package:edumate/core/providers/documents_provider.dart';
import 'package:edumate/core/widgets/app_header.dart';
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

  const EAppLayout({
    super.key,
    required this.body,
    this.title,
    this.actions,
  });

  // ── Modal thêm tài liệu ──────────────────────────────────────────────────
  void _showAddModal(BuildContext context) {
    showModalBottomSheet(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: EAppBar(title: title, showMenuIcon: true, actions: actions),
      drawer: _AppDrawer(onAddDocument: () => _showAddModal(context)),
      body: body,
    );
  }
}

// ─── Drawer ───────────────────────────────────────────────────────────────────

class _AppDrawer extends StatelessWidget {
  final VoidCallback onAddDocument;

  const _AppDrawer({required this.onAddDocument});

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
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context); // đóng drawer trước
                  onAddDocument();
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
              ),
            ),

            // ── Tiêu đề danh sách ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
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
                      onDelete: () => DocumentsProvider.removeAt(context, index),
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
                          'N',
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
                            'Bé Moon',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Lớp 4A',
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
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
