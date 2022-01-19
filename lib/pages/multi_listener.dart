import 'package:flutter/material.dart';
import '../inherited_widgets/provider.dart';
import '../model.dart';
import 'dart:math';

class DemoMultiListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data1 = TProvider.of<MyData1>(context)!;
    var data2 = TProvider.of<MyData2>(context)!;

    // Multiple listeners
    return TMultiListenableBuilder(
        values: [
          TListenable<MyData1>(
            listener: data1,
          ),
          TListenable<MyData2>(
            listener: data2,
          ),
        ],
        builder: (context, find, _) {
          return Center(
            child: Column(
              children: [
                Text('******** Multiple Builder ******'),
                Container(
                    child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          int a = Random().nextInt(500);
                          // data1.data.updateA(a);
                          MyData1? l = find<MyData1>();
                          l!.updateA(a);
                        },
                        child: Text('Update Multiple 1')),
                    Text('Data 5: ${data1.a}'),
                  ],
                )),
                Container(
                    child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          int a = Random().nextInt(500);
                          data2.updateName('String: ' + a.toString());
                        },
                        child: Text('Update Multiple')),
                    Text('Data 4: ${data2.c}'),
                  ],
                )),
                Text('******** End Multiple ******'),
              ],
            ),
          );
        });
  }
}
