/*
 * @Author: Km Muzahid
 * @Date: 2026-01-07 12:29:06
 * @Email: km.muzahid@gmail.com
 */
import 'package:cubit_template/config/bloc/safe_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CubitConsumerScope<T extends SafeCubit<S>, S> extends StatelessWidget {
  const CubitConsumerScope({
    required this.create,
    required this.builder,
    super.key,
    this.listener,
  });
  final T Function() create;
  final void Function(BuildContext context, S state)? listener;
  final Widget Function(BuildContext context, T cubit, S state) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>(
      create: (_) => create(),
      child: BlocConsumer<T, S>(
        listener: (context, state) {
          if (listener != null) listener!(context, state);
        },
        builder: (context, state) {
          final cubit = context.read<T>();
          return builder(context, cubit, state);
        },
      ),
    );
  }
}
