import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:gestore_corrispettivi/config.dart';
import 'package:gestore_corrispettivi/data_downloader.dart';
import 'package:http/http.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

const password = 'test_password';
const serverIp = '192.168.0.203';

class ClientMock extends Fake implements Client {
  List<(Uri, Response)>? postIO;
  var postCalled = 0;

  @override
  Future<Response> get(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    expect(body, isNull);
    expect(encoding, isNull);
    expect(
      const DeepCollectionEquality().equals(headers, {
        'Authorization': 'Basic dGVzdF9wYXNzd29yZDp0ZXN0X3Bhc3N3b3Jk',
      }),
      isTrue,
    );
    assert(postIO != null && postIO!.length > postCalled);
    expect(url, equals(postIO![postCalled].$1));
    final response = postIO![postCalled].$2;
    postCalled++;
    return Future.value(response);
  }
}

void main() {
  group('DataDownloader', () {
    late DataDownloader dataDownloader;
    late ClientMock client;

    final config = Config(
      serverPassword: password,
      serverAddress: InternetAddress(serverIp),
      senderEmail: '',
      senderName: '',
      senderPassword: '',
      recipientEmails: [],
    );

    setUp(() {
      client = ClientMock();
      dataDownloader = DataDownloader(config: config, httpClient: client);
    });

    test('all data URIs', () async {
      final file = File('test/data/list_page.html');

      client.postIO = [
        (
          Uri.parse('http://$serverIp/ExportCorrFileOK.cgi?Folder=Z0001_Z0025'),
          Response(file.readAsStringSync(), 200),
        ),
        (
          Uri.parse('http://$serverIp/ExportCorrFileOK.cgi?Folder=Z0026_Z0050'),
          Response('<html><body/></html>', 200),
        ),
      ];
      final uris = await dataDownloader.allDataUris;
      expect(client.postCalled, equals(2));
      expect(
        const DeepCollectionEquality().equals(uris, [
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202507222345_Z0976.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202507232345_Z0977.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202507242345_Z0978.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202507252345_Z0979.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202507262344_Z0980.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202507272344_Z0981.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202507282344_Z0982.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202507292344_Z0983.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202507302345_Z0984.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202507312345_Z0985.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202508012345_Z0986.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202508022345_Z0987.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202508032345_Z0988.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202508042345_Z0989.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202508052345_Z0990.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202508062345_Z0991.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202508072345_Z0992.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202508082345_Z0993.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202508092344_Z0994.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202508102344_Z0995.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202508112344_Z0996.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202508122344_Z0997.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202508132344_Z0998.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202508142345_Z0999.xml',
          ),
          Uri.parse(
            'http://$serverIp/CORRISPETTIVIOK/Z0976_Z1000/202508152345_Z1000.xml',
          ),
        ]),
        isTrue,
      );
    });
  });
}
