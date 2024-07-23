import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class ChatGptPage extends StatefulWidget {
  @override
  _ChatGptPageState createState() => _ChatGptPageState();
}

class _ChatGptPageState extends State<ChatGptPage> {
  final List<types.Message> _messages = [];
  final types.User _user = types.User(id: 'user');
  final types.User _chatGpt = types.User(id: 'chatgpt');
  final TextEditingController _controller = TextEditingController();
  final Dio _dio = Dio();
  final String _apiKey = 'YOUR_OPENAI_API_KEY'; // 替换为你的API密钥

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: Uuid().v4(),
      text: message.text,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });

    final response = await _sendToChatGpt(message.text);

    final gptMessage = types.TextMessage(
      author: _chatGpt,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: Uuid().v4(),
      text: response,
    );

    setState(() {
      _messages.insert(0, gptMessage);
    });
  }

  Future<String> _sendToChatGpt(String message) async {
    final response = await _dio.post(
      'https://api.openai.com/v1/engines/davinci-codex/completions',
      options: Options(
        headers: {
          'Authorization': 'Bearer $_apiKey',
        },
      ),
      data: {
        'prompt': message,
        'max_tokens': 150,
        'temperature': 0.7,
        'top_p': 1.0,
        'frequency_penalty': 0.0,
        'presence_penalty': 0.0,
      },
    );

    if (response.statusCode == 200) {
      return response.data['choices'][0]['text'].trim();
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI答疑'),
      ),
      body: Column(
        children: [
          Expanded(
            child: chat_ui.Chat(
              messages: _messages,
              onSendPressed: _handleSendPressed,
              user: _user,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '输入消息...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _handleSendPressed(types.PartialText(text: _controller.text));
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
