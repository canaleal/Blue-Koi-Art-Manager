import 'dart:convert';

class Search {
  final String searchTopic;
  final int count;
  final String searchType;

  const Search({
    required this.searchTopic,
    required this.count,
    required this.searchType,
  });

  Search copyWith({
    String? searchTopic,
    int? count,
    String? searchType,
  }) {
    return Search(
      searchTopic: searchTopic ?? this.searchTopic,
      count: count ?? this.count,
      searchType: searchType ?? this.searchType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'searchTopic': searchTopic,
      'count': count,
      'searchType': searchType,
    };
  }

  factory Search.fromMap(Map<String, dynamic> map) {
    return Search(
      searchTopic: map['searchTopic'] ?? '',
      count: map['count']?.toInt() ?? 0,
      searchType: map['searchType'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Search.fromJson(String source) => Search.fromMap(json.decode(source));

  @override
  String toString() => 'Search(searchTopic: $searchTopic, count: $count, searchType: $searchType)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Search &&
      other.searchTopic == searchTopic &&
      other.count == count &&
      other.searchType == searchType;
  }

  @override
  int get hashCode => searchTopic.hashCode ^ count.hashCode ^ searchType.hashCode;
}
