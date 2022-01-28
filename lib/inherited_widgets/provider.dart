import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trouter/model.dart';
import 'dart:math';
import 'mixins.dart';
import './data_extensions.dart';

// debug
bool debugMode = true;
debugPrint(Object? object) {
  if (debugMode) print(object);
}

typedef Create<R> = R Function(BuildContext context);

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
  TDataNotifier notifier = TDataNotifier();
  int? _currentBuildValue;
  TProviderState();

  @override
  void initState() {
    super.initState();
    data = widget.create(context) as T;
    _currentBuildValue = notifier.value;
  }

  @override
  void didChangeDependencies() {
    // change dependencies here
    _currentBuildValue = notifier.value;
    debugPrint('TProvider Dependency changed: $_currentBuildValue');

    // finally call super
    super.didChangeDependencies();
  }

  rebuild() {
    setState(() {
      data = widget.create(context) as T;
      notifier.updateValue();
    });
  }

  @override
  Widget build(BuildContext context) => TInheritedWidget(
        child: widget.child,
        data: data,
        state: this,
        buildValue: _currentBuildValue!,
      );
}

class TInheritedWidget<T> extends InheritedWidget {
  final T? data;
  final TProviderState? state;
  final int buildValue;
  TInheritedWidget(
      {Key? key,
      this.state,
      @required Widget? child,
      this.data,
      required this.buildValue})
      : super(key: key, child: child!);

  @override
  bool updateShouldNotify(TInheritedWidget oldWidget) {
    // if (buildValue == oldWidget.buildValue) {
    //   debugPrint('Update should NOT Notify Descendants');
    //   return false;
    // } else {
    //   debugPrint('Update IS Notifying inherited descendants ');
    //   return true;
    // }
    debugPrint('BuildValues: ${oldWidget.buildValue}, $buildValue');

    if (data == oldWidget.data) {
      debugPrint('Update should NOT Notify Descendants');
      return false;
    } else {
      debugPrint('Update IS Notifying inherited descendants ');
      return true;
    }
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
    if (allProvides.isEmpty) return TProvider(create: (_) => TDataNotifier());

    Widget p = allProvides[i];
    TProvider? tp;
    if (p is TProvider) {
      tp = p;
    } else if (p is Grael) {
      tp = p.build(context) as TProvider;
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

//
// class TListenableBuilder<T extends TDataNotifier> extends StatelessWidget {
//   final Widget Function(BuildContext, T, Widget?) builder;
//   Widget? child;
//   T value;
//   TListenableBuilder(
//       {Key? key, required this.value, required this.builder, this.child})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<int>(
//         valueListenable: value,
//         child: child,
//         builder: (context, v, child) {
//           return builder(context, value, child);
//         });
//   }
// }

// MULTIPLE Listenable
class TListenable<T extends ChangeNotifier> with TypeCheck {
  T? value;
  bool valueIsFromProvider = false;
  TListenable({this.value}) {
    if (!isSubtype<T, ChangeNotifier>()) {
      throw ('Type $T must be a subtype of $ChangeNotifier');
    }

    if (hasNoValue) valueIsFromProvider = true;
  }

  void getValueFromProvider(BuildContext context) {
    value = TProvider.of<T>(context);
    if (value == null) {
      throw ('No Provider value found for $T');
    }
  }

  bool get hasNoValue {
    if (value == null) {
      return true;
    } else {
      return false;
    }
  }

  bool get hasValue {
    return !hasNoValue;
  }

  bool get shouldGetValueFromProvider {
    return hasNoValue || valueIsFromProvider;
  }

  addListener({void Function()? onUpdate, void Function()? onReset}) {
    debugPrint('Adding Listener for $T');
    if (hasValue) {
      if (onUpdate != null) {
        value!.addListener(onUpdate);
      }

      if (onReset != null) {
        GetItExtension.dependencyNotifiers[T]?.dataNotifier
            .addListener(onReset);
      }
    }
  }

  removeListener({void Function()? onUpdate, void Function()? onReset}) {
    debugPrint('Removing Listener for $T');

    if (hasValue) {
      if (onUpdate != null) {
        value!.removeListener(onUpdate);
      }

      if (onReset != null) {
        GetItExtension.dependencyNotifiers[T]?.dataNotifier
            .removeListener(onReset);
      }
    }
  }
}

// class MultiListenableBuilder extends StatelessWidget {
//   final Widget Function(
//       BuildContext, T? Function<T extends ChangeNotifier>(), Widget?) builder;
//   final Widget? child;
//   final List<TListenable> values;
//   Key? gkey;

//   MultiListenableBuilder(
//       {Key? key, required this.values, required this.builder, this.child}) {
//     gkey = key ?? GlobalKey<TMultiListenableBuilderState>();
//   }

//   @override
//   Widget build(BuildContext context) => TMultiListenableBuilder(
//         key: gkey,
//         values: values,
//         builder: builder,
//         child: child,
//       );
// }

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    debugPrint('Dependency changed -: $initialized');

    // change dependencies here
    if (!initialized) {
      initListeners();
    }
    debugPrint('Dependency changed: $initialized');

    // finally call super
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    unsubscribeFromEvents();
    debugPrint('Widget State Dispose called');
  }

  void unsubscribeFromEvents() {
    for (TListenable l in widget.values) {
      l.removeListener(onUpdate: listenForUpdate, onReset: listenForRebuild);
    }
  }

  void subscribeToEvents([resubscription = false]) {
    for (TListenable l in widget.values) {
      if (l.shouldGetValueFromProvider) {
        l.getValueFromProvider(context);
      }
      l.addListener(onUpdate: listenForUpdate, onReset: listenForRebuild);
    }
  }

  initListeners([bool watchRebuild = false]) {
    debugPrint('Initializing Listeners;... Initialized = $initialized');
    // listen for individual changes in listeners
    subscribeToEvents();
    initialized = true;
  }

  @override
  Widget build(BuildContext context) {
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
    debugPrint('Listen for update called');
    if (mounted) setState(() {});
  }

  listenForRebuild() {
    debugPrint('Listener for Rebuild called');

    /// unsubscribe from the old object
    unsubscribeFromEvents();

    /// resubscribe by setting this to 'false'
    /// the resubscription will be taken care of in [didChangeDependencies()]
    initialized = false;
  }
}
