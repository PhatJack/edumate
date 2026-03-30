import 'package:flutter/material.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

class DocumentItem {
  final String? id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String? kind;

  const DocumentItem({
    this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.kind,
  });
}

// ─── InheritedNotifier — đặt ở root app để mọi màn hình đều truy cập được ───

class DocumentsProvider
    extends InheritedNotifier<ValueNotifier<List<DocumentItem>>> {
  const DocumentsProvider({
    super.key,
    required ValueNotifier<List<DocumentItem>> notifier,
    required super.child,
  }) : super(notifier: notifier);

  /// Lấy notifier từ bất kỳ đâu trong widget tree
  static ValueNotifier<List<DocumentItem>> of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<DocumentsProvider>();
    assert(provider != null,
        'DocumentsProvider not found. Wrap MaterialApp with DocumentsProvider.');
    return provider!.notifier!;
  }

  /// Thêm tài liệu mới
  static void add(BuildContext context, DocumentItem doc) {
    final notifier = of(context);
    notifier.value = [...notifier.value, doc];
  }

  /// Xoá tài liệu theo index
  static void removeAt(BuildContext context, int index) {
    final notifier = of(context);
    final list = [...notifier.value];
    list.removeAt(index);
    notifier.value = list;
  }
}
