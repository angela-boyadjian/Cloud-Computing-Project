import 'dart:io';

import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final File image;

  const Avatar(this.image);

  @override
  Widget build(BuildContext context) {
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
    // return avatar != ''
    //     ? Padding(
    //         padding: const EdgeInsets.only(top: 20.0),
    //         child: CircleAvatar(
    //           radius: 60.0,
    //           backgroundColor: Colors.grey,
    //           backgroundImage:
    //               CachedNetworkImageProvider(avatar),
    //         ),
    //       )
    //     : Padding(
    //         padding: const EdgeInsets.only(top: 20.0),
    //         child: CircleAvatar(
    //           radius: 60.0,
    //           backgroundImage: NetworkImage('https://via.placeholder.com/150'),
    //           backgroundColor: Colors.transparent,
    //         ),
    //       );
  }
}
