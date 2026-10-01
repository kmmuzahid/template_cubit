import 'package:cubit_template/features/info/cubit/info_state.dart';
import 'package:cubit_template/features/info/repository/info_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:graft/graft.dart';

class InfoGraft extends Graft<InfoState> {
  InfoGraft() : super(InfoState());

  Future<void> getInfo(InfoType type) async {
    if (type == InfoType.privacyPolicy) {
      _privacyPolicy();
    } else {
      _termsAndConditions();
    }
  }

  Future<void> _privacyPolicy() async {
    state
      ..isLoading = true
      ..update();
    final privacyPolicy = await GetIt.I<InfoRepository>().getPrivacyPolicy();

    state
      ..isLoading = false
      ..content = privacyPolicy.data
      ..update();
  }

  Future<void> _termsAndConditions() async {
    state
      ..isLoading = true
      ..update();
    final termsAndConditions = await GetIt.I<InfoRepository>()
        .getTermsAndConditions();

    state
      ..isLoading = false
      ..content = termsAndConditions.data
      ..update();
  }
}

typedef InfoCubit = InfoGraft;
