import 'package:flutter/material.dart';

/// AppBar dùng chung cho toàn bộ ứng dụng (trừ Login và Register).
///
/// Cách dùng:
/// ```dart
/// Scaffold(
///   appBar: EAppBar(title: 'Tiêu đề'),
///   body: ...
/// )
/// ```
///
/// Các tham số tuỳ chọn:
/// - [title]         : Chuỗi tiêu đề hiển thị ở giữa/bên trái AppBar
/// - [showMenuIcon]  : Hiện icon menu hamburger để mở Drawer (mặc định: false)
/// - [showBackIcon]  : Hiện nút back (mặc định: tự động dựa vào Navigator stack)
/// - [actions]       : Các widget bổ sung ở bên phải
/// - [bottom]        : PreferredSizeWidget hiển thị bên dưới AppBar (vd: TabBar)
class EAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showMenuIcon;
  final bool? showBackIcon;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onPlayPressed;

  const EAppBar({
    super.key,
    this.title,
    this.showMenuIcon = false,
    this.showBackIcon,
    this.actions,
    this.bottom,
    this.onPlayPressed,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0) + 0.5);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Nút action bên phải mặc định: vòng tròn với icon play
    final defaultAction = Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(Icons.play_circle_outline, color: colorScheme.primary),
          onPressed: onPlayPressed ?? () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tour hien tai chua duoc cai dat o man hinh nay.'),
              ),
            );
          },
          iconSize: 22,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
    );

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      // Leading: menu hoặc back tự động
      leading: showMenuIcon
          ? Builder(
              builder: (ctx) => IconButton(
                icon: Icon(Icons.menu, color: colorScheme.onSurfaceVariant),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            )
          : (showBackIcon == false
              ? null
              : (Navigator.of(context).canPop()
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : null)),
      title: title != null
          ? Text(
              title!,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            )
          : null,
      actions: actions ?? [defaultAction],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight((bottom?.preferredSize.height ?? 0) + 0.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...?bottom == null ? null : [bottom!],
            Container(color: colorScheme.outlineVariant.withValues(alpha: 0.5), height: 0.5),
          ],
        ),
      ),
    );
  }
}
