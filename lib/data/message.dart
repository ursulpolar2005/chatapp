   import 'package:uuid/uuid.dart';

   class Message {
     final String id;
     final String text;
     final String senderId;
     final DateTime createdAt;

     Message({
       String? id,  
       required this.text,
       required this.senderId,
       required this.createdAt,
     }) : id = id ?? Uuid().v4();
   }