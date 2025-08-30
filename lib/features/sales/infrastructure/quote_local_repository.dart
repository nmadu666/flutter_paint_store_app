import 'dart:convert';

import 'package:flutter_paint_store_app/models/quote.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Lớp này chịu trách nhiệm lưu và tải các báo giá từ bộ nhớ cục bộ.
class QuoteLocalRepository {
  final SharedPreferences _prefs;
  static const _quotesKey = 'sales_quotes';

  QuoteLocalRepository(this._prefs);

  Future<void> saveQuotes(List<Quote> quotes) async {
    final List<String> quotesJson =
        quotes.map((q) => jsonEncode(q.toJson())).toList();
    await _prefs.setStringList(_quotesKey, quotesJson);
  }

  Future<List<Quote>> loadQuotes() async {
    final List<String>? quotesJson = _prefs.getStringList(_quotesKey);
    if (quotesJson == null) {
      return [];
    }
    return quotesJson
        .map((q) => Quote.fromJson(jsonDecode(q) as Map<String, dynamic>))
        .toList();
  }
}

// --- Các Provider cho tầng Hạ tầng ---

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) => SharedPreferences.getInstance());

final quoteLocalRepositoryProvider = FutureProvider<QuoteLocalRepository>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return QuoteLocalRepository(prefs);
});
