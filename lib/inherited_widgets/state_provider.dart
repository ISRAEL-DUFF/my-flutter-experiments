import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:trouter/model.dart';
import './provider.dart';

final _sl = GetIt.instance;
typedef DepRegCallback = Future<void> Function(GetIt);

class StateProvider {
  static Future<void> initializeState(DepRegCallback registerDep) async {
    // return Future.delayed(const Duration(seconds: 5), () {
    //   return true;
    // });
    await registerDep(_sl);
    // MyData1 d = _sl<MyData1>(instanceName: 'MyData1');
    // _sl.resetLazySingleton(instanceName: 'MyData1');
    // d = _sl<MyData1>(instanceName: 'MyData1');
  }

  Future<bool> reset() {
    return Future.delayed(const Duration(seconds: 5), () {
      return true;
    });
  }

  // refresh<R extends Object>() {
  //   context.tGetIt().resetLazySingleton(instance: data as R);
  //   context.tGetIt().allReady().then((f) {
  //     data = widget.create(context) as T;
  //     context.tUpdateListeners();
  //   });
  // }

  static GetIt getIt() {
    return _sl;
  }

  globalFresh() {
    // if (rebuildFn != null) {
    //   rebuildFn(DateTime.now().toString());
    // }
  }
}
