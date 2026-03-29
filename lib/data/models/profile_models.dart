class Child {
  final String id;
  final String name;
  final String? className;
  final String? learningNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Child({
    required this.id,
    required this.name,
    this.className,
    this.learningNotes,
    this.createdAt,
    this.updatedAt,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      className: json['class']?.toString(),
      learningNotes: json['learning_notes']?.toString(),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }
}

class ChildMutationRequest {
  final String? name;
  final String? className;
  final String? learningNotes;

  const ChildMutationRequest({
    this.name,
    this.className,
    this.learningNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (className != null) 'class': className,
      if (learningNotes != null) 'learning_notes': learningNotes,
    };
  }
}

class Profile {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final bool isActive;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Child> children;

  const Profile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.isActive,
    required this.children,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    final rawChildren = (json['children'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return Profile(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      isActive: json['is_active'] == true,
      avatarUrl: json['avatar_url']?.toString(),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      children: rawChildren.map(Child.fromJson).toList(growable: false),
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
