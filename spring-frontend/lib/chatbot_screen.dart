import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
      ),
      dark: ThemeData.dark(),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Chat App',
        theme: theme,
        darkTheme: darkTheme,
        home: ChatScreen(),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _addInitialMessages();
  }

  void _addInitialMessages() {
    _messages.add(ChatMessage(text: "Hello there!", isMe: false));
    _messages.add(ChatMessage(text: "Hi! How can I help you?", isMe: true));
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    _sendMessage(text);
  }

  void _sendMessage(String text) {
    ChatMessage message = ChatMessage(
      text: text,
      isMe: true,
      isSending: true,
    );
    setState(() {
      _messages.insert(0, message);
    });

    // Simulate receiving a response after 1 second
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _messages.insert(0, ChatMessage(text: "Got it!", isMe: false));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _messages[index],
            ),
          ),
          Divider(height: 1.0),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                onSubmitted: _isComposing ? _handleSubmitted : null,
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message', 
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: _isComposing ? () => _handleSubmitted(_textController.text) : null,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({required this.text, required this.isMe, this.isSending = false});

  final String text;
  final bool isMe;
  final bool isSending;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final double radius = 10.0;

    Color? backgroundColor = isMe ? Color(0xFF2196F3) : Color.fromARGB(255, 255, 255, 255);
    Color textColor = isMe ? Colors.white : Colors.black;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!isMe) ...[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                child: Text('A'),
                backgroundColor: Color(0xFF1976D2),
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMe ? radius : 0.0),
                  topRight: Radius.circular(isMe ? 0.0 : radius),
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        text,
                        style: TextStyle(color: textColor, fontSize: 16.0),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        '12:34 PM',
                        style: TextStyle(
                          color: textColor.withAlpha(180),
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  if (isSending) CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}