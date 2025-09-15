import 'dart:convert';
import 'dart:io';

import 'package:gestore_corrispettivi/config.dart';
import 'package:gestore_corrispettivi/data_downloader.dart';
import 'package:gestore_corrispettivi/email_sender.dart';
import 'package:gestore_corrispettivi/xml_parser.dart';
import 'package:http/http.dart';
import 'package:mailer/mailer.dart';

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
    print('Fetching data URIs...');
    dataUris = await downloader.allDataUris;
  } catch (e) {
    print('Error fetching data URIs: $e');
    httpClient.close();
    return;
  }
  print('Found ${dataUris.length} data URIs.');
  if (dataUris.isNotEmpty) {
    try {
      print('Processing ${dataUris.last}...');
      final xmlContent = await downloader.downloadData(dataUris.last);
      final data = XmlParser().parse(xmlContent);
      final emailSender = EmailSender(config: config);
      await emailSender.sendEmail(data: data);
    } on MailerException catch (e) {
      print('Message not sent. $e');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    } catch (e) {
      print('Error processing ${dataUris.last}: $e');
    }
  }
  httpClient.close();
}
