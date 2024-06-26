import 'dart:convert';

import 'package:flutter/services.dart';

class JsonService {
  Future<List<dynamic>> loadJsonData() async {
    try {
      final data = await rootBundle.loadString('assets/NSE.json');
      return jsonDecode(data) as List<dynamic>;
    } catch (e) {
      throw Exception("Failed to load JSON data: $e");
    }
  }
}

