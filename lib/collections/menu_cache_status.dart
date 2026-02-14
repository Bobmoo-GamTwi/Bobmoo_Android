import 'package:isar_community/isar.dart';

part 'menu_cache_status.g.dart';

// 일관성 유지를 위해 복수형으로 이름을 지정해줌.
@Collection(accessor: "menuCacheStatuses")
class MenuCacheStatus {
  Id id = Isar.autoIncrement;

  // 어떤 날짜의 캐시 정보인지 나타내는 필드. 이 값은 고유해야 함.
  @Index(unique: true, replace: true)
  late DateTime date;

  // 이 날짜의 데이터가 마지막으로 API로부터 생성된 시간
  late DateTime lastFetchedAt;
}
