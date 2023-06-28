// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ScanlatorModel {
  final String name;
  final String logoUrl;

  ScanlatorModel({
    required this.name,
    required this.logoUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'logoUrl': logoUrl,
    };
  }

  factory ScanlatorModel.fromMap(Map<String, dynamic> map) {
    return ScanlatorModel(
      name: map['name'] as String,
      logoUrl: map['logo_url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScanlatorModel.fromJson(String source) =>
      ScanlatorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
