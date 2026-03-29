class ChatRequest {
  final String message;
  final String exerciseId;

  const ChatRequest({
    required this.message,
    required this.exerciseId,
  });

  Map<String, dynamic> toJson() => {
        'message': message,
        'exercise_id': exerciseId,
      };
}

class ChatMessage {
  final String id;
  final String role;
  final String content;
  final String messageType;
  final Map<String, dynamic>? meta;
  final String? exerciseId;
  final DateTime? createdAt;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.messageType,
    this.meta,
    this.exerciseId,
    this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      messageType: json['message_type']?.toString() ?? 'text',
      meta: (json['meta'] as Map?)?.cast<String, dynamic>(),
      exerciseId: json['exercise_id']?.toString(),
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  List<String> get welcomeExerciseIds {
    if (messageType != 'welcome') {
      return const <String>[];
    }
    final rawIds = meta?['exercise_ids'];
    if (rawIds is! List) {
      return const <String>[];
    }
    return rawIds.map((e) => e.toString()).toList(growable: false);
  }
}

class ChatResponse {
  final String reply;
  final List<ChatMessage> messages;
  final bool mock;

  const ChatResponse({
    required this.reply,
    required this.messages,
    required this.mock,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    final rawMessages = (json['messages'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return ChatResponse(
      reply: json['reply']?.toString() ?? '',
      messages: rawMessages.map(ChatMessage.fromJson).toList(growable: false),
      mock: json['mock'] == true,
    );
  }
}

class MessagesListResponse {
  final List<ChatMessage> items;
  final int limit;
  final int total;
  final bool hasNext;

  const MessagesListResponse({
    required this.items,
    required this.limit,
    required this.total,
    required this.hasNext,
  });

  factory MessagesListResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return MessagesListResponse(
      items: rawItems.map(ChatMessage.fromJson).toList(growable: false),
      limit: (json['limit'] as num? ?? 0).toInt(),
      total: (json['total'] as num? ?? 0).toInt(),
      hasNext: json['has_next'] == true,
    );
  }
}

class SimilarExerciseRequest {
  final String? hint;

  const SimilarExerciseRequest({this.hint});

  Map<String, dynamic> toJson() => {
        if (hint != null && hint!.trim().isNotEmpty) 'hint': hint,
      };
}

DateTime? _parseDateTime(Object? raw) {
  final text = raw?.toString();
  if (text == null || text.isEmpty) {
    return null;
  }
  return DateTime.tryParse(text);
}
