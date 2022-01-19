import 'package:trouter/inherited_widgets/provider.dart';

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
