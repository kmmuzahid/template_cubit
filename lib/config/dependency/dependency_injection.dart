import 'package:cubit_template/config/dependency/core_dependency.dart';
import 'package:cubit_template/config/dependency/real_repository_dependency.dart';
import 'package:cubit_template/features/info/cubit/info_cubit.dart';
import 'package:cubit_template/features/splash/cubit/live_counter_graft.dart';
import 'package:cubit_template/features/splash/cubit/splash_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:graft/graft.dart';

GetIt getIt = GetIt.instance;

class DependencyInjection {
  void dependencies() {
    CoreDependency.dependencies();

    //repositroy
    // MockRepositoryDependency.dependencies();
    RealRepositoryDependency.dependencies();

    // Graft Registrations & GetIt Fallback
    GraftRegistry.fallbackLocator = <T extends Object>() => getIt<T>();
    GraftRegistry.register(InfoGraft.new);
    GraftRegistry.register(SplashCubit.new);
    GraftRegistry.register(LiveCounterGraft.new);
  }
}
