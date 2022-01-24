import 'package:flutter/material.dart';
import '../inherited_widgets/grael.dart';
import '../model.dart';
import 'dart:math';

class DemoMultiListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          TListenable<SomeOtherModel>(),
        ],
        builder: (context, find, _) {
          /// the [find] fn works same as context.find except that it can only
          /// find values you are currently listening on
          /// NOTE: if all the values you are listening on are already provided,
          /// then ignore the find and use context.find context.find instead
          AccountInfo accountInfo = find<AccountInfo>()!;
          SomeModel someModel = find<SomeModel>()!;

          // OR find values you provided globally
          MyData1? l1 = context.find<MyData1>();
          MyData2? d2 = context.find<MyData2>()!;
          SomeOtherModel someOtherModel = context.find<SomeOtherModel>()!;

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
                Container(
                    child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          someModel.randomUpdate();
                          someOtherModel.randomUpdate();
                        },
                        child: Text('Random Update')),
                    Row(
                      children: [
                        Text(
                            'Some Model ID: ${someModel.id}, OtherModel ID: ${someOtherModel.id} '),
                        // Text('Account Number: ${}'),
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
