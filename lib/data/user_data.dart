import 'package:uuid/uuid.dart';
import 'dart:math';
import 'package:flutter/material.dart';

Color getRandomColor() {
  final Random random = Random();
  return Color.fromARGB(
    255, // fully opaque
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}


class UserData {
  final String id;
  final Color color;
  final String email;
  final String password;
  final String username;
  final List<String> followers;
  final List<String> following;

  UserData({
    String? id,
    Color? color,
    required this.email,
    required this.password,
    required this.username,
    List<String>? followers,
    List<String>? following,
  }) : id = id ?? Uuid().v4(), color = color ?? getRandomColor(), followers = followers ?? [], following = following ?? [];

  UserData copyWith({
    List<String>? followers,
    List<String>? following,
  }) => UserData(
    id: id,
    color: color,
    email: email,
    password: password,
    username: username,
    followers: followers ?? this.followers,
    following: following ?? this.following,
  );
}