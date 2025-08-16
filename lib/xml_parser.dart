import 'package:xml/xml.dart';

class XmlData {
  final int counter;
  final DateTime date;
  final double tax;
  final double total;
  final double fromCash;
  final double fromElectronic;
  final int trasitionsCount;

  const XmlData({
    required this.counter,
    required this.date,
    required this.tax,
    required this.total,
    required this.fromCash,
    required this.fromElectronic,
    required this.trasitionsCount,
  });
}

class XmlParser {
  const XmlParser();

  XmlData parse(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    var counter = int.parse(
      document.findAllElements('Progressivo').firstOrNull?.innerText ?? '',
    );
    var date = DateTime.parse(
      document.findAllElements('DataOraRilevazione').firstOrNull?.innerText ??
          '',
    );
    final totali = document.findAllElements('Totali').firstOrNull;
    final trasitionsCount = int.parse(
      totali?.getElement('NumeroDocCommerciali')?.innerText ?? '',
    );
    final fromCash = double.parse(
      totali?.getElement('PagatoContanti')?.innerText ?? '0.0',
    );
    final fromElectronic = double.parse(
      totali?.getElement('PagatoElettronico')?.innerText ?? '0.0',
    );
    final riepilogo = document.findAllElements('Riepilogo').firstOrNull;
    final tax = double.parse(
      riepilogo?.findAllElements('Imposta').firstOrNull?.innerText ?? '0.0',
    );
    final total = double.parse(
      riepilogo?.getElement('Ammontare')?.innerText ?? '0.0',
    );
    return XmlData(
      counter: counter,
      date: date,
      tax: tax,
      total: total,
      fromCash: fromCash,
      fromElectronic: fromElectronic,
      trasitionsCount: trasitionsCount,
    );
  }
}
