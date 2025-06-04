import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.exit_to_app,color: Theme.of(context).primaryColor,))
        ],
      ),
      body: Center(
        child: const Text('Logged in!'),
      ),
    );
  }
}
