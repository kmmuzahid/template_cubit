import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CubitScopeValue<T extends Cubit<S>, S> extends StatelessWidget {
  const CubitScopeValue({required this.cubit, required this.builder, super.key});
  final T cubit;
  final Widget Function(BuildContext context, T cubit, S state) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>.value(
      value: cubit,
      child: BlocBuilder<T, S>(
        builder: (context, state) {
          return builder(context, cubit, state);
        },
      ),
    );
  }
}
