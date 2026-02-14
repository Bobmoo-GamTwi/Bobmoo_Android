import 'package:flutter/material.dart';

class University {
  final String name;
  final String colorCode;

  University({required this.name, required this.colorCode});

  // JSON 데이터(Map)를 객체로 변환하는 생성자 (역직렬화)
  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      colorCode: json['colorCode'],
    );
  }

  // 객체를 Map으로 변환 (직렬화)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'colorCode': colorCode,
    };
  }

  Color hexToColor() {
    return Color(int.parse(colorCode.replaceFirst('#', '0xff')));
  }
}
