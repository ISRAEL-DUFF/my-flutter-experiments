import 'package:flutter/material.dart';
import 'dart:math';
import 'mixins.dart';

class TProviderStateWrapper<T> extends StatefulWidget {
  Widget? child;
  final T? data;
  TProviderStateWrapper({Key? key, this.data, this.child}) : super(key: key);

  @override
  TProviderState createState() => TProviderState<T>(data: data);
}

class TProviderState<T> extends State<TProviderStateWrapper> {
  T? data;

  TProviderState({this.data});

  // updateData(T d) {
  //   setState(() {
  //     data = d;
  //   });
  // }

  @override
  Widget build(BuildContext context) =>
      TProvider(child: widget.child, data: data, state: this);
}

class TProvider<T> extends InheritedWidget {
  final T? data;
  final TProviderState? state;
  TProvider({Key? key, this.state, @required Widget? child, this.data})
      : super(key: key, child: child!);

  @override
  bool updateShouldNotify(TProvider oldWidget) {
    print('update should notify called ${oldWidget.data}');
    return true;
  }

  static TProviderState? of<P>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TProvider<P>>()!.state;
  }
}

class TMultiprovider extends StatelessWidget {
  final Widget? child;
  final List<TProviderStateWrapper>? providers;
  const TMultiprovider({Key? key, this.child, @required this.providers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildTree();
  }

  TProviderStateWrapper _buildTree({int i = 0}) {
    // TODO: check case providers.len == 0
    if (i < providers!.length - 1) {
      providers![i].child = _buildTree(i: i + 1);
      return providers![i];
    } else {
      providers![i].child = child!;
      return providers![i];
    }
  }
}

class TDataNotifier {
  final ValueNotifier<int> _someV = ValueNotifier<int>(Random().nextInt(500));

  ValueNotifier<int> get v => _someV;
  updateState() {
    _someV.value = Random().nextInt(500);
  }
}

class MyListenableBuilder<T> extends StatelessWidget with TypeCheck {
  final Widget Function(BuildContext, T, Widget?)? builder;
  Widget? child;
  T? listener;
  MyListenableBuilder(
      {Key? key, @required this.listener, @required this.builder, this.child})
      : super(key: key) {
    assert(isSubtype<T, TDataNotifier>());
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: (listener! as TDataNotifier).v,
        child: child,
        builder: (context, v, child) {
          return builder!(context, listener!, child);
        });
  }
}

// MULTIPLE Listenable
class TListenable<T extends TDataNotifier> with TypeCheck {
  T? listener;
  TListenable({this.listener}) {
    assert(isSubtype<T, TDataNotifier>());
  }
}

class MultiListenableBuilder extends StatelessWidget with TypeCheck {
  final Widget Function(BuildContext, Widget?)? builder;
  Widget? child;
  List<TListenable>? listeners;
  MultiListenableBuilder(
      {Key? key, @required this.listeners, @required this.builder, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildTree();
  }

  ValueListenableBuilder<int> _buildTree({int i = 0}) {
    // TODO: check case listeners.len == 0
    if (i < listeners!.length - 1) {
      return ValueListenableBuilder<int>(
          valueListenable: (listeners![i].listener as TDataNotifier).v,
          child: _buildTree(i: i + 1),
          builder: (context, v, child) {
            // return builder!(context, child);
            return child!;
          });
    } else {
      return ValueListenableBuilder<int>(
          valueListenable: (listeners![i].listener as TDataNotifier).v,
          child: child,
          builder: (context, v, child) {
            return builder!(context, child);
            // return child!;
          });
    }
  }
}

class MyData1 extends TDataNotifier {
  int a = 1;
  int b = 2;
  String c = 'C';

  updateA(int newA) {
    a = newA;
    updateState();
  }
}

class MyData2 extends TDataNotifier {
  int nuum = 1;
  String c = 'C';

  updateName(String name) {
    c = name;
    updateState();
  }
}
