import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'safe_cubit.dart';

class CubitScope<T extends SafeCubit<S>, S> extends StatelessWidget {
  const CubitScope({required this.create, required this.builder, super.key});
  final T Function() create;
  final Widget Function(BuildContext context, T cubit, S state) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>(
      create: (_) => create(),
      child: BlocBuilder<T, S>(
        builder: (context, state) {
          final cubit = context.read<T>();
          return builder(context, cubit, state);
        },
      ),
    );
  }
}
