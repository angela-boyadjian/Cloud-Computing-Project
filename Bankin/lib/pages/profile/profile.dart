import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import 'package:Bankin/models/user.dart';
import 'package:Bankin/utils/route_manager.dart';

import 'widgets/avatar.dart';

class Profile extends StatefulWidget {
  Profile();
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, String> _attributes = {
    'name': '',
    'email': '',
    'picture': '',
  };

  @override
  void initState() {
    super.initState();
    getAttributes();
  }

  Future<void> getAttributes() async {
    var user = Provider.of<User>(context);

    List<CognitoUserAttribute> attributes;
    Map<String, String> tmp = _attributes;
    try {
      attributes = await user.cognitoUser.getUserAttributes();
      attributes.forEach((attribute) {
        if (tmp.containsKey(attribute.getName())) {
          tmp[attribute.getName()] = attribute.getValue();
        }
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      _attributes = tmp;
    });
  }

  Widget _profileInfos() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Avatar(_attributes['picture'] == '' ? null : File(_attributes['picture'])),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Text(_attributes['name'],
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0)),
          ),
        ),
        ButtonTheme(
          minWidth: double.infinity,
          height: 40.0,
          child: Padding(
            padding: const EdgeInsets.only(top: 150.0, bottom: 50.0, left: 20.0, right: 20.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              onPressed: () {
                Provider.of<RouteManager>(context, listen: false)
                    .showProfileEdit(context, _attributes);
              },
              color: Colors.orange,
              textColor: Colors.white,
              child: Text('EDIT', style: TextStyle(fontSize: 18)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: Container(),
            centerTitle: true,
            backgroundColor: Colors.orange,
            title:
                Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          body: _profileInfos(),
        ),
      ],
    );
  }
}
