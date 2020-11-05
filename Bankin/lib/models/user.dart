import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import 'finances.dart';

class User {
  final CognitoUser cognitoUser;
  final String token;
  final Finances finances;

  User({this.cognitoUser, this.token, this.finances});
}