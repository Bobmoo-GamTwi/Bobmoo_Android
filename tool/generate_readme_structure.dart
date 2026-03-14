import 'dart:io';

const _startMarker = '<!-- GENERATED:LIB_TREE:START -->';
const _endMarker = '<!-- GENERATED:LIB_TREE:END -->';
const _commentColumn = 48;

const Map<String, String> _comments = {
  'main.dart': '앱 진입점',
  'locator.dart': 'DI(Service Locator) 설정',
  'collections/': 'Isar 컬렉션/스키마',
  'constants/': '앱 전역 상수',
  'models/': '도메인/위젯 데이터 모델',
  'providers/': '상태 관리(Provider)',
  'repositories/': '데이터 접근 계층',
  'screens/': '앱 화면 및 화면 보조 로직',
  'services/': '외부 연동/백그라운드 서비스',
  'ui/': '공통 UI 레이어',
  'ui/components/': '재사용 UI 컴포넌트',
  'ui/theme/': '테마 시스템',
  'utils/': '유틸리티',
};

void main() {
  final rootDir = Directory.current;
  final readmeFile = File(_join(rootDir.path, 'README.md'));
  final libDir = Directory(_join(rootDir.path, 'lib'));

  if (!readmeFile.existsSync()) {
    stderr.writeln('README.md 파일을 찾을 수 없습니다.');
    exitCode = 1;
    return;
  }

  if (!libDir.existsSync()) {
    stderr.writeln('lib 디렉터리를 찾을 수 없습니다.');
    exitCode = 1;
    return;
  }

  final repoName = _basename(rootDir.path);
  final tree = _buildTree(repoName, libDir);
  final generatedSection = [
    _startMarker,
    '```',
    ...tree,
    '```',
    _endMarker,
  ].join('\n');

  var readme = readmeFile.readAsStringSync();
  final updated = _replaceOrInsertStructureBlock(readme, generatedSection);
  if (updated == null) {
    stderr.writeln('프로젝트 구조 섹션을 갱신할 수 없습니다. README 형식을 확인해 주세요.');
    exitCode = 1;
    return;
  }

  if (updated == readme) {
    stdout.writeln('README 프로젝트 구조가 이미 최신입니다.');
    return;
  }

  readmeFile.writeAsStringSync(updated);
  stdout.writeln('README 프로젝트 구조를 갱신했습니다.');
}

List<String> _buildTree(String repoName, Directory libDir) {
  final lines = <String>[
    '🍚 $repoName',
    '└── 📁 lib',
  ];

  _appendDirectoryTree(
    dir: libDir,
    libRoot: libDir,
    prefix: '    ',
    lines: lines,
  );
  return lines;
}

void _appendDirectoryTree({
  required Directory dir,
  required Directory libRoot,
  required String prefix,
  required List<String> lines,
}) {
  final entries = dir.listSync().where((e) => _shouldIncludeEntry(e)).toList();

  if (_isSameDirectory(dir.path, libRoot.path)) {
    entries.sort(_compareRootEntries);
  } else {
    entries.sort(_compareEntries);
  }

  for (var i = 0; i < entries.length; i++) {
    final entry = entries[i];
    final isLast = i == entries.length - 1;
    final connector = isLast ? '└──' : '├──';
    final isDirectory = entry is Directory;
    final icon = isDirectory ? '📁' : '📄';
    final name = _basename(entry.path);

    final relative = _toLibRelativePath(entry.path, libRoot.path, isDirectory);
    final comment = _commentFor(relative);
    final base = '$prefix$connector $icon $name';
    lines.add(_formatTreeLine(base, comment));

    if (entry is Directory) {
      final childPrefix = '$prefix${isLast ? '    ' : '│   '}';
      _appendDirectoryTree(
        dir: entry,
        libRoot: libRoot,
        prefix: childPrefix,
        lines: lines,
      );
    }
  }
}

int _compareEntries(FileSystemEntity a, FileSystemEntity b) {
  final aIsDir = a is Directory;
  final bIsDir = b is Directory;
  if (aIsDir != bIsDir) {
    return aIsDir ? -1 : 1;
  }
  return _basename(
    a.path,
  ).toLowerCase().compareTo(_basename(b.path).toLowerCase());
}

int _compareRootEntries(FileSystemEntity a, FileSystemEntity b) {
  final aPriority = _rootPriority(a);
  final bPriority = _rootPriority(b);
  if (aPriority != bPriority) {
    return aPriority.compareTo(bPriority);
  }
  return _compareEntries(a, b);
}

int _rootPriority(FileSystemEntity entry) {
  final name = _basename(entry.path).toLowerCase();
  if (name == 'main.dart') return 0;
  if (name == 'locator.dart') return 1;
  if (entry is Directory) return 2;
  return 3;
}

String? _replaceOrInsertStructureBlock(String readme, String generatedSection) {
  final start = readme.indexOf(_startMarker);
  final end = readme.indexOf(_endMarker);

  if (start >= 0 && end > start) {
    final endWithMarker = end + _endMarker.length;
    return '${readme.substring(0, start)}$generatedSection${readme.substring(endWithMarker)}';
  }

  final headingIndex = _findStructureHeadingIndex(readme);
  if (headingIndex < 0) return null;

  final fenceStart = readme.indexOf('```', headingIndex);
  if (fenceStart < 0) return null;

  final fenceEnd = readme.indexOf('```', fenceStart + 3);
  if (fenceEnd < 0) return null;

  final fenceEndWithTicks = fenceEnd + 3;
  return '${readme.substring(0, fenceStart)}$generatedSection${readme.substring(fenceEndWithTicks)}';
}

String? _commentFor(String relativePath) {
  return _comments[relativePath];
}

bool _shouldIncludeEntry(FileSystemEntity entry) {
  if (entry is Directory) return true;
  if (entry is! File) return false;
  final name = _basename(entry.path);
  if (name.endsWith('.g.dart')) return false;
  return true;
}

String _formatTreeLine(String base, String? comment) {
  if (comment == null) return base;
  final padding = base.length >= _commentColumn
      ? 2
      : _commentColumn - base.length;
  return '$base${' ' * padding}# $comment';
}

String _toLibRelativePath(String fullPath, String libPath, bool isDirectory) {
  final normalizedFull = fullPath.replaceAll('\\', '/');
  final normalizedLib = libPath.replaceAll('\\', '/');
  var relative = normalizedFull.substring(normalizedLib.length + 1);
  if (isDirectory) {
    relative = '$relative/';
  }
  return relative;
}

String _basename(String path) {
  final normalized = path.replaceAll('\\', '/');
  final parts = normalized.split('/');
  return parts.isEmpty ? normalized : parts.last;
}

String _join(String a, String b) {
  if (a.endsWith('/') || a.endsWith('\\')) {
    return '$a$b';
  }
  return '$a${Platform.pathSeparator}$b';
}

bool _isSameDirectory(String a, String b) {
  final normalizedA = a.replaceAll('\\', '/').toLowerCase();
  final normalizedB = b.replaceAll('\\', '/').toLowerCase();
  return normalizedA == normalizedB;
}

int _findStructureHeadingIndex(String readme) {
  const candidates = [
    '## 📁 프로젝트 구조',
    '## 프로젝트 구조',
    '## 📁 Foldering',
    '## Foldering',
  ];

  for (final heading in candidates) {
    final index = readme.indexOf(heading);
    if (index >= 0) return index;
  }
  return -1;
}
