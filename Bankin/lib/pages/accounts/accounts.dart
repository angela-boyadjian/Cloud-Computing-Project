import 'package:Bankin/pages/accounts/widgets/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:http/http.dart' as http;
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import 'utils/receipts.dart';

class Accounts extends StatefulWidget {
  final CognitoIdToken idToken;

  Accounts(this.idToken);
  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  List<Receipts> _receipts;
  final http.Client _client = http.Client();
  var _url =
      'https://gwdz2qxtl2.execute-api.eu-west-2.amazonaws.com/dev/user/receipts';
  Map<String, String> _headers;

  @override
  void initState() {
    super.initState();
    // _headers = {
    //   'Authorization': widget.idToken.getJwtToken(),
    // };
    // getReceipts();
    _buildLists();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  Future<void> getReceipts() async {
    var response = await http.get(_url, headers: _headers);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  _buildLists() {
    List<Receipts> tmpReceipts = List();
    tmpReceipts.add(Receipts('Monoprix', 'Grocery', "74.2"));
    tmpReceipts.add(Receipts('Amazon', 'Shopping', "30"));
    tmpReceipts.add(Receipts('Engie', 'Bills', "150"));
    tmpReceipts.add(Receipts('RATP', 'Transport', "1.9"));
    tmpReceipts.add(Receipts('Steam', 'Entertainment', "59.99"));
    tmpReceipts.add(Receipts('Deliveroo', 'Food', "15"));
    // var tmpList = await db.getProfessionals(); // TODO Get receipts call db

    // for (int i = 0; i < tmpList.length; ++i) {
    //     tmpReceipts.add(tmpList[i]);
    // }
    setState(() {
      _receipts = tmpReceipts;
    });

    // displayList(_receipts);
  }

  displayList(List toDisplay) {
    for (int i = 0; i < toDisplay.length; ++i) {
      print(toDisplay[i]);
    }
  }

  Future<void> postReceipts() async {
    var response = await _client.post(
      _url,
      headers: _headers,
      body: {'store': 'Monoprix', 'price': '10', 'category': 'Grocery'},
    );
    if (response.statusCode != 200) {
      print('Error: ' + response.toString());
    }
  }

  void postIncome() {
    return;
  }

  buildCorrectList(List<Receipts> toDisplay) {
    return Container(
        child: toDisplay != null
            ? ListView.builder(
                itemCount: toDisplay.length,
                itemBuilder: (context, int idx) {
                  return Result(toDisplay[idx]);
                },
              )
            : SpinKitFadingCube(
                color: Colors.deepPurple,
                size: 50.0,
              ));
  }

  Widget addDialog() {
    return AlertDialog(
      title: Text('Add expense'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            obscureText: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Store',
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            obscureText: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Category',
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            obscureText: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Price',
            ),
          )
        ],
      ),
      actions: [
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          color: Colors.green,
          onPressed: () => Navigator.pop(context),
          child: Text('SAVE'),
        ),
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          color: Colors.red,
          onPressed: () => Navigator.pop(context),
          child: Text('CANCEL'),
        ),
      ],
    );
  }

  Widget addButton(String text, Function onPressedFunc) {
    return ButtonTheme(
      minWidth: double.infinity,
      height: 50.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.blue)),
          onPressed: () {
            showDialog<void>(
                context: context, builder: (context) => addDialog());
            // onPressedFunc();
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Text(text, style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.orange,
          title: Text('Account', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text('Expenses'),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text('Income'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(children: <Widget>[
              addButton('Add receipt', postReceipts),
              Expanded(child: buildCorrectList(_receipts)),
            ]),
            Column(children: <Widget>[
              addButton('Add income', postIncome),
            ]),
          ],
        ),
      ),
    );
  }
}
