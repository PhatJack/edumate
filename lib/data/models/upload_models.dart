class UploadAcceptedResponse {
  final String uploadId;
  final String status;
  final String message;
  final String backend;
  final String? storageObjectPath;
  final String? downloadUrl;
  final String? contentType;
  final int? sizeBytes;

  const UploadAcceptedResponse({
    required this.uploadId,
    required this.status,
    required this.message,
    required this.backend,
    this.storageObjectPath,
    this.downloadUrl,
    this.contentType,
    this.sizeBytes,
  });

  factory UploadAcceptedResponse.fromJson(Map<String, dynamic> json) {
    return UploadAcceptedResponse(
      uploadId: json['upload_id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'accepted',
      message: json['message']?.toString() ?? '',
      backend: json['backend']?.toString() ?? 'stub',
      storageObjectPath: json['storage_object_path']?.toString(),
      downloadUrl: json['download_url']?.toString(),
      contentType: json['content_type']?.toString(),
      sizeBytes: (json['size_bytes'] as num?)?.toInt(),
    );
  }
}
