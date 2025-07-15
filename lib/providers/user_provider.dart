import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/user_data.dart';

class UserDataNotifier extends StateNotifier<List<UserData>?> {
  UserDataNotifier() : super([]);

  

  void saveUserData({
    required String email,
    required String password,
    required String username,
    required BuildContext context,
  }) {
    if (state!.any((user) => user.email == email)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email already exists')));
    }
    if (state!.any((user) => user.username == username)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Username already exists')));
    }


      state = [
        ...state!,
        UserData(email: email, password: password, username: username),
      ];
 
  }

  void clearUserData() {
    state = [];
  }
}

final userDataProvider =
    StateNotifierProvider<UserDataNotifier, List<UserData>?>(
  (ref) => UserDataNotifier(),
);
