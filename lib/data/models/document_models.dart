class Document {
  final String id;
  final String title;
  final String kind;
  final bool isLargeDocument;
  final String? childId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? storageObjectPath;
  final String? originalFilename;
  final String? fileContentType;
  final int? fileSizeBytes;
  final String? downloadUrl;

  const Document({
    required this.id,
    required this.title,
    required this.kind,
    required this.isLargeDocument,
    this.childId,
    this.createdAt,
    this.updatedAt,
    this.storageObjectPath,
    this.originalFilename,
    this.fileContentType,
    this.fileSizeBytes,
    this.downloadUrl,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      kind: json['kind']?.toString() ?? '',
      isLargeDocument: json['is_large_document'] == true,
      childId: json['child_id']?.toString(),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      storageObjectPath: json['storage_object_path']?.toString(),
      originalFilename: json['original_filename']?.toString(),
      fileContentType: json['file_content_type']?.toString(),
      fileSizeBytes: (json['file_size_bytes'] as num?)?.toInt(),
      downloadUrl: json['download_url']?.toString(),
    );
  }
}

class DocumentCreateRequest {
  final String kind;
  final String? title;
  final String? childId;

  const DocumentCreateRequest({
    required this.kind,
    this.title,
    this.childId,
  });

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      if (title != null) 'title': title,
      if (childId != null) 'child_id': childId,
    };
  }
}

class DocumentUpdateRequest {
  final String? title;
  final String? childId;

  const DocumentUpdateRequest({
    this.title,
    this.childId,
  });

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (childId != null) 'child_id': childId,
    };
  }
}

class ImportDriveRequest {
  final String fileId;
  final String accessToken;
  final String? title;
  final String? childId;

  const ImportDriveRequest({
    required this.fileId,
    required this.accessToken,
    this.title,
    this.childId,
  });

  Map<String, dynamic> toJson() {
    return {
      'file_id': fileId,
      'access_token': accessToken,
      if (title != null) 'title': title,
      if (childId != null) 'child_id': childId,
    };
  }
}

class Exercise {
  final String id;
  final String title;
  final String? detail;
  final int order;
  final String? sampleSolution;
  final String? sampleSolutionImageFilename;
  final String? sampleSolutionImageUrl;

  const Exercise({
    required this.id,
    required this.title,
    required this.order,
    this.detail,
    this.sampleSolution,
    this.sampleSolutionImageFilename,
    this.sampleSolutionImageUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      detail: json['detail']?.toString(),
      order: (json['order'] as num? ?? 0).toInt(),
      sampleSolution: json['sample_solution']?.toString(),
      sampleSolutionImageFilename: json['sample_solution_image_filename']?.toString(),
      sampleSolutionImageUrl: json['sample_solution_image_url']?.toString(),
    );
  }
}

class ExerciseUpdateRequest {
  final String? title;
  final String? detail;
  final int? order;
  final String? sampleSolution;
  final bool? clearSampleSolutionImage;

  const ExerciseUpdateRequest({
    this.title,
    this.detail,
    this.order,
    this.sampleSolution,
    this.clearSampleSolutionImage,
  });

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (detail != null) 'detail': detail,
      if (order != null) 'order': order,
      if (sampleSolution != null) 'sample_solution': sampleSolution,
      if (clearSampleSolutionImage != null)
        'clear_sample_solution_image': clearSampleSolutionImage,
    };
  }
}

class ScanPageResponse {
  final List<Exercise> exercises;
  final bool mock;

  const ScanPageResponse({
    required this.exercises,
    required this.mock,
  });

  factory ScanPageResponse.fromJson(Map<String, dynamic> json) {
    final rawExercises = (json['exercises'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return ScanPageResponse(
      exercises: rawExercises.map(Exercise.fromJson).toList(growable: false),
      mock: json['mock'] == true,
    );
  }
}

DateTime? _parseDateTime(Object? raw) {
  final text = raw?.toString();
  if (text == null || text.isEmpty) {
    return null;
  }
  return DateTime.tryParse(text);
}
