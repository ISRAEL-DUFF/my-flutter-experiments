import 'package:flutter/material.dart';
import './cashly/theme.dart';
import './cashly/buttons.dart';
import './inherited_widgets/provider.dart';
import './model.dart';
import 'dart:math';

import './pages/page_one.dart';
import './pages/single_listener.dart';
import './pages/multi_listener.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return TMultiprovider(
        providers: [
          TProvider<int>(data: 5),
          TProvider<MyData1>(data: MyData1()),
          TProvider<MyData2>(data: MyData2()),
          TProvider<String>(data: 'Heelo Wrold')
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
    var stat = TProvider.of<int>(context)!;
    var data1 = TProvider.of<MyData1>(context)!;
    var data2 = TProvider.of<MyData2>(context)!;
    int d = stat;
    return Scaffold(
      // appBar: AppBar(title: Text('Cashly App')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Testing Inhrited widget: ${data2.c}')),
          Center(child: Text(d.toString())),
          ElevatedButton(
              onPressed: () {
                int a = Random().nextInt(500);
                // stat.updateData(a);
                data1.updateA(a);
              },
              child: Text('Update value')),
          // PlayState(),

          DemoMultiListener(),
          PlayState(),
          DemoSingleListener()
        ],
      ),
    );
  }
}
