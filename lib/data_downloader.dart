import 'package:http/http.dart';

import 'config.dart';

class DataDownloader {
  final Config config;
  final Client httpClient;

  const DataDownloader({required this.config, required this.httpClient});

  static const _relativePath = 'ExportCorrFileOK.cgi?Folder=';

  Future<List<Uri>> get allDataUris async {
    final ret = <Uri>[];
    var startIndex = 1;
    var tmp = <RegExpMatch>[];
    do {
      final pageContent = await downloadData(
        Uri.parse(
          'http://${config.serverAddress.address}/${_relativePath}Z${_indexToString(startIndex)}_Z${_indexToString(startIndex + 24)}',
        ),
      );
      tmp = RegExp(
        r'CORRISPETTIVIOK/Z(\d{4})_Z(\d{4})/\d{12}_Z(\d{4}).xml',
      ).allMatches(pageContent).toList();
      ret.addAll(
        tmp.map(
          (e) => Uri.parse('http://${config.serverAddress.address}/${e[0]}'),
        ),
      );
      startIndex += 25;
    } while (tmp.isNotEmpty);
    return ret;
  }

  String _indexToString(int index) => index.toString().padLeft(4, '0');

  Future<String> downloadData(Uri url) async {
    final response = await httpClient.get(
      url,
      headers: {'Authorization': 'Basic ${config.password}'},
    );
    return response.body;
  }
}
