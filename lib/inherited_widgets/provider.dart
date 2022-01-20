import 'package:flutter/material.dart';
import 'dart:math';
import 'mixins.dart';

typedef Create<R> = R Function(BuildContext context);

class TProvider<T extends TDataNotifier> extends StatefulWidget {
  Widget? child;
  Create<T> create;
  TProvider({Key? key, required this.create, this.child}) : super(key: key);

  @override
  TProviderState createState() => TProviderState<T>();

  static TProviderState? fo<P>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TInheritedWidget<P>>()!
        .state;
  }

  static P? of<P>(BuildContext context) {
    return fo<P>(context)!.data;
  }
}

class TProviderState<T> extends State<TProvider> {
  T? data;
  // Create<T> create;
  TProviderState();

  @override
  void initState() {
    super.initState();
    data = widget.create(context) as T;
  }

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
}

class TMultiprovider extends StatelessWidget {
  final Widget? child;
  final List<Widget> providers;
  const TMultiprovider({Key? key, this.child, required this.providers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildTree();
  }

  TProvider _buildTree({int i = 0}) {
    Widget p = providers[i];
    TProvider? tp;
    if (p is TProvider) {
      tp = p as TProvider;
    } else {
      throw ('Type $p is not a $TDataNotifier');
    }

    if (providers.isEmpty) return TProvider(create: (_) => TDataNotifier());
    if (i < providers.length - 1) {
      tp.child = _buildTree(i: i + 1);
      return tp;
    } else {
      tp.child = child!;
      return tp;
    }
  }
}

class TDataNotifier extends ValueNotifier<int> {
  TDataNotifier() : super(Random().nextInt(500));

  @override
  notifyListeners() {
    // TODO: custom logic here

    // well, still thinking of what / how to update this 'value'
    // value = Random().nextInt(500);

    // finally call notifyListeners from Super class ValueNotifier
    super.notifyListeners();
  }
}

class TListenableBuilder<T extends TDataNotifier> extends StatelessWidget {
  final Widget Function(BuildContext, T, Widget?) builder;
  Widget? child;
  T value;
  TListenableBuilder(
      {Key? key, required this.value, required this.builder, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: value,
        child: child,
        builder: (context, v, child) {
          return builder(context, value, child);
        });
  }
}

// MULTIPLE Listenable
class TListenable<T> with TypeCheck {
  T? value;
  TListenable({this.value}) {
    if (!isSubtype<T, TDataNotifier>()) {
      throw ('Type $T must be a subtype of $TDataNotifier');
    }
  }

  bool valueFromProvider(BuildContext context) {
    value = TProvider.of<T>(context);
    if (value == null) {
      return false;
    } else {
      return true;
    }
  }
}

class TMultiListenableBuilder extends StatefulWidget {
  final Widget Function(
      BuildContext, T? Function<T extends TDataNotifier>(), Widget?) builder;
  final Widget? child;
  final List<TListenable> values;
  const TMultiListenableBuilder(
      {Key? key, required this.values, required this.builder, this.child})
      : super(key: key);
  @override
  TMultiListenableBuilderState createState() => TMultiListenableBuilderState();

  T? find<T extends TDataNotifier>() {
    for (TListenable l in values) {
      if (l.value is T) {
        return l.value;
      }
    }
  }
}

class TMultiListenableBuilderState extends State<TMultiListenableBuilder>
    with TypeCheck {
  bool initialized = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    for (TListenable l in widget.values) {
      l.value.removeListener(listenForUpdate);
    }
  }

  initListeners() {
    // listen for individual changes in listeners
    for (TListenable l in widget.values) {
      if (l.value == null) {
        if (!l.valueFromProvider(context)) {
          throw ('No Provider value found for ${l.runtimeType}');
        }
      }
      l.value.addListener(listenForUpdate);
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        initialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return _buildTree();
    } else {
      initListeners();
      return Container();
    }
  }

  Widget _buildTree({int i = 0}) {
    if (i < widget.values.length - 1) {
      return Builder(builder: (context) {
        return _buildTree(i: i + 1);
      });
    } else {
      return Builder(builder: (context) {
        return widget.builder(context, widget.find, widget.child);
      });
    }
  }

  listenForUpdate() {
    setState(() {});
  }
}
