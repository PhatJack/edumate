enum HttpMethod { get, post, patch, delete }

class ApiEndpointSpec {
  final String domain;
  final String name;
  final HttpMethod method;
  final String pathTemplate;
  final bool requiresAuth;
  final bool isMultipart;
  final bool isPaginated;
  final bool isMockOrStub;

  const ApiEndpointSpec({
    required this.domain,
    required this.name,
    required this.method,
    required this.pathTemplate,
    required this.requiresAuth,
    this.isMultipart = false,
    this.isPaginated = false,
    this.isMockOrStub = false,
  });
}

abstract final class ApiEndpoints {
  static const String basePrefix = '/api/v1';

  static const String authGoogle = '$basePrefix/auth/google';
  static const String authMe = '$basePrefix/auth/me';

  static const String users = '$basePrefix/users';
  static String userById(String userId) => '$users/$userId';

  static const String profileMe = '$basePrefix/profile/me';
  static const String profileChildren = '$profileMe/children';
  static String profileChildById(String childId) => '$profileChildren/$childId';

  static const String documents = '$basePrefix/documents';
  static const String documentsImportDrive = '$documents/import-drive';
  static String documentById(String documentId) => '$documents/$documentId';
  static String documentUpload(String documentId) => '${documentById(documentId)}/upload';
  static String documentScanPage(String documentId) =>
      '${documentById(documentId)}/scan-page';
  static String documentExercises(String documentId) =>
      '${documentById(documentId)}/exercises';
  static String documentExerciseById(String documentId, String exerciseId) =>
      '${documentExercises(documentId)}/$exerciseId';
  static String documentExerciseSampleSolutionImage(
    String documentId,
    String exerciseId,
  ) => '${documentExerciseById(documentId, exerciseId)}/sample-solution-image';
  static String documentExerciseSimilar(String documentId, String exerciseId) =>
      '${documentExerciseById(documentId, exerciseId)}/similar';
  static String documentMessages(String documentId) =>
      '${documentById(documentId)}/messages';
  static String documentChat(String documentId) => '${documentById(documentId)}/chat';

  static const String uploads = '$basePrefix/uploads';

  static const List<ApiEndpointSpec> catalog = [
    ApiEndpointSpec(
      domain: 'auth',
      name: 'googleSignIn',
      method: HttpMethod.post,
      pathTemplate: '/api/v1/auth/google',
      requiresAuth: false,
    ),
    ApiEndpointSpec(
      domain: 'auth',
      name: 'me',
      method: HttpMethod.get,
      pathTemplate: '/api/v1/auth/me',
      requiresAuth: true,
    ),
    ApiEndpointSpec(
      domain: 'profile',
      name: 'profileMe',
      method: HttpMethod.get,
      pathTemplate: '/api/v1/profile/me',
      requiresAuth: true,
    ),
    ApiEndpointSpec(
      domain: 'profile',
      name: 'childrenList',
      method: HttpMethod.get,
      pathTemplate: '/api/v1/profile/me/children',
      requiresAuth: true,
      isPaginated: true,
    ),
    ApiEndpointSpec(
      domain: 'documents',
      name: 'documentsList',
      method: HttpMethod.get,
      pathTemplate: '/api/v1/documents',
      requiresAuth: true,
      isPaginated: true,
    ),
    ApiEndpointSpec(
      domain: 'documents',
      name: 'importDrive',
      method: HttpMethod.post,
      pathTemplate: '/api/v1/documents/import-drive',
      requiresAuth: true,
      isMockOrStub: true,
    ),
    ApiEndpointSpec(
      domain: 'chat',
      name: 'chatSend',
      method: HttpMethod.post,
      pathTemplate: '/api/v1/documents/{document_id}/chat',
      requiresAuth: true,
      isMockOrStub: true,
    ),
    ApiEndpointSpec(
      domain: 'uploads',
      name: 'globalUpload',
      method: HttpMethod.post,
      pathTemplate: '/api/v1/uploads',
      requiresAuth: true,
      isMultipart: true,
      isMockOrStub: true,
    ),
  ];
}
