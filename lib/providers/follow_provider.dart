import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/user_data.dart';

class FollowProvider extends StateNotifier<List<UserData>> {
  FollowProvider() : super([]);



  void followUser(String userId, UserData currentUser) {
    print('Attempting to follow: userId= [32m$userId [0m, user= [32m$currentUser [0m');
    print('Current state: ${state.length}');
    state = [...state, currentUser.copyWith(followers: [...currentUser.followers, userId])];
    print('Followed. New state: ${state.length}');
  }

  void unfollowUser(String userId, UserData currentUser) {
    print('Attempting to unfollow: userId= [32m$userId [0m, currentUserId= [32m$currentUser [0m');
    state = [...state, currentUser.copyWith(followers: currentUser.followers.where((id) => id != userId).toList())];
    print('Unfollowed. New state: ${state.length}');
  }

  void getFollowers(String userId) {
    print('Getting followers for userId= [32m$userId [0m');
    state = state!.where((user) => user.followers.contains(userId)).toList();
    print('Followers found:');
    for (final user in state!) {
      print('User:  [34m${user.username} [0m');
    }
  }

  void getFollowing(String userId) {
    print('Getting following for userId= [32m$userId [0m');
    state = state!.where((user) => user.following.contains(userId)).toList();
    print('Following found:');
    for (final user in state!) {
      print('User:  [34m${user.username} [0m');
    }
  }
}

final followProvider = StateNotifierProvider<FollowProvider, List<UserData>>(
  (ref) => FollowProvider(),
);
