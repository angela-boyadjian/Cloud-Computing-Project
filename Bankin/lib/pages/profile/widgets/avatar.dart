import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

class Avatar extends StatelessWidget {
  final String avatar;

  const Avatar(this.avatar);

  @override
  Widget build(BuildContext context) {
    return avatar != ''
        ? Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: CircleAvatar(
              radius: 60.0,
              backgroundColor: Colors.grey,
              backgroundImage:
                  CachedNetworkImageProvider(avatar),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: CircleAvatar(
              radius: 60.0,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
              backgroundColor: Colors.transparent,
            ),
          );
  }
}
