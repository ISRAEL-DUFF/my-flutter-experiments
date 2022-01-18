import 'package:flutter/material.dart';
import './cashly/theme.dart';
import './cashly/buttons.dart';
import './inherited_widgets/provider.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return TProviderStateWrapper<int>(
    //     data: 6,
    //     child: MaterialApp(
    //       title: 'Trouter',
    //       color: CashlyThemeData.accentColor.withOpacity(1),
    //       theme: CashlyThemeData.themeData(),
    //       home: MyHomePage(),
    //     ));

    return TMultiprovider(
        providers: [
          TProviderStateWrapper<int>(data: 5),
          TProviderStateWrapper<MyData1>(data: MyData1()),
          TProviderStateWrapper<MyData2>(data: MyData2()),
          TProviderStateWrapper<String>(data: 'Heelo Wrold')
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
    int d = stat.data;
    return Scaffold(
      // appBar: AppBar(title: Text('Cashly App')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Testing Inhrited widget: ${data2.data.c}')),
          Center(child: Text(d.toString())),
          ElevatedButton(
              onPressed: () {
                int a = Random().nextInt(500);
                // stat.updateData(a);
                data1.data.updateA(a);
              },
              child: Text('Update value')),
          // PlayState(),

          MyListenableBuilder<MyData1>(
              listener: data1.data,
              builder: (context, data, _) {
                return Container(
                    child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          int a = Random().nextInt(500);
                          data.updateA(a);
                        },
                        child: Text('Update 2')),
                    Text('Data 2: ${data.a}'),
                  ],
                ));
              }),

          MyListenableBuilder<MyData2>(
              listener: data2.data,
              builder: (context, data, _) {
                return Container(
                    child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          int a = Random().nextInt(500);
                          data.updateName('String: ' + a.toString());
                        },
                        child: Text('Update 3')),
                    Text('Data 3: ${data.c}'),
                  ],
                ));
              }),

          // Multiple listeners
          MultiListenableBuilder(
              listeners: [
                TListenable<MyData1>(
                  listener: data1.data,
                ),
                TListenable<MyData2>(
                  listener: data2.data,
                ),
              ],
              builder: (context, _) {
                return Center(
                  child: Column(
                    children: [
                      Text('Multiple builder ready'),
                      Container(
                          child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                int a = Random().nextInt(500);
                                data1.data.updateA(a);
                              },
                              child: Text('Update Multiple 1')),
                          Text('Data 5: ${data1.data.a}'),
                        ],
                      )),
                      Container(
                          child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                int a = Random().nextInt(500);
                                data2.data
                                    .updateName('String: ' + a.toString());
                              },
                              child: Text('Update Multiple')),
                          Text('Data 4: ${data2.data.c}'),
                        ],
                      )),
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }
}

class PlayState extends StatefulWidget {
  Widget? child;
  PlayState({
    Key? key,
  }) : super(key: key);
  @override
  PlayStateS createState() => PlayStateS();
}

class PlayStateS extends State<PlayState> {
  // TSubscribe ss = TSubscribe();
  // MyData dd = MyData();
  @override
  Widget build(BuildContext context) {
    // return ValueListenableBuilder<int>(
    //     valueListenable: dd.v,
    //     builder: (context, v, child) {
    //       return child!;
    //     });

    return Column(children: [
      MyListenableBuilder<MyData1>(
          listener: MyData1(),
          builder: (context, data, _) {
            return Container(
                child: Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      int a = Random().nextInt(500);
                      data.updateA(a);
                    },
                    child: Text('Update 2')),
                Text('Data 1: ${data.a}'),
              ],
            ));
          })
    ]);
  }
}
