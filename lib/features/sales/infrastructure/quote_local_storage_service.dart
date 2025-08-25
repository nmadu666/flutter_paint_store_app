import 'dart:convert';

import 'package:flutter_paint_store_app/models/quote.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuoteLocalStorageService {
  static const _quotesKey = 'in_progress_quotes';

  Future<void> saveQuotes(List<Quote> quotes) async {
    final prefs = await SharedPreferences.getInstance();
    final quotesJson = quotes.map((q) => jsonEncode(q.toJson())).toList();
    await prefs.setStringList(_quotesKey, quotesJson);
  }

  Future<List<Quote>> loadQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final quotesJson = prefs.getStringList(_quotesKey);
    if (quotesJson == null) {
      return [];
    }

    return quotesJson
        .map((json) => Quote.fromJson(jsonDecode(json)))
        .toList();
  }
}
