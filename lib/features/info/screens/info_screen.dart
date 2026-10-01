import 'package:auto_route/annotations.dart';
import 'package:core_kit/core_kit_internal.dart';
import 'package:cubit_template/features/info/cubit/info_cubit.dart';
import 'package:cubit_template/features/info/cubit/info_state.dart';
import 'package:graft/graft.dart';
import 'package:material_ui/material_ui.dart';

@RoutePage()
class InfoScreen extends StatelessWidget {
  final InfoType type;
  const InfoScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final graft = context.use<InfoGraft>()..getInfo(type);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CkAppBar(
        title: type == InfoType.privacyPolicy
            ? 'Privacy Policy'
            : 'Terms and Conditions',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: graft.layout((context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return CkText(text: state.content);
        }),
      ),
    );
  }
}
