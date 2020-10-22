import 'package:flutter/material.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:aws_lex_runtime_api/runtime.lex-2016-11-28.dart';

class ChatBot extends StatefulWidget {
  final CognitoCredentials user;
  ChatBot(this.user);
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final apiGatewayUrl = "https://sdk.amazonaws.com/js/aws-sdk-2.41.0.min.js";

  @override
  void initState() {
    super.initState();
    initChatBot();
  }

  Future<void> initChatBot() async {
    // var client = http.Client();
    final service = LexRuntimeService(
        region: 'eu-west-2_kT5EeqP0M',
        credentials: AwsClientCredentials(
            secretKey: widget.user.secretAccessKey,
            accessKey: widget.user.accessKeyId,
            sessionToken: widget.user.sessionToken));
    final response = await service.postText(
        botAlias: "\$LATEST",
        botName: "BudgetBud",
        inputText: "set a budget of 60 for family",
        userId: "5loolat0v6rftppvpasmg89b5a");
    print(response);
    // try {
    //   var response = await client.post(apiGatewayUrl, body: {'message': 'set budget 40 for family'});
    //   print('Response status: ${response.statusCode}');
    //   print('Response body: ${response.body}');
    // } finally {
    //   client.close();
    // }
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
