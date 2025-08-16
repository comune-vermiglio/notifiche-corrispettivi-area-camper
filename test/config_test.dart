import 'dart:io';

import 'package:gestore_corrispettivi/config.dart';
import 'package:test/test.dart';

void main() {
  group('Config', () {
    test('fromJson', () {
      const password = 'test_password';
      const serverAddress = '192.168.0.1';
      final json = {'password': password, 'serverAddress': serverAddress};
      final config = Config.fromJson(json);
      expect(config.password, password);
      expect(config.serverAddress, InternetAddress(serverAddress));
    });
  });
}
