import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:Bankin/models/user.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:http/http.dart' as http;

import 'package:Bankin/models/receipts.dart';

import 'widgets/result.dart';

class Accounts extends StatefulWidget {
  final User user;

  Accounts(this.user);
  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  List<Receipts> _receipts;
  final http.Client _client = http.Client();
  var _url =
      "https://ajexrc4gb4.execute-api.eu-west-2.amazonaws.com/dev/user/receipts";
  final _storeController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  bool _postSuccess = false;
  Map<String, String> _headers;

  @override
  void initState() {
    super.initState();
    _headers = {
      'Authorization': widget.user.token,
    };
    getReceipts();
  }

  @override
  void dispose() {
    _client.close();
    _storeController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> getReceipts() async {
    final response = await _client.get(_url, headers: _headers);
    if (response.body.isNotEmpty) {
      final jsonResponse = json.decode(response.body);

      List<Receipts> tmpList = List();

      if (jsonResponse == null ||
          jsonResponse['result'] == null ||
          jsonResponse['result']['Items'] == null) return;
      for (int i = 0;
          jsonResponse['result']['Items'] != null &&
              i < jsonResponse['result']['Items'].length;
          ++i) {
        tmpList.add(Receipts.fromJson(jsonResponse['result']['Items'][i]));
      }
      setState(() {
        _receipts = tmpList;
      });
    } else {
      return;
    }
  }

  Future<void> postReceipts(Receipts receipt) async {
    var response = await _client.post(
      _url,
      headers: _headers,
      body: {
        'store': receipt.store,
        'price': receipt.price.toString(),
        'category': receipt.category
      },
    );
    if (response.statusCode != 200) {
      print(response.body);
    }
    _postSuccess = true;
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
      content: ListView(
        shrinkWrap: true,
        children: [
          TextField(
            controller: _storeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Store',
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _categoryController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Category',
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _priceController,
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
          onPressed: () {
            Receipts newReceipt = Receipts(
                store: _storeController.text,
                category: _categoryController.text,
                price: double.parse(_priceController.text));
            postReceipts(newReceipt);
            _clearControllers();
            Navigator.pop(context, _postSuccess ? newReceipt : null);
          },
          child: Text('SAVE'),
        ),
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          color: Colors.red,
          onPressed: () {
            _clearControllers();
            Navigator.pop(context);
          },
          child: Text('CANCEL'),
        ),
      ],
    );
  }

  _clearControllers() {
    _storeController.clear();
    _categoryController.clear();
    _priceController.clear();
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
                context: context,
                builder: (context) => addDialog());
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Text(text, style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  int _getTotal() {
    double res = 0;
    for (int i = 0; _receipts != null && i < _receipts.length; ++i) {
      res += _receipts[i].price.toDouble();
    }
    return res.truncate();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: Center(),
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
              Text('Spent: ' + _getTotal().toString() + '\$',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
