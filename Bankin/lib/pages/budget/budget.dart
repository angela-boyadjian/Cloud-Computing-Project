import 'package:flutter/material.dart';

class Budget extends StatefulWidget {
  Budget();
  @override
  _BudgetState createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "BUDGET",
        style: TextStyle(
            color: Colors.green, fontSize: 25.0, fontFamily: "WorkSansBold"),
      ),
    );
  }
}