import 'package:edumate/core/providers/documents_provider.dart';
import 'package:edumate/data/models/document_models.dart';
import 'package:edumate/data/repositories/documents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final documentsRepositoryProvider = Provider<DocumentsRepository>(
  (ref) => DocumentsRepository.create(),
);

final documentsListProvider =
    StateNotifierProvider<DocumentsListNotifier, DocumentsListState>(
  (ref) => DocumentsListNotifier(ref.read(documentsRepositoryProvider)),
);

class DocumentsListState {
  final List<DocumentItem> items;
  final bool isLoading;
  final bool isDeleting;
  final String? error;
  final String? childId;

  const DocumentsListState({
    required this.items,
    required this.isLoading,
    required this.isDeleting,
    required this.error,
    required this.childId,
  });

  const DocumentsListState.initial()
      : items = const [],
        isLoading = false,
        isDeleting = false,
        error = null,
        childId = null;

  DocumentsListState copyWith({
    List<DocumentItem>? items,
    bool? isLoading,
    bool? isDeleting,
    String? error,
    bool clearError = false,
    String? childId,
  }) {
    return DocumentsListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isDeleting: isDeleting ?? this.isDeleting,
      error: clearError ? null : (error ?? this.error),
      childId: childId ?? this.childId,
    );
  }
}

class DocumentsListNotifier extends StateNotifier<DocumentsListState> {
  final DocumentsRepository _repository;

  DocumentsListNotifier(this._repository) : super(const DocumentsListState.initial());

  Future<void> loadDocuments({
    String? childId,
    bool force = false,
  }) async {
    if (!force && state.isLoading) {
      return;
    }

    if (!force && state.childId == childId && state.items.isNotEmpty) {
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true, childId: childId);

    try {
      final response = await _repository.listDocuments(
        childId: childId,
        limit: 100,
        offset: 0,
      );

      final items = response.items.map(_toDocumentItem).toList(growable: false);
      state = state.copyWith(
        isLoading: false,
        items: items,
        childId: childId,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        childId: childId,
      );
    }
  }

  Future<bool> deleteDocument(String documentId) async {
    if (documentId.trim().isEmpty) {
      return false;
    }

    state = state.copyWith(isDeleting: true, clearError: true);
    try {
      await _repository.deleteDocument(documentId);
      state = state.copyWith(
        isDeleting: false,
        items: state.items.where((doc) => doc.id != documentId).toList(growable: false),
      );
      return true;
    } catch (e) {
      state = state.copyWith(isDeleting: false, error: e.toString());
      return false;
    }
  }

  void upsert(Document document) {
    final mapped = _toDocumentItem(document);
    final index = state.items.indexWhere((doc) => doc.id == mapped.id);
    final updated = List<DocumentItem>.from(state.items);
    if (index >= 0) {
      updated[index] = mapped;
    } else {
      updated.insert(0, mapped);
    }
    state = state.copyWith(items: updated, clearError: true);
  }

  DocumentItem _toDocumentItem(Document doc) {
    final icon = switch (doc.kind) {
      'pdf' => Icons.picture_as_pdf_outlined,
      'camera' => Icons.camera_alt_outlined,
      'image' => Icons.image_outlined,
      'drive' => Icons.storage_outlined,
      _ => Icons.description_outlined,
    };

    final subtitle = switch (doc.kind) {
      'pdf' => 'PDF',
      'camera' => 'Ảnh chụp',
      'image' => 'Hình ảnh',
      'drive' => 'Google Drive',
      _ => doc.kind,
    };

    return DocumentItem(
      id: doc.id,
      title: doc.title.isEmpty ? 'Tài liệu mới' : doc.title,
      subtitle: subtitle,
      icon: icon,
      kind: doc.kind,
    );
  }
}
