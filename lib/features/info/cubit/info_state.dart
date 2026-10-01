import 'package:graft/graft.dart';

enum InfoType { privacyPolicy, termsAndConditions }

class InfoState extends GraftState {
  bool isLoading;
  String content;

  InfoState({this.isLoading = false, this.content = ''});
}
