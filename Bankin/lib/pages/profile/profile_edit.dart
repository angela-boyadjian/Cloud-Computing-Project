import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileEdit extends StatefulWidget {
  ProfileEdit();
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
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
      actions: <Widget>[
        IconButton(
            icon: Icon(FontAwesomeIcons.check),
            iconSize: 25.0,
            onPressed: () => {}),
      ],
      elevation: 0.0,
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
    );
  }
}
