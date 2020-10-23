import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:aws_lex_runtime_api/runtime.lex-2016-11-28.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatBot extends StatefulWidget {
  final CognitoCredentials user;
  final CognitoIdToken idToken;

  ChatBot(this.user, this.idToken);
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  void initState() {
    super.initState();
    initChatBot();
  }

  Future<void> initChatBot() async {
    AwsSigV4Client client = AwsSigV4Client(
      DotEnv().env['ACCESS_KEY'],
      DotEnv().env['SECRET_KEY'],
      'https://runtime.lex.eu-west-2.amazonaws.com',
      region: 'eu-west-2',
      serviceName: 'lex',
      // defaultContentType: 'application/json; charset=utf-8',
    );
    final signedRequest = new SigV4Request(
      client,
      method: 'POST',
      path: '/bot/BudgetBud/alias/First/user/AngelaB/text',
      headers: new Map<String, String>.from({
        'Content-Type': 'application/json; charset=utf-8',
        'ACCEPT': 'application/json',
      }),
      body: new Map<String, dynamic>.from({"inputText": "set a budget of 60 for family"}),
    );

    var response = await http.post(
      signedRequest.url,
      headers: signedRequest.headers,
      body: signedRequest.body,
    );
    print('RESPONSE ===' + response.body);
    // final service = LexRuntimeService(
    //     region: 'eu-west-2_kT5EeqP0M',
    //     credentials: AwsClientCredentials(
    //         secretKey: DotEnv().env['ACCESS_KEY'],
    //         accessKey: DotEnv().env['SECRET_KEY'],
    //         sessionToken: widget.user.sessionToken));
    // final response = await service.postText(
    //     botAlias: "First",
    //     botName: "BudgetBud",
    //     inputText: "set a budget of 60 for family",
    //     userId: "AngelaB");
    // print('RESPONSE === $response');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "CHATBOT",
        style: TextStyle(
            color: Colors.grey, fontSize: 25.0, fontFamily: "WorkSansBold"),
      ),
    );
  }
}
