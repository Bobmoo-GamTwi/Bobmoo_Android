import 'package:flutter/material.dart';

class ErrorUiModel {
  final String description;
  final IconData icon;
  final String actionLabel;

  const ErrorUiModel({
    required this.description,
    required this.icon,
    required this.actionLabel,
  });
}

