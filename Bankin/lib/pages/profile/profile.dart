import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:Bankin/models/user.dart';
import 'package:Bankin/utils/route_manager.dart';

class Profile extends StatefulWidget {
  final User user;

  Profile(this.user);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _animation = 'success';

  @override
  void initState() {
    super.initState();
  }

  Widget _profileInfos() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // '' != null
        //     ? CircleAvatar(
        //         radius: 50.0,
        //         backgroundColor: Colors.grey,
        //         backgroundImage:
        //             CachedNetworkImageProvider(null),
        //       ) :
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: CircleAvatar(
            radius: 60.0,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            backgroundColor: Colors.transparent,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 200.0),
          child: Text(widget.user.username,
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
                    .showProfileEdit(context);
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
