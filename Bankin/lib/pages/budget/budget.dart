import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:Bankin/models/user.dart';
import 'package:Bankin/models/budgets.dart';

import 'package:http/http.dart' as http;
import 'package:flip_card/flip_card.dart';

class Budget extends StatefulWidget {
  final User user;

  Budget(this.user);
  @override
  _BudgetState createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  final http.Client _client = http.Client();
  var _url =
      "https://ajexrc4gb4.execute-api.eu-west-2.amazonaws.com/dev/budgets";
  Map<String, String> _headers;
  List<Budgets> _budgets;

  @override
  initState() {
    super.initState();
    _headers = {
      'Authorization': widget.user.token,
    };
    // postBudget(Budgets(amount: '60', category: "family"));
    getBudgets();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  Future<void> getBudgets() async {
    final response = await _client.get(_url, headers: _headers);
    if (response.body.isNotEmpty) {
      final jsonResponse = json.decode(response.body);

      List<Budgets> tmpList = List();

      if (jsonResponse == null ||
          jsonResponse['result'] == null ||
          jsonResponse['result']['Items'] == null) return;
      for (int i = 0;
          jsonResponse['result']['Items'] != null &&
              i < jsonResponse['result']['Items'].length;
          ++i) {
        tmpList.add(Budgets.fromJson(jsonResponse['result']['Items'][i]));
      }
      setState(() {
        _budgets = tmpList;
      });
    } else {
      return;
    }
  }

  Future<void> postBudget(Budgets budget) async {
    var response = await _client.post(
      _url,
      headers: _headers,
      body: {
        'amount': budget.amount,
        'category': budget.category,
      },
    );
    if (response.statusCode != 200) {
      print(response.body);
    }
    print(response.statusCode);
  }

  _renderContent(BuildContext context, Color color, String category, int total) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 20.0, bottom: 0.0),
      color: Color(0x00000000),
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        speed: 500,
        onFlipDone: (status) {
          print(status);
        },
        front: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(category, style: TextStyle(color: Colors.white, fontSize: 40)),
            ],
          ),
        ),
        back: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('\$' + total.toString(), style: TextStyle(color: Colors.white, fontSize: 40)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: Container(),
        title: Text("Budget"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
            child: _renderContent(context, Colors.blue, _budgets == null ? 'Car' : _budgets[0].category, _budgets == null ? 500 : int.parse(_budgets[0].amount)),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
            child: _renderContent(context, Colors.pink, 'Vacation', 643),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
            child: _renderContent(context, Colors.indigo, 'Saving', 10),
          ),
        ],
      ),
    );
  }
}
