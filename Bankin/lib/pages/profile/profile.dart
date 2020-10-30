import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import 'package:Bankin/models/user.dart';
import 'package:Bankin/utils/route_manager.dart';

import 'widgets/avatar.dart';

class Profile extends StatefulWidget {
  final User user;

  Profile(this.user);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _animation = 'success';
  Map<String, String> _attributes = {
    'name': '',
    'email': '',
    'avatar': '',
  };

  @override
  void initState() {
    super.initState();
    getAttributes();
  }

  Future<void> getAttributes() async {
    List<CognitoUserAttribute> attributes;
    Map<String, String> tmp = _attributes;
    try {
      attributes = await widget.user.cognitoUser.getUserAttributes();
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Avatar(_attributes['avatar']),
        Padding(
          padding: const EdgeInsets.only(bottom: 200.0),
          child: Text(_attributes['name'],
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0)),
        ),
        ButtonTheme(
          minWidth: double.infinity,
          height: 40.0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              onPressed: () {
                Provider.of<RouteManager>(context, listen: false)
                    .showProfileEdit(context, widget.user, _attributes);
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
        FlareCacheBuilder(
          ["assets/animations/ranking_bg.flr"],
          builder: (context, bool isWarm) {
            return isWarm == false
                ? Container(color: Colors.black)
                : FlareActor("assets/animations/ranking_bg.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: _animation, callback: (string) {
                    if (_animation == 'success') _animation = 'go';
                  });
          },
        ),
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
