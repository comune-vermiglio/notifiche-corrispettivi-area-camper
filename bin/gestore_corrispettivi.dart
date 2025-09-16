import 'dart:convert';
import 'dart:io';

import 'package:gestore_corrispettivi/config.dart';
import 'package:gestore_corrispettivi/data_downloader.dart';
import 'package:gestore_corrispettivi/email_sender.dart';
import 'package:gestore_corrispettivi/log_manager.dart';
import 'package:gestore_corrispettivi/xml_parser.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:mailer/mailer.dart';

void main() async {
  final logManager = LogManager(logFile: File('./log.txt'));
  await logManager.initialize();
  final log = Logger('main');
  final configFile = File('./config.json');
  final configFileExist = await configFile.exists();
  if (!configFileExist) {
    log.severe(
      'Configuration file not found. Please create a config.json file.',
    );
    return;
  }
  final httpClient = Client();
  final configContent = await configFile.readAsString();
  log.info('Reading config file');
  final config = Config.fromJson(
    Map<String, dynamic>.from(jsonDecode(configContent)),
  );
  log.info('Config file ok');
  final downloader = DataDownloader(config: config, httpClient: httpClient);
  List<Uri> dataUris;
  try {
    log.info('Fetching data URIs');
    dataUris = await downloader.allDataUris;
  } catch (e) {
    log.severe('Error fetching data URIs: $e');
    httpClient.close();
    return;
  }
  log.info('Found ${dataUris.length} data URIs');
  if (dataUris.isNotEmpty) {
    try {
      log.info('Processing ${dataUris.last}');
      final xmlContent = await downloader.downloadData(dataUris.last);
      final data = XmlParser().parse(xmlContent);
      final emailSender = EmailSender(config: config);
      log.info('Sending email');
      await emailSender.sendEmail(data: data);
    } on MailerException catch (e) {
      log.severe('Error sending email. $e');
    } catch (e) {
      log.severe('Error processing ${dataUris.last}: $e');
    }
  }
  httpClient.close();
}
