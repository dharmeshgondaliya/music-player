import 'package:get/get.dart';

import '../modules/directory_list/bindings/directory_list_binding.dart';
import '../modules/directory_list/views/directory_list_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/music_list/bindings/music_list_binding.dart';
import '../modules/music_list/views/music_list_view.dart';
import '../modules/player_screen/bindings/player_screen_binding.dart';
import '../modules/player_screen/views/player_screen_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/test/bindings/test_binding.dart';
import '../modules/test/views/test_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.MUSIC_LIST,
      page: () => const MusicListView(),
      binding: MusicListBinding(),
    ),
    GetPage(
      name: _Paths.PLAYER_SCREEN,
      page: () => const PlayerScreenView(),
      binding: PlayerScreenBinding(),
    ),
    GetPage(
      name: _Paths.TEST,
      page: () => const TestView(),
      binding: TestBinding(),
    ),
    GetPage(
      name: _Paths.DIRECTORY_LIST,
      page: () => const DirectoryListView(),
      binding: DirectoryListBinding(),
    ),
  ];
}
