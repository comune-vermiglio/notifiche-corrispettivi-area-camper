import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'config.dart';
import 'xml_parser.dart';

class EmailSender {
  final Config config;

  const EmailSender({required this.config});

  Future<void> sendEmail({required XmlData data}) async {
    final smtpServer = gmail(config.senderEmail, config.senderPassword);
    final message = Message()
      ..from = Address(config.senderEmail, config.senderName)
      ..recipients = config.recipientEmails
      ..subject = 'Invio corrispettivi ${data.date}'
      ..html =
          "<h1>Invio corrispettivi ${config.senderName}</h1>\n<ol><li><b>Progressivo</b>: ${data.counter}</li><li><b>Data invio</b>: ${data.date}</li><li><b>Numero documenti commerciali</b>: ${data.trasitionsCount}</li><li><b>Ammontare</b>: ${data.total}</li><li><b>Pagamento in contanti</b>: ${data.fromCash}</li><li><b>Pagamento elettronico</b>: ${data.fromElectronic}</li><li><b>Imposta</b>: ${data.tax}</li></ol>";
    await send(message, smtpServer);
  }
}
