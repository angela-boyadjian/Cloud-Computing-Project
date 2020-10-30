import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class User {
  final CognitoUser cognitoUser;
  final String token;

  User({this.cognitoUser, this.token});
}