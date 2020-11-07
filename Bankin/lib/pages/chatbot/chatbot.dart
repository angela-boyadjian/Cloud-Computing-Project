import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

import 'package:Bankin/models/user.dart';
import 'package:Bankin/models/chatbot.dart';
import 'package:provider/provider.dart';

import 'widgets/chat_message.dart';

class ChatBot extends StatefulWidget {
  ChatBot();
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  String _botResponse;
  Map<String, String> _body;
  final http.Client _client = http.Client();
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  Future<void> sendMsgToBot(message) async {
    var user = Provider.of<User>(context, listen: false);

    _body = {
      "name": "BudgetBud",
      "alias": "\$LATEST",
      "inputText": message,
      "userId": user.cognitoUser.getUsername(),
    };
    _body['inputText'] = message;
    var response = await _client.post(DotEnv().env['URL_CHATBOT'],
        headers: {
          'Authorization': user.token,
        },
        body: jsonEncode(_body));
    final jsonResponse = json.decode(response.body);
    _botResponse = ChatBotResponse.fromJson(jsonResponse).message;
  }

  void _handleSubmitted(String text) {
    var user = Provider.of<User>(context, listen: false);
    ChatMessage message = ChatMessage(
      text: text,
      name: user.cognitoUser.getUsername(),
      type: true,
    );
    _textController.clear();
    setState(() {
      _messages.insert(0, message);
    });
    response(text);
  }

  void response(query) async {
    await sendMsgToBot(query);
    ChatMessage message = ChatMessage(
      text: _botResponse,
      name: "Bot",
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
    _textController.clear();
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: TextField(
                  controller: _textController,
                  // onSubmitted: () _handleSubmitted,
                  decoration:
                      InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: Container(),
        title: Text("Chatbot"),
        centerTitle: true,
      ),
      body: Column(children: <Widget>[
        Flexible(
          child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
          ),
        ),
        Divider(height: 1.0),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}
