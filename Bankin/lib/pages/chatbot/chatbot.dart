import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:Bankin/models/user.dart';

import 'widgets/chat_message.dart';

class ChatBot extends StatefulWidget {
  final User user;

  ChatBot(this.user);
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final http.Client _client = http.Client();
  final String _url =
      "https://gwdz2qxtl2.execute-api.eu-west-2.amazonaws.com/dev/chatbot/setBudget";
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initChatBot();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  Future<void> initChatBot() async {
    var response = await _client.post(
      _url,
      headers: {
        'Authorization': widget.user.token,
      },
      body: {
        "name": "BudgetBud",
        "alias": "First",
        "inputText": "set a budget of 60 for family",
        "userId": "AngelaB",
      },
    );
    print('RESPONSE BODY: ' + response.body);
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      name: widget.user.cognitoUser.getUsername(),
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    response(text);
  }

  void response(query) async {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: 'Hi! How may I help you?',
      name: "Bot",
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
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
                  onSubmitted: _handleSubmitted,
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
        )),
        Divider(height: 1.0),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}
