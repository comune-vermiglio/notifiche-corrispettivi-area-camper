import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'config.dart';
import 'xml_parser.dart';

class EmailSender {
  final Config config;

  const EmailSender({required this.config});

  Future<void> sendEmail({required XmlData data}) async {
    final smtpServer = gmail(config.senderEmail, config.senderPassword);
    final formatter = DateFormat('dd/MM/yyyy - HH:mm:ss');
    final dateStr = formatter.format(data.date);
    final message = Message()
      ..from = Address(config.senderEmail, config.senderName)
      ..recipients = config.recipientEmails
      ..subject = 'Invio corrispettivi ${config.senderName} $dateStr'
      ..html =
          """<h1>Invio corrispettivi ${config.senderName}</h1>
          <ul>
          <li><b>Data invio</b>: $dateStr</li>
          <li><b>Progressivo</b>: ${data.counter}</li>
          <li><b>Numero documenti commerciali</b>: ${data.trasitionsCount}</li>
          <li><b>Ammontare</b>: ${data.total}</li>
          <li><b>Pagamento in contanti</b>: ${data.fromCash}</li>
          <li><b>Pagamento elettronico</b>: ${data.fromElectronic}</li>
          <li><b>Imposta</b>: ${data.tax}</li>
          </ul>""";
    await send(message, smtpServer);
  }
}
