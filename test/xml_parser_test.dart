import 'dart:io';

import 'package:gestore_corrispettivi/xml_parser.dart';
import 'package:test/test.dart';

void main() {
  group('XmlParser', () {
    const parser = XmlParser();

    test('empty', () {
      final file = File('test/data/202209301605_Z0009.xml');
      final data = parser.parse(file.readAsStringSync());
      expect(data.counter, equals(9));
      expect(data.date, equals(DateTime(2022, 9, 30, 16, 5, 11)));
      expect(data.trasitionsCount, equals(0));
      expect(data.tax, equals(0.0));
      expect(data.total, equals(0.0));
      expect(data.fromCash, equals(0.0));
      expect(data.fromElectronic, equals(0.0));
    });

    test('full', () {
      final file = File('test/data/202508102344_Z0995.xml');
      final data = parser.parse(file.readAsStringSync());
      expect(data.counter, equals(995));
      expect(data.date, equals(DateTime(2025, 8, 10, 23, 44, 49)));
      expect(data.trasitionsCount, equals(18));
      expect(data.tax, equals(97.21));
      expect(data.total, equals(441.89));
      expect(data.fromCash, equals(102.50));
      expect(data.fromElectronic, equals(436.60));
    });
  });
}
