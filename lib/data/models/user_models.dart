class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final bool isActive;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.isActive,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      isActive: json['is_active'] == true,
      avatarUrl: json['avatar_url']?.toString(),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }
}

class UserUpdateRequest {
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;

  const UserUpdateRequest({
    this.firstName,
    this.lastName,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() => {
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      };
}

DateTime? _parseDateTime(Object? raw) {
  final text = raw?.toString();
  if (text == null || text.isEmpty) {
    return null;
  }
  return DateTime.tryParse(text);
}
