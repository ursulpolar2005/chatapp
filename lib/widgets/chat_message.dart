import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/message_provider.dart';
import '../providers/user_provider.dart';
import '../screens/persone_detail.dart';
import 'package:intl/intl.dart';

class ChatMessage extends ConsumerStatefulWidget {
  const ChatMessage({super.key});

  @override
  ConsumerState<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends ConsumerState<ChatMessage>
    with TickerProviderStateMixin {

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    // TODO: Implement initState
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'ChatUser',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (ref.watch(messageProvider).isNotEmpty)
            ListView.builder(

              shrinkWrap: true,
              itemCount: ref.watch(messageProvider).length,
              itemBuilder: (ctx, index) {
                final message = ref.watch(messageProvider)[index];
                return Dismissible(
                  key: Key(message.id.toString()),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      ref.read(messageProvider.notifier).editMessage(message.id, message.text);
                    }
                    if (direction == DismissDirection.endToStart) {
                      ref.read(messageProvider.notifier).deleteMessage(message.id);
                    }
                  },
                  background: Container(
                    color: const Color.fromARGB(255, 184, 196, 161), // For startToEnd (left to right)
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Icon(Icons.forward_to_inbox_outlined, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: const Color.fromARGB(255, 202, 75, 66), // For endToStart (right to left)
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    leading: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      splashColor: const Color.fromARGB(120, 160, 54, 54),
                      highlightColor: const Color.fromARGB(0, 104, 31, 31),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => PersonDetailScreen(
                              userId: ref.watch(messageProvider)[index].senderId,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: ref
                            .watch(userDataProvider)!
                            .where(
                              (user) =>
                                  user.id ==
                                  ref.watch(messageProvider)[index].senderId,
                            )
                            .first
                            .color,
                        child: Text(
                          ref
                              .watch(userDataProvider)!
                              .where(
                                (user) =>
                                    user.id ==
                                    ref.watch(messageProvider)[index].senderId,
                              )
                              .first
                              .username
                              .substring(0, 2)
                              .toUpperCase(),
                        ),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ref
                                  .watch(userDataProvider)!
                                  .where(
                                    (user) =>
                                        user.id ==
                                        ref.watch(messageProvider)[index].senderId,
                                  )
                                  .first
                                  .username,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,

                                color: ref
                                    .watch(userDataProvider)!
                                    .where(
                                      (user) =>
                                          user.id ==
                                          ref
                                              .watch(messageProvider)[index]
                                              .senderId,
                                    )
                                    .first
                                    .color,
                              ),
                            ),
                            Text(
                              DateFormat(
                                'dd.MM.yyyy HH:mm',
                              ).format(ref.watch(messageProvider)[index].createdAt),
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),

                        Text(
                          ref.watch(messageProvider)[index].text,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
