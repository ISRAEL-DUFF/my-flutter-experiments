import 'package:flutter/material.dart';
import 'package:trouter/inherited_widgets/provider.dart';
import 'dart:math';

class MyData1 extends TDataNotifier {
  int a = 1;
  int b = 2;
  String c = 'C';

  updateA(int newA) {
    a = newA;
    // updateState();
    notifyListeners();
  }
}

class MyData2 extends TDataNotifier {
  int nuum = 1;
  String c = 'C';

  updateName(String name) {
    c = name;
    // updateState();
    notifyListeners();
  }
}

class SomeModel extends ChangeNotifier {
  int id = 1;
  String label = 'C';

  randomUpdate() {
    id = Random().nextInt(500);
    notifyListeners();
  }
}

class SomeOtherModel extends ChangeNotifier {
  int id = 1;
  randomUpdate() {
    id = Random().nextInt(500);
    notifyListeners();
  }
}

class AccountInfo extends TDataNotifier {
  int staffId = 0;
  String accountNum = 'ACCT';
  String accountName = '';
  int balance = 200;

  setName(String name) {
    accountName = name;
    // notifyListeners();
  }

  setAccount(String n) {
    accountNum = n;
    notifyListeners();
  }
}
