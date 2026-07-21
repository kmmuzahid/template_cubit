import 'package:cubit_template/config/dependency/core_dependency.dart';
import 'package:cubit_template/config/dependency/real_repository_dependency.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class DependencyInjection {
  void dependencies() {
    CoreDependency.dependencies();

    //repositroy
    // MockRepositoryDependency.dependencies();
    RealRepositoryDependency.dependencies();
  }
}
