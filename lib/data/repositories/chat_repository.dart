import 'package:edumate/core/exceptions/api_exception.dart';
import 'package:edumate/data/constants/api_endpoints.dart';
import 'package:edumate/data/models/chat_models.dart';
import 'package:edumate/data/repositories/base_repository.dart';
import 'package:edumate/data/services/api_service.dart';

class ChatRepository extends BaseRepository {
  const ChatRepository(super.apiService);

  factory ChatRepository.create() => ChatRepository(ApiService());

  Future<MessagesListResponse> listMessages(
    String documentId, {
    int limit = 100,
  }) async {
    final response = await apiService.get(
      ApiEndpoints.documentMessages(documentId),
      params: {'limit': limit},
    );

    return parseEnvelopeData(
      response,
      (raw) => MessagesListResponse.fromJson(raw as Map<String, dynamic>),
    );
  }

  Future<ChatResponse> sendMessage(
    String documentId, {
    required String message,
    required String exerciseId,
  }) async {
    if (exerciseId.trim().isEmpty) {
      throw const ApiException(message: 'exerciseId is required for chat.');
    }

    if (message.trim().isEmpty) {
      throw const ApiException(message: 'message cannot be empty.');
    }

    final response = await apiService.post(
      ApiEndpoints.documentChat(documentId),
      data: ChatRequest(message: message, exerciseId: exerciseId).toJson(),
    );

    return parseEnvelopeData(
      response,
      (raw) => ChatResponse.fromJson(raw as Map<String, dynamic>),
    );
  }
}
