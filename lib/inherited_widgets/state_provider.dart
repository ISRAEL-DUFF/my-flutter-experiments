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
  }

  Future<bool> reset() {
    return Future.delayed(const Duration(seconds: 5), () {
      return true;
    });
  }

  static GetIt getIt() {
    return _sl;
  }

  globalFresh() {
    // if (rebuildFn != null) {
    //   rebuildFn(DateTime.now().toString());
    // }
  }
}
