// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ScanlatorModel {
  final String name;
  final String logoUrl;
  final String baseUrl;
  final String? searchQuery;

  ScanlatorModel({
    required this.name,
    required this.logoUrl,
    required this.baseUrl,
    required this.searchQuery,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'logoUrl': logoUrl,
      'baseUrl': baseUrl,
      'searchQuery': searchQuery,
    };
  }

  factory ScanlatorModel.fromMap(Map<String, dynamic> map) {
    return ScanlatorModel(
      name: map['name'] as String,
      logoUrl: map['logo_url'] as String,
      baseUrl: map['base_url'] as String,
      searchQuery:
          map['search_query'] != null ? map['search_query'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScanlatorModel.fromJson(String source) =>
      ScanlatorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
