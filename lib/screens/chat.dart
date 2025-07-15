import 'package:flutter/material.dart';
import '../screens/auth.dart';
import '../widgets/chat_message.dart';
import '../widgets/new_message.dart';
import '../data/user_data.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.userData});
  final UserData userData;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Buna ${userData.username}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const AuthScreen()));
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ChatMessage()),
          NewMessage(senderId: userData.id),
        ],
      ),
    );
  }
}