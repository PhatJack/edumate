import 'package:dio/dio.dart';
import 'package:edumate/core/exceptions/api_exception.dart';
import 'package:edumate/data/constants/api_endpoints.dart';
import 'package:edumate/data/models/chat_models.dart';
import 'package:edumate/data/models/document_models.dart';
import 'package:edumate/data/models/paginated_response.dart';
import 'package:edumate/data/models/upload_models.dart';
import 'package:edumate/data/repositories/base_repository.dart';
import 'package:edumate/data/services/api_service.dart';

class DocumentsRepository extends BaseRepository {
  const DocumentsRepository(super.apiService);

  factory DocumentsRepository.create() => DocumentsRepository(ApiService());

  Future<PaginatedResponse<Document>> listDocuments({
    String? childId,
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await apiService.get(
      ApiEndpoints.documents,
      params: {
        ...?(childId != null ? {'child_id': childId} : null),
        'limit': limit,
        'offset': offset,
      },
    );

    return parseEnvelopeData(
      response,
      (raw) => PaginatedResponse<Document>.fromJson(
        raw as Map<String, dynamic>,
        Document.fromJson,
      ),
    );
  }

  Future<Document> createDocument(DocumentCreateRequest request) async {
    final response = await apiService.post(
      ApiEndpoints.documents,
      data: request.toJson(),
    );

    return parseEnvelopeData(
      response,
      (raw) => Document.fromJson(raw as Map<String, dynamic>),
    );
  }

  Future<Document> importDrive(ImportDriveRequest request) async {
    final response = await apiService.post(
      ApiEndpoints.documentsImportDrive,
      data: request.toJson(),
    );

    return parseEnvelopeData(
      response,
      (raw) => Document.fromJson(raw as Map<String, dynamic>),
    );
  }

  Future<Document> getDocument(String documentId) async {
    final response = await apiService.get(ApiEndpoints.documentById(documentId));

    return parseEnvelopeData(
      response,
      (raw) => Document.fromJson(raw as Map<String, dynamic>),
    );
  }

  Future<Document> updateDocument(
    String documentId,
    DocumentUpdateRequest request,
  ) async {
    final response = await apiService.patch(
      ApiEndpoints.documentById(documentId),
      data: request.toJson(),
    );

    return parseEnvelopeData(
      response,
      (raw) => Document.fromJson(raw as Map<String, dynamic>),
    );
  }

  Future<void> deleteDocument(String documentId) async {
    await apiService.delete(ApiEndpoints.documentById(documentId));
  }

  Future<UploadAcceptedResponse> uploadDocumentFile(
    String documentId,
    MultipartFile file,
  ) async {
    final formData = FormData.fromMap({'file': file});
    final response = await apiService.postFormData(
      ApiEndpoints.documentUpload(documentId),
      formData,
    );

    return parseEnvelopeData(
      response,
      (raw) => UploadAcceptedResponse.fromJson(raw as Map<String, dynamic>),
    );
  }

  Future<ScanPageResponse> scanPage(
    String documentId,
    int page,
  ) async {
    final response = await apiService.post(
      ApiEndpoints.documentScanPage(documentId),
      data: {'page': page},
    );

    return parseEnvelopeData(
      response,
      (raw) => ScanPageResponse.fromJson(raw as Map<String, dynamic>),
    );
  }

  Future<List<Exercise>> listExercises(String documentId) async {
    final response = await apiService.get(ApiEndpoints.documentExercises(documentId));

    return parseEnvelopeData(
      response,
      (raw) {
        if (raw is! List) {
          throw const ApiException(message: 'Invalid exercises payload.');
        }
        return raw
            .whereType<Map<String, dynamic>>()
            .map(Exercise.fromJson)
            .toList(growable: false);
      },
    );
  }

  Future<Exercise> updateExercise(
    String documentId,
    String exerciseId,
    ExerciseUpdateRequest request,
  ) async {
    final response = await apiService.patch(
      ApiEndpoints.documentExerciseById(documentId, exerciseId),
      data: request.toJson(),
    );

    return parseEnvelopeData(
      response,
      (raw) => Exercise.fromJson(raw as Map<String, dynamic>),
    );
  }

  Future<UploadAcceptedResponse> uploadExerciseSampleSolutionImage(
    String documentId,
    String exerciseId,
    MultipartFile file,
  ) async {
    final formData = FormData.fromMap({'file': file});
    final response = await apiService.postFormData(
      ApiEndpoints.documentExerciseSampleSolutionImage(documentId, exerciseId),
      formData,
    );

    return parseEnvelopeData(
      response,
      (raw) => UploadAcceptedResponse.fromJson(raw as Map<String, dynamic>),
    );
  }

  Future<Exercise> generateSimilarExercise(
    String documentId,
    String exerciseId, {
    String? hint,
  }) async {
    final response = await apiService.post(
      ApiEndpoints.documentExerciseSimilar(documentId, exerciseId),
      data: SimilarExerciseRequest(hint: hint).toJson(),
    );

    return parseEnvelopeData(
      response,
      (raw) => Exercise.fromJson(raw as Map<String, dynamic>),
    );
  }
}
