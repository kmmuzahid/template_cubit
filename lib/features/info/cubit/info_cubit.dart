import 'package:cubit_template/config/bloc/safe_cubit.dart';
import 'package:cubit_template/features/info/cubit/info_state.dart';
import 'package:cubit_template/features/info/repository/info_repository.dart';
import 'package:get_it/get_it.dart';

class InfoCubit extends SafeCubit<InfoState> {
  InfoCubit() : super(InfoState());

  Future<void> getInfo(InfoType type) async {
    if (type == InfoType.privacyPolicy) {
      _privacyPolicy();
    } else {
      _termsAndConditions();
    }
  }

  Future<void> _privacyPolicy() async {
    emit(state.copyWith(isLoading: true));
    final privacyPolicy = await GetIt.I<InfoRepository>().getPrivacyPolicy();

    emit(state.copyWith(isLoading: false, content: privacyPolicy.data));
  }

  Future<void> _termsAndConditions() async {
    emit(state.copyWith(isLoading: true));
    final termsAndConditions = await GetIt.I<InfoRepository>()
        .getTermsAndConditions();

    emit(state.copyWith(isLoading: false, content: termsAndConditions.data));
  }
}
