import 'dart:convert';
import 'dart:io';

void main() {
  final root = Directory.current.path;
  final sourceFile = File('$root/tokens/typography.json');
  if (!sourceFile.existsSync()) {
    stderr.writeln('Missing source: tokens/typography.json');
    exitCode = 1;
    return;
  }

  final decoded =
      jsonDecode(sourceFile.readAsStringSync()) as Map<String, dynamic>;
  final rawTokens = decoded['tokens'] as Map<String, dynamic>;

  final tokens = rawTokens.entries.map((entry) {
    final value = entry.value as Map<String, dynamic>;
    return _Token(
      key: entry.key,
      fontSize: (value['fontSize'] as num).toDouble(),
      letterSpacingPercent: (value['letterSpacingPercent'] as num).toDouble(),
      fontWeight: (value['fontWeight'] as num).toInt(),
    );
  }).toList()..sort((a, b) => a.key.compareTo(b.key));

  _writeDartFile('$root/lib/ui/theme/app_typography_tokens.g.dart', tokens);
  _writeKotlinFile(
    '$root/android/app/src/main/kotlin/com/hwoo/bobmoo/widget/theme/TypographyTokens.kt',
    tokens,
  );

  stdout.writeln('Generated typography tokens for Flutter and Kotlin.');
}

void _writeDartFile(String path, List<_Token> tokens) {
  final file = File(path);
  file.parent.createSync(recursive: true);
  final buffer = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln('// Source: tokens/typography.json')
    ..writeln()
    ..writeln("import 'package:flutter/widgets.dart';")
    ..writeln()
    ..writeln('class AppTypographyToken {')
    ..writeln('  const AppTypographyToken({')
    ..writeln('    required this.fontSize,')
    ..writeln('    required this.letterSpacingPercent,')
    ..writeln('    required this.fontWeight,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  final double fontSize;')
    ..writeln('  final double letterSpacingPercent;')
    ..writeln('  final FontWeight fontWeight;')
    ..writeln('}')
    ..writeln()
    ..writeln('const Map<String, AppTypographyToken> kAppTypographyTokens = {');

  for (final token in tokens) {
    buffer
      ..writeln("  '${token.key}': AppTypographyToken(")
      ..writeln('    fontSize: ${_formatDouble(token.fontSize)},')
      ..writeln(
        '    letterSpacingPercent: ${_formatDouble(token.letterSpacingPercent)},',
      )
      ..writeln('    fontWeight: ${_flutterFontWeight(token.fontWeight)},')
      ..writeln('  ),');
  }

  buffer
    ..writeln('};')
    ..writeln();

  file.writeAsStringSync(buffer.toString());
}

void _writeKotlinFile(String path, List<_Token> tokens) {
  final file = File(path);
  file.parent.createSync(recursive: true);
  final buffer = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln('// Source: tokens/typography.json')
    ..writeln()
    ..writeln('package com.hwoo.bobmoo.widget.theme')
    ..writeln()
    ..writeln('import androidx.compose.ui.unit.sp')
    ..writeln('import androidx.glance.unit.ColorProvider')
    ..writeln('import androidx.glance.text.FontWeight')
    ..writeln('import androidx.glance.text.TextStyle')
    ..writeln()
    ..writeln('data class TypographyToken(')
    ..writeln('    val fontSizeSp: Float,')
    ..writeln('    val letterSpacingPercent: Float,')
    ..writeln('    val fontWeight: FontWeight')
    ..writeln(')')
    ..writeln()
    ..writeln('object TypographyTokens {')
    ..writeln('    private val tokens = mapOf(');

  for (final token in tokens) {
    buffer.writeln(
      '        "${token.key}" to TypographyToken('
      '${_formatDouble(token.fontSize)}f, '
      '${_formatDouble(token.letterSpacingPercent)}f, '
      '${_kotlinFontWeight(token.fontWeight)}'
      '),',
    );
  }

  buffer
    ..writeln('    )')
    ..writeln()
    ..writeln('    private fun token(key: String): TypographyToken {')
    ..writeln('        return requireNotNull(tokens[key]) {')
    ..writeln('            "Unknown typography token: \$key"')
    ..writeln('        }')
    ..writeln('    }')
    ..writeln()
    ..writeln('    fun textStyle(key: String): TextStyle {')
    ..writeln('        val token = token(key)')
    ..writeln('        return TextStyle(')
    ..writeln('            fontSize = token.fontSizeSp.sp,')
    ..writeln('            fontWeight = token.fontWeight')
    ..writeln('        )')
    ..writeln('    }')
    ..writeln()
    ..writeln('    fun textStyle(key: String, color: ColorProvider): TextStyle {')
    ..writeln('        val token = token(key)')
    ..writeln('        return TextStyle(')
    ..writeln('            fontSize = token.fontSizeSp.sp,')
    ..writeln('            fontWeight = token.fontWeight,')
    ..writeln('            color = color')
    ..writeln('        )')
    ..writeln('    }')
    ..writeln('}')
    ..writeln();

  file.writeAsStringSync(buffer.toString());
}

String _flutterFontWeight(int weight) {
  return switch (weight) {
    400 => 'FontWeight.w400',
    500 => 'FontWeight.w500',
    600 => 'FontWeight.w600',
    700 => 'FontWeight.w700',
    _ => throw ArgumentError('Unsupported fontWeight: $weight'),
  };
}

String _kotlinFontWeight(int weight) {
  return switch (weight) {
    400 => 'FontWeight.Normal',
    500 => 'FontWeight.Medium',
    600 => 'FontWeight.Bold',
    700 => 'FontWeight.Bold',
    _ => throw ArgumentError('Unsupported fontWeight: $weight'),
  };
}

String _formatDouble(double value) {
  return value == value.toInt().toDouble()
      ? value.toInt().toString()
      : value.toString();
}

class _Token {
  _Token({
    required this.key,
    required this.fontSize,
    required this.letterSpacingPercent,
    required this.fontWeight,
  });

  final String key;
  final double fontSize;
  final double letterSpacingPercent;
  final int fontWeight;
}
