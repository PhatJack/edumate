class GoogleAuthRequest {
  final String idToken;

  const GoogleAuthRequest({required this.idToken});

  Map<String, dynamic> toJson() => {
        'id_token': idToken,
      };
}

class TokenResponse {
  final String accessToken;
  final String tokenType;

  const TokenResponse({
    required this.accessToken,
    required this.tokenType,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json['access_token']?.toString() ?? '',
      tokenType: json['token_type']?.toString() ?? 'bearer',
    );
  }
}

class AuthUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isActive;
  final String? avatarUrl;

  const AuthUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    this.avatarUrl,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      isActive: json['is_active'] == true,
      avatarUrl: json['avatar_url']?.toString(),
    );
  }
}
