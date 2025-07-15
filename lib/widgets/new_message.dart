import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/message_provider.dart';
import '../data/message.dart';

class NewMessage extends ConsumerStatefulWidget {
  const NewMessage({super.key, required this.senderId});
  final String senderId;

  @override
  ConsumerState<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends ConsumerState<NewMessage> {
  var _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }
    ref.read(messageProvider.notifier).addMessage(Message(text: enteredMessage, senderId: widget.senderId, createdAt: DateTime.now()));
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }
}
