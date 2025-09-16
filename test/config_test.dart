import 'dart:io';

import 'package:notifiche_corrispettivi/config.dart';
import 'package:test/test.dart';

void main() {
  group('Config', () {
    test('fromJson', () {
      const serverPassword = 'test_password';
      const serverAddress = '192.168.0.1';
      const senderName = 'sender name';
      const senderEmail = 'sender@email.com';
      const senderPassword = 'sender password';
      const recipientEmails = ['recipient1@email.com', 'recipient2@email.com'];
      final json = {
        'serverPassword': serverPassword,
        'serverAddress': serverAddress,
        'senderName': senderName,
        'senderEmail': senderEmail,
        'senderPassword': senderPassword,
        'recipientEmails': recipientEmails,
      };
      expect(
        Config.fromJson(json),
        equals(
          Config(
            serverAddress: InternetAddress(serverAddress),
            serverPassword: serverPassword,
            senderName: senderName,
            senderEmail: senderEmail,
            senderPassword: senderPassword,
            recipientEmails: recipientEmails,
          ),
        ),
      );
    });
  });
}
