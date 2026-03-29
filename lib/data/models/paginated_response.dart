class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int limit;
  final int offset;
  final bool hasNext;

  const PaginatedResponse({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
    required this.hasNext,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    final rawItems = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList();

    return PaginatedResponse<T>(
      items: rawItems.map(itemFromJson).toList(growable: false),
      total: (json['total'] as num? ?? 0).toInt(),
      limit: (json['limit'] as num? ?? 0).toInt(),
      offset: (json['offset'] as num? ?? 0).toInt(),
      hasNext: json['has_next'] == true,
    );
  }
}
