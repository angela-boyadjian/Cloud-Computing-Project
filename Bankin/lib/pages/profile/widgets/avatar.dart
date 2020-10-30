import 'dart:io';

import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  Avatar({Key key, this.contactImage, this.color, this.onTap})
      : super(key: key);

  final String contactImage;
  final Color color;
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    return new Material(
      child: Center(
        child: new InkWell(
          onTap: onTap,
          child: CircleAvatar(
                  backgroundImage: !contactImage.startsWith("http")
                      ? FileImage(File(contactImage))
                      : NetworkImage(contactImage),
                  radius: 85)
        ),
      ),
    );
  }
}