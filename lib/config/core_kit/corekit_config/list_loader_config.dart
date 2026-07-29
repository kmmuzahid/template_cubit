import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

mixin ListLoaderConfig on CoreKitConfig {
  @override
  CkListLoaderConfig? get listLoaderConfig => const CkListLoaderConfig(
        // loaderWidget: Padding(
        //   padding: EdgeInsets.all(20),
        //   child: Center(child: CircularProgressIndicator()),
        // ),
        // noMoreDataWidget: Padding(
        //   padding: EdgeInsets.all(20),
        //   child: Center(child: Text('No more data', style: TextStyle(color: Colors.grey))),
        // ),
      );
}
