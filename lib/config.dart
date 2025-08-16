import 'dart:io';

class Config {
  final String password;
  final InternetAddress serverAddress;

  const Config({required this.password, required this.serverAddress});

  static Config fromJson(Map<String, dynamic> json) {
    return Config(
      password: json['password'],
      serverAddress: InternetAddress(json['serverAddress']),
    );
  }
}
