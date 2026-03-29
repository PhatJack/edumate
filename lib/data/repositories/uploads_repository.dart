import 'package:dio/dio.dart';
import 'package:edumate/data/constants/api_endpoints.dart';
import 'package:edumate/data/models/upload_models.dart';
import 'package:edumate/data/repositories/base_repository.dart';
import 'package:edumate/data/services/api_service.dart';

class UploadsRepository extends BaseRepository {
  const UploadsRepository(super.apiService);

  factory UploadsRepository.create() => UploadsRepository(ApiService());

  Future<UploadAcceptedResponse> uploadGlobalFile(MultipartFile file) async {
    final formData = FormData.fromMap({'file': file});
    final response = await apiService.postFormData(ApiEndpoints.uploads, formData);

    return parseEnvelopeData(
      response,
      (raw) => UploadAcceptedResponse.fromJson(raw as Map<String, dynamic>),
    );
  }
}
