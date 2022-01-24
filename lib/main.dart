import 'package:flutter/material.dart';
import './cashly/theme.dart';
import './cashly/buttons.dart';
import './inherited_widgets/provider.dart';
import './inherited_widgets/grael.dart';
import './model.dart';
import 'dart:math';

import './pages/page_one.dart';
import './pages/single_listener.dart';
import './pages/multi_listener.dart';

void main() {
  StateProvider.initializeState(
    (sl) async {
      return await sl.registerLazySingletonP(() => MyData1());
    },
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return TMultiprovider(
        providers: [
          TProvider(create: (_) => MyData2()),
          // TProvider(
          //   create: (_) => MyData1(),
          // )
          TProvider(
            create: (_) => SomeOtherModel(),
          )
        ],
        child: MaterialApp(
          title: 'Trouter',
          color: CashlyThemeData.accentColor.withOpacity(1),
          theme: CashlyThemeData.themeData(),
          home: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data1 = TProvider.of<MyData1>(context)!;
    var data2 = TProvider.of<MyData2>(context)!;
    return Scaffold(
      // appBar: AppBar(title: Text('Cashly App')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Testing Inhrited widget: ${data2.c}')),
          ElevatedButton(
              onPressed: () {
                // int a = Random().nextInt(500);
                // data1.updateA(a);
                context.refresh<MyData1>();
              },
              child: Text('Reset Value')),
          // PlayState(),

          DemoMultiListener(),
          PlayState(),
          DemoSingleListener()
        ],
      ),
    );
  }
}
