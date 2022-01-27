import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';
import './provider.dart';
import './state_provider.dart';

class TDependencyNotifier<T extends Object> {
  void Function<R extends Object>(BuildContext) onRebuildDepencies;
  TDataNotifier dataNotifier;
  TDependencyNotifier(
      {required this.dataNotifier, required this.onRebuildDepencies});

  rebuildDependencies(BuildContext context) {
    onRebuildDepencies<T>(context);
  }
}

extension StateExtension<T> on TProviderState<T> {
  // refresh<R extends Object>() {
  //   context.tGetIt().resetLazySingleton(instance: data as R);
  //   context.tGetIt().allReady().then((f) {
  //     data = widget.create(context) as T;
  //     context.tUpdateListeners();
  //   });
  // }
}

Create<R> crate<R extends Object>(GetIt sl) {
  return (BuildContext context) {
    return sl.get<R>();
  };
}

extension GetItExtension on GetIt {
  static List<Widget> tProviders = [];
  static Map<Type, TDependencyNotifier> dependencyNotifiers = {};
  registerLazySingletonP<T extends ChangeNotifier>(T Function() factoryFunc,
      {String? instanceName, FutureOr<dynamic> Function(T)? dispose}) async {
    registerLazySingleton(factoryFunc,
        instanceName: instanceName, dispose: dispose);

    // store listeners to notify when GetIt resets this object of type T
    registerAnewType<T>();

    // create a provider for this type T
    Widget w = TProvider(create: crate<T>(GetIt.instance));
    tProviders.add(w);
  }

  registerSingletonP<T extends ChangeNotifier>(T instance,
      {String? instanceName,
      bool? signalsReady,
      FutureOr<dynamic> Function(T)? dispose}) {
    registerSingleton(instance,
        instanceName: instanceName,
        signalsReady: signalsReady,
        dispose: dispose);
    Widget w = TProvider(create: crate<T>(GetIt.instance));
    // Widget w = Grael(create: crate<T>(GetIt.instance));
    tProviders.add(w);
  }

  static registerAnewType<T extends Object>() {
    // store listeners to notify when this object resets
    if (dependencyNotifiers[T] == null) {
      dependencyNotifiers[T] = TDependencyNotifier(
          dataNotifier: TDataNotifier(),
          onRebuildDepencies: <P extends Object>(context) {
            context._rebuildDependencies<T>();
          });
    }
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

  void _rebuildDependencies<R extends Object>() {
    // tWState<R>().data = tWState<R>().widget.create(this);
    tWState<R>().rebuild();
    tUpdateListeners<R>();
  }

  reset<R extends Object>() {
    tGetIt().resetLazySingleton<R>();
    tGetIt().allReady().then((f) {
      _rebuildDependencies<R>();
    });
  }

  resetAll() async {
    // TODO: Implement this feature
    // This feature should only reset (and not unregister) all lazySinglitons
    await tGetIt().reset();
    tGetIt().allReady().then((f) {
      for (TDependencyNotifier d in GetItExtension.dependencyNotifiers.values) {
        d.rebuildDependencies(this);
      }
    });
  }

  GetIt tGetIt() {
    return StateProvider.getIt();
  }

  List<Widget> tGetItProviders() {
    return GetItExtension.tProviders;
  }

  tUpdateListeners<R extends Object>() {
    GetItExtension.dependencyNotifiers[R]?.dataNotifier.updateValue();
  }

  TDataNotifier tDataListenable<R extends Object>() {
    return GetItExtension.dependencyNotifiers[R]!.dataNotifier;
  }

  TListenable<T> value<T extends ChangeNotifier>({T? value}) {
    return TListenable(value: value);
  }
}
