// GetIt 인스턴스 생성
import 'package:bobmoo/collections/meal_collection.dart';
import 'package:bobmoo/collections/menu_cache_status.dart';
import 'package:bobmoo/collections/restaurant_collection.dart';
import 'package:bobmoo/repositories/meal_repository.dart';
import 'package:bobmoo/services/menu_service.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // SharedPreferences 등록
  final prefs = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(prefs);

  // Isar 인스턴스 초기화
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      RestaurantSchema,
      MealSchema,
      MenuCacheStatusSchema,
    ],
    directory: dir.path,
  );
  // Isar 인스턴스를 싱글톤으로 등록
  locator.registerSingleton<Isar>(isar);

  // 서비스(API) 클래스 등록
  // registerLazySingleton: 해당 클래스를 처음 요청할 때 인스턴스가 생성됨
  locator.registerLazySingleton(() => MenuService());

  // Repository 등록
  // MealRepository는 Isar와 MenuService를 필요로 하므로, locator를 통해 주입받음
  locator.registerLazySingleton(
    () => MealRepository(
      isar: locator<Isar>(),
      menuService: locator<MenuService>(),
    ),
  );
}
