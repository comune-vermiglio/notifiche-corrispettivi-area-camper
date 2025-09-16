import 'dart:io';

import 'package:equatable/equatable.dart';

class Config extends Equatable {
  final String serverPassword;
  final InternetAddress serverAddress;
  final String senderName;
  final String senderEmail;
  final String senderPassword;
  final List<String> recipientEmails;

  const Config({
    required this.serverPassword,
    required this.serverAddress,
    required this.senderEmail,
    required this.senderName,
    required this.senderPassword,
    required this.recipientEmails,
  });

  static Config fromJson(Map<String, dynamic> json) {
    return Config(
      serverPassword: json['serverPassword'],
      serverAddress: InternetAddress(json['serverAddress']),
      senderName: json['senderName'],
      senderEmail: json['senderEmail'],
      senderPassword: json['senderPassword'],
      recipientEmails: json['recipientEmails'].cast<String>(),
    );
  }

  @override
  List<Object?> get props => [
    serverAddress,
    serverPassword,
    senderName,
    senderEmail,
    senderPassword,
    recipientEmails,
  ];
}
