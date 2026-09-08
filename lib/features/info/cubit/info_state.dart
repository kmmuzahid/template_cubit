import 'package:equatable/equatable.dart';

enum InfoType { privacyPolicy, termsAndConditions }

class InfoState extends Equatable {
  final bool isLoading;
  final String content;

  const InfoState({this.isLoading = false, this.content = ''});

  InfoState copyWith({bool? isLoading, String? content}) {
    return InfoState(
      isLoading: isLoading ?? this.isLoading,
      content: content ?? this.content,
    );
  }

  @override
  List<Object?> get props => [isLoading, content];
}
