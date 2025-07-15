import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../data/user_data.dart';
import '../providers/message_provider.dart';
import '../providers/follow_provider.dart';

class PersonDetailScreen extends ConsumerStatefulWidget {
  PersonDetailScreen({super.key, required this.userId});
  final String userId;

  @override
  ConsumerState<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends ConsumerState<PersonDetailScreen> {
  UserData? userData;
  @override
  Widget build(BuildContext context) {
    userData = ref
        .watch(userDataProvider)!
        .where((user) => user.id == widget.userId)
        .first;
    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 2, child: _TopPortion(userId: widget.userId)),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    userData!.username,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!userData!.followers.contains(widget.userId))
                        FloatingActionButton.extended(
                          onPressed: () {
                            // get user frim userDataProvider
                            final user = ref
                                .watch(userDataProvider)!
                                .where((user) => user.id == widget.userId)
                                .first;

                            ref
                                .read(followProvider.notifier)
                                .followUser(user.id, user);
                          },
                          heroTag: 'follow',
                          elevation: 0,
                          label: const Text("Follow"),
                          icon: const Icon(Icons.person_add_alt_1),
                        ),
                      if (userData!.followers.contains(widget.userId))
                        FloatingActionButton.extended(
                          onPressed: () {
                            ref
                                .read(followProvider.notifier)
                                .unfollowUser(widget.userId, userData!);
                          },
                          heroTag: 'unfollow',
                          elevation: 0,
                          label: const Text("Unfollow"),
                          icon: const Icon(Icons.person_remove_alt_1),
                        ),

                      const SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'mesage',
                        elevation: 0,
                        backgroundColor: Colors.red,
                        label: const Text("Message"),
                        icon: const Icon(Icons.message_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ProfileInfoRow(userId: widget.userId),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends ConsumerWidget {
  const _ProfileInfoRow({required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(followProvider).firstOrNull;
    
    final items = [
      ProfileInfoItem(
        "Comments",
        ref
            .watch(messageProvider)
            .where((message) => message.senderId == userId)
            .length,
      ),
      ProfileInfoItem("Followers", userData?.followers.length ?? 0),
      ProfileInfoItem("Following", userData?.following.length ?? 0),
    ];
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items
            .map(
              (item) => Expanded(
                child: Row(
                  children: [
                    if (items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          item.value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      Text(item.title, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends ConsumerWidget {
  const _TopPortion({required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref
        .watch(userDataProvider)!
        .where((user) => user.id == userId)
        .first;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 159, 113, 197),
                Color.fromARGB(255, 48, 33, 134),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: userData.color,
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
