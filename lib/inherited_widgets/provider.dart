import 'package:flutter/material.dart';
import 'dart:math';
import 'mixins.dart';

class TProvider<T> extends StatefulWidget {
  Widget? child;
  final T? data;
  TProvider({Key? key, this.data, this.child}) : super(key: key);

  @override
  TProviderState createState() => TProviderState<T>(data: data);

  static TProviderState? of<P>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TInheritedWidget<P>>()!
        .state;
  }
}

class TProviderState<T> extends State<TProvider> {
  T? data;
  TProviderState({this.data});

  @override
  Widget build(BuildContext context) =>
      TInheritedWidget(child: widget.child, data: data, state: this);
}

class TInheritedWidget<T> extends InheritedWidget {
  final T? data;
  final TProviderState? state;
  TInheritedWidget({Key? key, this.state, @required Widget? child, this.data})
      : super(key: key, child: child!);

  @override
  bool updateShouldNotify(TInheritedWidget oldWidget) {
    print('update should notify called ${oldWidget.data}');
    return true;
  }

  // NOTE: this static func has been moved to TProvider
  // static TProviderState? of<P>(BuildContext context) {
  //   return context
  //       .dependOnInheritedWidgetOfExactType<TInheritedWidget<P>>()!
  //       .state;
  // }
}

class TMultiprovider extends StatelessWidget {
  final Widget? child;
  final List<TProvider>? providers;
  const TMultiprovider({Key? key, this.child, @required this.providers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildTree();
  }

  TProvider _buildTree({int i = 0}) {
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

class TDataNotifier extends ValueNotifier<int> {
  TDataNotifier() : super(Random().nextInt(500));
  updateState() {
    value = Random().nextInt(500);
  }
}

class TListenableBuilder<T extends TDataNotifier> extends StatelessWidget {
  final Widget Function(BuildContext, T, Widget?) builder;
  Widget? child;
  T listener;
  TListenableBuilder(
      {Key? key, required this.listener, required this.builder, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: listener,
        child: child,
        builder: (context, v, child) {
          return builder(context, listener, child);
        });
  }
}

// MULTIPLE Listenable
class TListenable<T extends TDataNotifier> {
  T listener;
  TListenable({required this.listener}) {
    // assert(isSubtype<T, TDataNotifier>());
  }
}

class TMultiListenableBuilder extends StatefulWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;
  final List<TListenable> listeners;
  const TMultiListenableBuilder(
      {Key? key, required this.listeners, required this.builder, this.child})
      : super(key: key);
  @override
  TMultiListenableBuilderState createState() => TMultiListenableBuilderState();

  TListenable? find<T>() {
    for (TListenable l in listeners) {
      if (l.listener is T) {
        return l;
      }
    }
  }
}

class TMultiListenableBuilderState extends State<TMultiListenableBuilder>
    with TypeCheck {
  @override
  void initState() {
    super.initState();

    // listen for individual changes in listeners
    for (TListenable l in widget.listeners) {
      l.listener.addListener(listenForUpdate);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    for (TListenable l in widget.listeners) {
      l.listener.removeListener(listenForUpdate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildTree();
  }

  Widget _buildTree({int i = 0}) {
    if (i < widget.listeners.length - 1) {
      return Builder(builder: (context) {
        return _buildTree(i: i + 1);
      });
    } else {
      return Builder(builder: (context) {
        return widget.builder(context, widget.child);
      });
    }
  }

  listenForUpdate() {
    setState(() {
      print('Update received and state updateded');
    });
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
