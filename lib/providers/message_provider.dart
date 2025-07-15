import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/message.dart';

class MessageProvider extends StateNotifier<List<Message>> {
  MessageProvider() : super([]);

  void addMessage(Message message) {
    state = [...state, message];
  }

  void deleteMessage(String id) {
    state = state.where((message) => message.id != id).toList();
  }

  void editMessage(String id, String text) {
    state = state
        .map(
          (m) => m.id == id
              ? Message(
                  id: id,
                  text: text,
                  senderId: m.senderId,
                  createdAt: m.createdAt,
                )
              : m,
        )
        .toList();
  }

}

final messageProvider = StateNotifierProvider<MessageProvider, List<Message>>(
  (ref) => MessageProvider(),
);
