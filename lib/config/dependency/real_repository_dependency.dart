/*
 * @Author: Km Muzahid
 * @Date: 2026-01-07 12:29:06
 * @Email: km.muzahid@gmail.com
 */

import 'package:cubit_template/features/info/repository/info_repository.dart';
import 'package:get_it/get_it.dart';

class RealRepositoryDependency {
  static void dependencies() {
    GetIt.I.registerLazySingleton<InfoRepository>(() => InfoRepository());
  }
}
