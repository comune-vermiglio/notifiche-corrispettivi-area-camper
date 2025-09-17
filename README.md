# Notifiche corrispettivi area camper

Questa applicazione si collega al webserver della stampante, scarica l'ultimo corrispettivo inviato e notifica attraverso una email.

## Come avviare

Richiede il [Dart SDK](https://dart.dev/get-dart).

```bash
git clone https://github.com/comune-vermiglio/notifiche-corrispettivi-area-camper.git
cd notifiche-corrispettivi-area-camper
dart compile exe bin/notifiche_corrispettivi.dart
```

Spostare il file compilato in una cartella con il file `config.json`.

### Configurazione

Tutta la configurazione è salvata nel file `config.json`. Nella root directory di questo repository esiste il template di questo file.

- **serverAddress**: indirizzo del webserver della stampante.
- **serverPassword**: password per accedere al webserver della stampante. E' lo stesso che chiede il browser quando si accede al webserver della stampante.
- **senderName**: nome di chi invia la mail. E' utilizzato unicamente per personalizzare la mail di invio.
- **senderEmail**: email di chi invia la mail. Funziona solo con un indirizzo _gmail_.
- **senderPassword** gmail app password. Seguire [questi](https://support.google.com/mail/answer/185833?hl=en) passaggi per generarne una.
- **recipientEmails**: lista di email che devo ricevere la notifica.
