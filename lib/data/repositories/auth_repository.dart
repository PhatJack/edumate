import 'package:edumate/data/constants/api_endpoints.dart';
import 'package:edumate/data/models/auth_models.dart';
import 'package:edumate/data/repositories/base_repository.dart';
import 'package:edumate/data/services/api_service.dart';

class AuthRepository extends BaseRepository {
  const AuthRepository(super.apiService);

  factory AuthRepository.create() => AuthRepository(ApiService());

  Future<TokenResponse> signInWithGoogle(String idToken) async {
    final response = await apiService.post(
      ApiEndpoints.authGoogle,
      data: GoogleAuthRequest(idToken: idToken).toJson(),
    );

    return parseEnvelopeData(
      response,
      (raw) => TokenResponse.fromJson(raw as Map<String, dynamic>),
    );
  }

  Future<AuthUser> getCurrentUser() async {
    final response = await apiService.get(ApiEndpoints.authMe);
    return parseEnvelopeData(
      response,
      (raw) => AuthUser.fromJson(raw as Map<String, dynamic>),
    );
  }
}
