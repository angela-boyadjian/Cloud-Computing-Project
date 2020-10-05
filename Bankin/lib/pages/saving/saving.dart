import 'package:flutter/material.dart';

class Saving extends StatefulWidget {
  Saving();
  @override
  _SavingState createState() => _SavingState();
}

class _SavingState extends State<Saving> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "SAVING",
        style: TextStyle(
            color: Colors.red, fontSize: 25.0, fontFamily: "WorkSansBold"),
      ),
    );
  }
}