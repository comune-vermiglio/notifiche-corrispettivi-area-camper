import 'dart:convert';
import 'dart:io';

import 'package:gestore_corrispettivi/config.dart';
import 'package:gestore_corrispettivi/data_downloader.dart';
import 'package:gestore_corrispettivi/xml_parser.dart';
import 'package:http/http.dart';

void main() async {
  final configFile = File('./config.json');
  if (!configFile.existsSync()) {
    print('Configuration file not found. Please create a config.json file.');
    return;
  }
  final configContent = configFile.readAsStringSync();
  final httpClient = Client();
  final config = Config.fromJson(
    Map<String, dynamic>.from(jsonDecode(configContent)),
  );
  final downloader = DataDownloader(config: config, httpClient: httpClient);
  List<Uri> dataUris;
  try {
    dataUris = await downloader.allDataUris;
  } catch (e) {
    print('Error fetching data URIs: $e');
    httpClient.close();
    return;
  }
  print('Found ${dataUris.length} data URIs.');
  const parser = XmlParser();
  List<XmlData> dataList = [];
  for (final uri in dataUris) {
    try {
      print('Processing $uri');
      final xmlContent = await downloader.downloadData(uri);
      final data = parser.parse(xmlContent);
      dataList.add(data);
    } catch (e) {
      print('Error processing $uri: $e');
    }
  }
  final List<String> csvRows = dataList.map((data) => data.csvRow).toList();
  print('Saving csv file');
  final csvFile = File('output.csv');
  const header =
      'Counter,Date,Time,TransitionsCount,Tax,Total,FromCash,FromElectronic';
  csvFile.writeAsStringSync('$header\n${csvRows.join('\n')}');
  httpClient.close();
}
