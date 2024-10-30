import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/rate.dart';

class RateService extends ChangeNotifier {
  final String baseUrl = 'http://localhost:3333';
  List<Rate> _rates = [];

  List<Rate> get rates => _rates;

  Future<void> getRates() async {
    final response = await http.get(Uri.parse('$baseUrl/taux'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      _rates = body.map((dynamic item) => Rate.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load rates');
    }
  }

  Future<void> refreshRates() async {
    final response = await http.post(Uri.parse('$baseUrl/taux/refresh'));
    if (response.statusCode == 200) {
      await getRates();
    } else {
      throw Exception('Failed to refresh rates');
    }
  }

  void autoRefreshRates() {
    Timer.periodic(Duration(hours: 1), (timer) async {
      try {
        await refreshRates();
      } catch (e) {
        print('Failed to auto-refresh rates: $e');
      }
    });
  }
}