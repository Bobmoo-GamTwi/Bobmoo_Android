// 시간 문자열 파싱 유틸리티
// 예시 입력: "08:00-09:30", "11:30~14:00", "08:00-09:00/11:30-13:30"

/// 반환: List<(DateTime start, DateTime end)>
List<(DateTime, DateTime)> parseTimeRanges({
  required String s,
  required DateTime now,
  DateTime? selectedDate,
}) {
  final parts = s.split(RegExp(r"[\/ ,;]"));
  final result = <(DateTime, DateTime)>[];
  for (final raw in parts) {
    final seg = raw.trim();
    if (seg.isEmpty) continue;

    final split = seg.split(RegExp(r"\s*[-–~]\s*"));
    if (split.length != 2) continue;

    final startStr = split[0].trim();
    final endStr = split[1].trim();

    final start = parseTodayTime(
      hhmm: startStr,
      now: now,
      selectedDate: selectedDate,
    );
    final end = parseTodayTime(
      hhmm: endStr,
      now: now,
      selectedDate: selectedDate,
    );
    if (start == null || end == null) continue;
    if (!end.isAfter(start)) continue;

    result.add((start, end));
  }
  return result;
}

DateTime? parseTodayTime({
  required String hhmm,
  required DateTime now,
  DateTime? selectedDate,
}) {
  final m = RegExp(r"^(\d{1,2})(?::?(\d{2}))?").firstMatch(hhmm.trim());
  if (m == null) return null;
  final h = int.tryParse(m.group(1) ?? '0');
  final min = int.tryParse(m.group(2) ?? '0');
  if (h == null || min == null) return null;
  if (h < 0 || h > 23 || min < 0 || min > 59) return null;
  if (selectedDate != null) {
    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      h,
      min,
    );
  }
  return DateTime(now.year, now.month, now.day, h, min);
}
