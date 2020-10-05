import 'package:flutter/material.dart';

class Coaching extends StatefulWidget {
  Coaching();
  @override
  _CoachingState createState() => _CoachingState();
}

class _CoachingState extends State<Coaching> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "COACH",
        style: TextStyle(
            color: Colors.grey, fontSize: 25.0, fontFamily: "WorkSansBold"),
      ),
    );
  }
}