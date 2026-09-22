import 'package:bobmoo/utils/app_logger.dart';
import 'package:flutter/material.dart';

class University {
  final int schoolId;
  final String schoolName;
  final String schoolNameK;
  final String schoolColor;

  University({
    required this.schoolId,
    required this.schoolName,
    required this.schoolNameK,
    required this.schoolColor,
  });

  // JSON 데이터(Map)를 객체로 변환하는 생성자 (역직렬화)
  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      schoolId: json['schoolId'] as int,
      schoolName: json['schoolName'] as String,
      schoolNameK: json['schoolNameK'] as String,
      schoolColor: json['schoolColor'] as String,
    );
  }

  static University? tryFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    try {
      return University.fromJson(json);
    } catch (e, stackTrace) {
      AppLogger.e(
        "University 객체 Json으로부터 파싱 실패",
        error: e,
        stackTrace: stackTrace,
        tag: "University",
      );
      return null;
    }
  }

  // 객체를 Map으로 변환 (직렬화)
  Map<String, dynamic> toJson() {
    return {
      'schoolId': schoolId,
      'schoolName': schoolName,
      'schoolNameK': schoolNameK,
      'schoolColor': schoolColor,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is University && other.schoolId == schoolId;

  @override
  int get hashCode => schoolId.hashCode;

  Color hexToColor() {
    return Color(int.parse('0xff$schoolColor'));
  }
}
