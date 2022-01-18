import 'package:flutter/material.dart';
import './theme.dart';

class CashlyFilledBtn extends StatelessWidget {
  final Function()? onTap;
  final Color? color;
  final Widget? child;
  bool outline;

  final radius = 10.0;
  final width = 200.0;
  final height = 55.0;

  CashlyFilledBtn(
      {Key? key, this.onTap, this.color, this.child, this.outline = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width + 10,
      height: height + 5,
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      // color: Colors.white,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          border: Border.all(color: Colors.purple),
          color: Colors.white30),
      child: ElevatedButton(
        child: child!,
        onPressed: onTap,
        autofocus: false,
        clipBehavior: Clip.none,
        style: ElevatedButton.styleFrom(
            primary: outline ? Colors.white : CashlyThemeData.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius)),
            onPrimary: outline ? CashlyThemeData.primaryColor : Colors.white,
            fixedSize: Size(width, height),
            textStyle: TextStyle(
                color: outline
                    ? CashlyThemeData.primaryColor
                    : CashlyThemeData.textColor,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class CashlyFilledTextField extends StatelessWidget {
  String? hintText;
  String label;
  CashlyFilledTextField({this.hintText, @required this.label = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(
          height: 10,
        ),
        _buildField()
      ],
    );
  }

  Widget _buildField() {
    return Container(
      width: 300,
      height: 100,
      child: TextField(
        decoration: InputDecoration(
            hintText: hintText,
            // label: Text('My Label'),
            hintStyle: TextStyle(color: Colors.grey),
            fillColor: Colors.grey[100],
            filled: true,
            // focusedBorder: ,
            focusColor: Colors.red,
            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200]!, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    );
  }
}
