import 'dart:io';

import 'package:Bankin/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Avatar extends StatelessWidget {
  final File image;

  const Avatar(this.image);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context, listen: false);
    final String url = user.picture;
    if (image == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: CircleAvatar(
          radius: 80.0,
          backgroundImage: NetworkImage(url),
          backgroundColor: Colors.transparent,
        ),
      );
    }
    return CircleAvatar(
      radius: 80,
      backgroundColor: Colors.grey,
      child: image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child:
                  Image.file(image, width: 200, height: 200, fit: BoxFit.fill),
            )
          : Container(
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(80)),
              width: 200,
              height: 200,
              child: Icon(
                Icons.camera_alt,
                size: 50.0,
                color: Colors.orange[800],
              ),
            ),
    );
  }
}
