import 'package:flutter/material.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(secondary: Colors.blueAccent),
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];

  void _handleSubmitted(String text) {
    // Simulate sending a message
    ChatMessage message = ChatMessage(
      text: text,
      isMe: true, // Change this to false for incoming messages
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Colors.blue,
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
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: _buildTextComposer(),
          ),
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
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration(
                  hintText: 'Send a message',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(''),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({required this.text, required this.isMe});

  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final double radius = 10.0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              child: Text(isMe ? 'Me' : 'Other'),
              backgroundColor: isMe ? themeData.colorScheme.secondary : Colors.grey[400],
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isMe ? themeData.colorScheme.secondary : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMe ? radius : 0.0),
                  topRight: Radius.circular(isMe ? 0.0 : radius),
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    text,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    '12:34 PM', // Example time, replace with actual time
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
