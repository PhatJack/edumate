import 'package:edumate/data/constants/api_endpoints.dart';
import 'package:edumate/data/models/paginated_response.dart';
import 'package:edumate/data/models/profile_models.dart';
import 'package:edumate/data/repositories/base_repository.dart';
import 'package:edumate/data/services/api_service.dart';

class ProfileRepository extends BaseRepository {
  const ProfileRepository(super.apiService);

  factory ProfileRepository.create() => ProfileRepository(ApiService());

  Future<Profile> getMyProfile() async {
    final response = await apiService.get(ApiEndpoints.profileMe);
    return parseEnvelopeData(
      response,
      (raw) => Profile.fromJson(raw as Map<String, dynamic>),
    );
  }

  Future<Profile> updateMyProfile({
    String? firstName,
    String? lastName,
    String? avatarUrl,
  }) async {
    final response = await apiService.patch(
      ApiEndpoints.profileMe,
      data: {
        ...?(firstName != null ? {'first_name': firstName} : null),
        ...?(lastName != null ? {'last_name': lastName} : null),
        ...?(avatarUrl != null ? {'avatar_url': avatarUrl} : null),
      },
    );

    return parseEnvelopeData(
      response,
      (raw) => Profile.fromJson(raw as Map<String, dynamic>),
    );
  }

  Future<PaginatedResponse<Child>> listChildren({
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await apiService.get(
      ApiEndpoints.profileChildren,
      params: {
        'limit': limit,
        'offset': offset,
      },
    );

    return parseEnvelopeData(
      response,
      (raw) => PaginatedResponse<Child>.fromJson(
        raw as Map<String, dynamic>,
        Child.fromJson,
      ),
    );
  }

  Future<Child> createChild(ChildMutationRequest request) async {
    final response = await apiService.post(
      ApiEndpoints.profileChildren,
      data: request.toJson(),
    );

    return parseEnvelopeData(
      response,
      (raw) => Child.fromJson(raw as Map<String, dynamic>),
    );
  }

  Future<Child> updateChild(
    String childId,
    ChildMutationRequest request,
  ) async {
    final response = await apiService.patch(
      ApiEndpoints.profileChildById(childId),
      data: request.toJson(),
    );

    return parseEnvelopeData(
      response,
      (raw) => Child.fromJson(raw as Map<String, dynamic>),
    );
  }

  Future<void> deleteChild(String childId) async {
    await apiService.delete(ApiEndpoints.profileChildById(childId));
  }
}
