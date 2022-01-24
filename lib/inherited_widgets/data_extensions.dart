import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';
import './provider.dart';
import './state_provider.dart';

extension StateExtension<T> on TProviderState<T> {
  // refresh<R extends Object>() {
  //   context.tGetIt().resetLazySingleton(instance: data as R);
  //   context.tGetIt().allReady().then((f) {
  //     data = widget.create(context) as T;
  //     context.tUpdateListeners();
  //   });
  // }
}

// typedef pFunc<R extends TDataNotifier> = Create<R> Function();

Create<R> crate<R extends Object>(GetIt sl) {
  return (BuildContext context) {
    return sl.get<R>();
  };
}

extension GetItExtension on GetIt {
  static List<Widget> tProviders = [];
  static TDataNotifier dataNotifier = TDataNotifier();
  registerLazySingletonP<T extends TDataNotifier>(T Function() factoryFunc,
      {String? instanceName, FutureOr<dynamic> Function(T)? dispose}) async {
    registerLazySingleton(factoryFunc,
        instanceName: instanceName, dispose: dispose);
    tProviders.add(TProvider(create: crate<T>(GetIt.instance)));
  }

  registerSingletonP<T extends TDataNotifier>(T instance,
      {String? instanceName,
      bool? signalsReady,
      FutureOr<dynamic> Function(T)? dispose}) {
    registerSingleton(instance,
        instanceName: instanceName,
        signalsReady: signalsReady,
        dispose: dispose);
    tProviders.add(TProvider(create: crate<T>(GetIt.instance)));
  }
}

// extension on BuildContext
extension StateOnContext on BuildContext {
  T? find<T>() {
    return TProvider.of<T>(this);
  }

  TProviderState tWState<T>() {
    return TProvider.fo<T>(this)!;
  }

  refresh<R extends Object>() {
    tGetIt().resetLazySingleton<R>();
    tGetIt().allReady().then((f) {
      tWState<R>().data = tWState<R>().widget.create(this);
      tWState<R>().rebuild();
      tUpdateListeners();
    });
  }

  GetIt tGetIt() {
    return StateProvider.getIt();
  }

  List<Widget> tGetItProviders() {
    return GetItExtension.tProviders;
  }

  tUpdateListeners() {
    GetItExtension.dataNotifier.updateValue();
  }

  TDataNotifier tDataListenable() {
    return GetItExtension.dataNotifier;
  }
}
