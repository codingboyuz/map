

import 'dart:convert';

MessageModel messageFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  final String message;

  MessageModel({required this.message});

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      MessageModel(message: json['message']);

  Map<String, dynamic> toJson() => {'message': message};
}
