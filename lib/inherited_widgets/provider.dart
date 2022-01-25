import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'mixins.dart';
import './data_extensions.dart';

typedef Create<R> = R Function(BuildContext context);
// typedef Greal<R> = TProvider Function(
//     {Key? key, required Create<R> create, Widget? child});

class Grael<T extends ChangeNotifier> extends StatelessWidget {
  Widget? child;
  Create<T> create;
  Key? gkey;
  Grael({Key? key, required this.create, this.child}) {
    gkey = key ?? GlobalKey<TProviderState>();
  }

  @override
  Widget build(BuildContext context) {
    return TProvider(key: gkey, create: create, child: child);
  }
}

class TProvider<T extends ChangeNotifier> extends StatefulWidget {
  Widget? child;
  Create<T> create;

  static List<Widget> allProviders = [];
  TProvider({Key? key, required this.create, this.child}) : super(key: key) {
    // _k = key;
    // _id = allProviders.length;
    allProviders.add(this);
    GetItExtension.registerAnewType<T>();
    print('Data Notifiers: ${GetItExtension.dataNotifiers}');

    // dataNotifiers[_id!] = TDataNotifier();
  }

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
  TProviderState();

  @override
  void initState() {
    super.initState();
    data = widget.create(context) as T;
  }

  rebuild() {
    setState(() {});
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
  List<Widget>? providers = [];
  final List<Widget> allProvides = [];
  TMultiprovider({Key? key, this.child, this.providers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> provs = context.tGetItProviders();
    allProvides.addAll(providers!);
    allProvides.addAll(provs);
    return _buildTree(context);
  }

  TProvider _buildTree(BuildContext context, {int i = 0}) {
    // Widget p = providers[i];
    // if (providers.isEmpty) return TProvider(create: (_) => TDataNotifier());
    if (allProvides.isEmpty) return TProvider(create: (_) => TDataNotifier());

    Widget p = allProvides[i];
    TProvider? tp;
    if (p is TProvider) {
      tp = p as TProvider;
    } else {
      throw ('Type $p is not a $TProvider');
    }

    if (i < allProvides.length - 1) {
      tp.child = _buildTree(context, i: i + 1);
      return tp;
    } else {
      tp.child = child!;
      return tp;
    }
  }
}

class TDataNotifier extends ValueNotifier<int> {
  TDataNotifier() : super(Random().nextInt(500));
  updateValue({int? v}) {
    if (v == null) {
      value = Random().nextInt(500);
    } else {
      value = v;
    }
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
class TListenable<T extends ChangeNotifier> with TypeCheck {
  T? value;
  TListenable({this.value}) {
    // if (!isSubtype<T, TDataNotifier>()) {
    //   throw ('Type $T must be a subtype of $TDataNotifier');
    // }

    if (!isSubtype<T, ChangeNotifier>()) {
      throw ('Type $T must be a subtype of $ChangeNotifier');
    }
  }

  bool getValueFromProvider(BuildContext context) {
    value = TProvider.of<T>(context);
    if (value == null) {
      return false;
    } else {
      return true;
    }
  }

  bool get noValue {
    if (value == null) {
      return true;
    } else {
      return false;
    }
  }

  addListener({void Function()? onUpdate, void Function()? onReset}) {
    if (!noValue) {
      if (onUpdate != null) {
        value!.addListener(onUpdate);
      }

      if (onReset != null) {
        GetItExtension.dataNotifiers[T]?.addListener(onReset);
      }
    }
  }

  removeListener({void Function()? onUpdate, void Function()? onReset}) {
    if (!noValue) {
      if (onUpdate != null) {
        value!.removeListener(onUpdate);
      }

      if (onReset != null) {
        GetItExtension.dataNotifiers[T]?.removeListener(onReset);
      }
    }
  }
}

class TMultiListenableBuilder extends StatefulWidget {
  final Widget Function(
      BuildContext, T? Function<T extends ChangeNotifier>(), Widget?) builder;
  final Widget? child;
  final List<TListenable> values;
  const TMultiListenableBuilder(
      {Key? key, required this.values, required this.builder, this.child})
      : super(key: key);
  @override
  TMultiListenableBuilderState createState() => TMultiListenableBuilderState();

  T? find<T extends ChangeNotifier>() {
    for (TListenable l in values) {
      if (l.value is T) {
        return l.value as T;
      }
    }
  }
}

class TMultiListenableBuilderState extends State<TMultiListenableBuilder>
    with TypeCheck {
  bool initialized = false;
  int rebuildValue = 0;
  @override
  void initState() {
    super.initState();

    //
    // rebuildValue = context.tDataListenable().value;
    // context.tDataListenable().addListener(listenForRebuild);

    // init listeners
    // initListeners();
  }

  @override
  void dispose() {
    super.dispose();
    for (TListenable l in widget.values) {
      // l.value.removeListener(listenForUpdate);
      l.removeListener(onUpdate: listenForUpdate, onReset: listenForRebuild);
    }
    // context.tDataListenable().removeListener(listenForRebuild);
  }

  initListeners() {
    // listen for individual changes in listeners
    for (TListenable l in widget.values) {
      if (l.noValue) {
        if (!l.getValueFromProvider(context)) {
          throw ('No Provider value found for ${l.runtimeType}');
        }
      }
      l.addListener(onUpdate: listenForUpdate, onReset: listenForRebuild);
    }

    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   setState(() {
    //     initialized = true;
    //     rebuildValue = context.tDataListenable().value;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    // if (!initialized || rebuildValue != context.tDataListenable().value) {
    //   initListeners();
    // }
    if (!initialized) initListeners();
    return _buildTree();
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

  listenForRebuild() {
    print('Listener called: $rebuildValue');
    initListeners();
  }
}
