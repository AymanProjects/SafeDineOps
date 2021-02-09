import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Mailer {
  String username = 'safedineapp@gmail.com';
  String password = '11223311Ma';
  String recipientsEmail;
  String otp_code;

  Mailer({this.recipientsEmail, this.otp_code}) {
    initMessage();
  }

  void initMessage() async {
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'SafeDine')
      ..recipients.add(recipientsEmail)
      ..subject = 'Verification code 🔑'
      ..html =
          "<p>Use this code to complete your sign in</p>\n<h1>${this.otp_code}</h1>";

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
