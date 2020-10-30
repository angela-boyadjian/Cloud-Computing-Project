import 'dart:io';
import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';

import 'package:Bankin/models/user.dart';
import 'package:image_picker/image_picker.dart';

import 'widgets/avatar.dart';

class ProfileEdit extends StatefulWidget {
  final User user;
  final Map<String, String> attributes;

  ProfileEdit(this.user, this.attributes);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  File _image;

  @override
  void initState() {
    super.initState();
    if (widget.attributes['picture'] != '') _image = File(widget.attributes['picture']);
    _nameController.text = widget.attributes['name'];
    _emailController.text = widget.attributes['email'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final List<CognitoUserAttribute> attributes = [];
    attributes
        .add(CognitoUserAttribute(name: 'name', value: _nameController.text));
    attributes
        .add(CognitoUserAttribute(name: 'email', value: _emailController.text));
    if (_image != null) {
      List<int> imageBytes = _image.readAsBytesSync();
      String base64Image = base64.encode(imageBytes);
      // ignore: todo
      // TODO Upload in S3 and store URL in Cognito
      attributes.add(CognitoUserAttribute(name: 'picture', value: base64Image));
      print('IMG SIZE: ' + base64Image.length.toString());
    }
    try {
      await widget.user.cognitoUser.updateAttributes(attributes);
    } catch (e) {
      print(e);
    }
    Navigator.pop(context);
  }

  Future<void> _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  Future<void> _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

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

  Widget buildTextFields() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
          child: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: GestureDetector(
                child: Avatar(_image),
                onTap: () => _showPicker(context),
              ),
            ),
            buildTextFields(),
            ButtonTheme(
              minWidth: double.infinity,
              height: 50.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.blue)),
                  onPressed: () => _save(),
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Text('SAVE', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
