import 'dart:convert';

import 'package:flutter_paint_store_app/models/quote.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuoteLocalRepository {
  final SharedPreferences _prefs;
  static const _quotesKey = 'sales_quotes';

  QuoteLocalRepository(this._prefs);

  Future<List<Quote>> loadQuotes() async {
    final jsonString = _prefs.getString(_quotesKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Quote.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> saveQuotes(List<Quote> quotes) async {
    final jsonList = quotes.map((quote) => quote.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(_quotesKey, jsonString);
  }
}
