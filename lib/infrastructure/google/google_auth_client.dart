import 'package:http/http.dart' as http;

//Sending Google Authentication headers to Google Client
//Checks the permissions to allow upload on the Google Drive by the user
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}