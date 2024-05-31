import 'dart:convert';

import 'package:enlight/models/search_data.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SearchOps {
  static Future<SearchData> getSearch(String query) async {
    final token = await Token.getAccessToken();
    final response = await http.get(
      Uri.http(
        dotenv.env["SERVER"]!,
        "/search",
        {
          "q": query,
        },
      ),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return SearchData.fromJson(data);
    }
    throw response.statusCode;
  }
}
