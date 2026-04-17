import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'config.dart';
import 'xml_parser.dart';

class EmailSender {
  final Config config;

  const EmailSender({required this.config});

  Future<void> sendDataEmail({required XmlData data}) async {
    return sendEmail(
      subject:
          'Invio corrispettivi ${config.senderName} ${DateFormat('dd/MM/yyyy').format(data.date)}',
      htmlBody:
          """<h2>Invio corrispettivi ${config.senderName}</h2>
          <ul>
          <li><b>Data invio</b>: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(data.date)}</li>
          <li><b>Progressivo</b>: ${data.counter}</li>
          <li><b>Numero documenti commerciali</b>: ${data.trasitionsCount}</li>
          <li><b>Ammontare</b>: ${data.total}€</li>
          <li><b>Pagamento in contanti</b>: ${data.fromCash}€</li>
          <li><b>Pagamento elettronico</b>: ${data.fromElectronic}€</li>
          <li><b>Imposta</b>: ${data.tax}€</li>
          </ul>""",
    );
  }

  Future<void> sendEmail({
    required String subject,
    required String htmlBody,
  }) async {
    final smtpServer = gmail(config.senderEmail, config.senderPassword);
    final message = Message()
      ..from = Address(config.senderEmail, config.senderName)
      ..recipients = config.recipientEmails
      ..subject = subject
      ..html = htmlBody;
    await send(message, smtpServer);
  }
}
