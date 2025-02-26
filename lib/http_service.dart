import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model_surat.dart';

class HttpService {
  final String baseUrl = "https://quran-api.santrikoding.com/api/surah";

  Future<List<Surat>> getPosts() async {
    final http.Response res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      return body.map((dynamic item) => Surat.fromJson(item)).toList();
    }else {
      throw Exception("error ${res.statusCode}: ${res.body}");
    }
  }

//ngambil ayat
  Future<Surat> getAyatBySurat(int nomorSurat) async {
    final String url = "$baseUrl/$nomorSurat";
    final http.Response res = await http.get(Uri.parse(url));
   

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);
      return Surat.fromJson(body);
    }else {
      throw Exception("error ${res.statusCode}: ${res.body}");
    }
  }
}