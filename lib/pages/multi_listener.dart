import 'package:flutter/material.dart';
import '../inherited_widgets/provider.dart';
import '../model.dart';
import 'dart:math';

class DemoMultiListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var data1 = TProvider.of<MyData1>(context)!;
    // var data2 = TProvider.of<MyData2>(context)!;

    // Multiple listeners
    return TMultiListenableBuilder(
        values: [
          TListenable<MyData1>(), // i.e value = TProvider.of<MyData1>(context)
          TListenable<MyData2>(), // same as above
          TListenable<AccountInfo>(
            value: AccountInfo(),
          ),
          TListenable<SomeModel>(
            value: SomeModel(),
          ),
        ],
        builder: (context, find, _) {
          MyData1? l1 = find<MyData1>();
          MyData2? d2 = find<MyData2>()!;
          AccountInfo accountInfo = find<AccountInfo>()!;
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
                          l1!.updateA(a);
                        },
                        child: Text('Update Multiple 1')),
                    Text('Data 5: ${l1!.a}'),
                  ],
                )),
                Container(
                    child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          int a = Random().nextInt(500);
                          d2.updateName('String: ' + a.toString());
                        },
                        child: Text('Update Multiple')),
                    Text('Data 4: ${d2.c}'),
                  ],
                )),
                Container(
                    child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          int a = Random().nextInt(500);
                          accountInfo.setAccount('ACCT-' + a.toString());
                        },
                        child: Text('Change ACCT')),
                    Row(
                      children: [
                        Text('Account Name: ${accountInfo.accountName} '),
                        Text('Account Number: ${accountInfo.accountNum}'),
                      ],
                    ),
                  ],
                )),
                Text('******** End Multiple ******'),
              ],
            ),
          );
        });
  }
}
