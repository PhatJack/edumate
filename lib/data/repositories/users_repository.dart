import 'package:edumate/data/constants/api_endpoints.dart';
import 'package:edumate/data/models/paginated_response.dart';
import 'package:edumate/data/models/user_models.dart';
import 'package:edumate/data/repositories/base_repository.dart';
import 'package:edumate/data/services/api_service.dart';

class UsersRepository extends BaseRepository {
  const UsersRepository(super.apiService);

  factory UsersRepository.create() => UsersRepository(ApiService());

  Future<PaginatedResponse<User>> listUsers({
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await apiService.get(
      ApiEndpoints.users,
      params: {
        'limit': limit,
        'offset': offset,
      },
    );

    return parseEnvelopeData(
      response,
      (raw) => PaginatedResponse<User>.fromJson(
        raw as Map<String, dynamic>,
        User.fromJson,
      ),
    );
  }

  Future<User> getUserById(String userId) async {
    final response = await apiService.get(ApiEndpoints.userById(userId));

    return parseEnvelopeData(
      response,
      (raw) => User.fromJson(raw as Map<String, dynamic>),
    );
  }

  Future<User> updateUserById(
    String userId,
    UserUpdateRequest request,
  ) async {
    final response = await apiService.patch(
      ApiEndpoints.userById(userId),
      data: request.toJson(),
    );

    return parseEnvelopeData(
      response,
      (raw) => User.fromJson(raw as Map<String, dynamic>),
    );
  }
}
