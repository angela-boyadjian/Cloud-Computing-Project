import 'package:flutter/material.dart';

class Accounts extends StatefulWidget {
  Accounts();
  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "ACCOUNTS",
        style: TextStyle(
            color: Colors.blue, fontSize: 25.0, fontFamily: "WorkSansBold"),
      ),
    );
  }
}
