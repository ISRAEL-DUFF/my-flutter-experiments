import 'package:flutter/material.dart';
import '../inherited_widgets/provider.dart';
import '../model.dart';
import 'dart:math';

class PlayState extends StatefulWidget {
  Widget? child;
  PlayState({
    Key? key,
  }) : super(key: key);
  @override
  PlayStateS createState() => PlayStateS();
}

class PlayStateS extends State<PlayState> {
  @override
  Widget build(BuildContext context) {
    print('REBUILDING PLAYSTATE');
    return Column(children: [
      TListenableBuilder<MyData1>(
          value: MyData1(),
          builder: (context, data, _) {
            return Column(
              children: [
                Text('******** Play State******'),
                Container(
                    child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          int a = Random().nextInt(500);
                          data.updateA(a);
                        },
                        child: Text('Update 2')),
                    Text('PlayState Data 1: ${data.a}'),
                  ],
                )),
                Text('******** End PlayState ******'),
              ],
            );
          })
    ]);
  }
}
