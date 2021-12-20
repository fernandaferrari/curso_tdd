import 'package:curso_tdd/data/http/http_client.dart';
import 'package:curso_tdd/infra/http/http_adapter.dart';
import 'package:http/http.dart';

IHttpClient makeHttpAdapter() {
  final client = Client();
  return HttpAdapter(client);
}
