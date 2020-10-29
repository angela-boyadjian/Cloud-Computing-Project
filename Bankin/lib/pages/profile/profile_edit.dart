import 'dart:io';

import 'package:Bankin/utils/route_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

class ProfileEdit extends StatefulWidget {
  ProfileEdit();
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  String avatarUrl = '';

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.orange,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        iconSize: 30.0,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        'Edit',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0.0,
      centerTitle: true,
    );
  }


  callbackUpdateAvatar(String avatar, File file) {
    setState(() {
      avatarUrl = avatar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: <Widget>[
          CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: CachedNetworkImageProvider('url'),
              radius: 75.0),
          Positioned(
            bottom: 1,
            right: 0,
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 5, color: Colors.white),
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: IconButton(
                    icon: Icon(FontAwesomeIcons.edit, size: 28),
                    color: Colors.white,
                    onPressed: () async {
                      var result = await Provider.of<RouteManager>(
                              context,
                              listen: false)
                          .showImageEditor(context,
                              cropStyle: CropStyle.circle,
                              callback: callbackUpdateAvatar,
                              path: "avatar");
                      setState(() {
                        avatarUrl = result.mediaUrl;
                      });
                    })),
          ),
        ],
      ),
    );
  }
}
