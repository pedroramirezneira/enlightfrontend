import 'dart:convert';

import 'package:enlight/models/search_data.dart';
import 'package:enlight/util/web_client.dart';
import 'package:flutter/material.dart';

class SearchService {
  static Future<SearchData> search(BuildContext context, String query) async {
    final response = await WebClient.get(
      context,
      "search?q=$query",
      info: false,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return SearchData.fromJson(data);
    }
    return EmptySearchData();
  }
}
