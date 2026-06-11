import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryEntry {
  final int? id;
  final String type;
  final double amount;
  final double fixedRate;
  final double floatRate;
  final int termMonths;
  final double totalInterest;
  final double totalAmount;
  final String method;
  final DateTime createdAt;

  HistoryEntry({
    this.id,
    required this.type,
    required this.amount,
    required this.fixedRate,
    required this.floatRate,
    required this.termMonths,
    required this.totalInterest,
    required this.totalAmount,
    required this.method,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type,
    'amount': amount,
    'fixedRate': fixedRate,
    'floatRate': floatRate,
    'termMonths': termMonths,
    'totalInterest': totalInterest,
    'totalAmount': totalAmount,
    'method': method,
    'createdAt': createdAt.toIso8601String(),
  };

  factory HistoryEntry.fromMap(Map<String, dynamic> m) => HistoryEntry(
    id: m['id'],
    type: m['type'],
    amount: (m['amount'] as num).toDouble(),
    fixedRate: (m['fixedRate'] as num).toDouble(),
    floatRate: (m['floatRate'] as num).toDouble(),
    termMonths: m['termMonths'],
    totalInterest: (m['totalInterest'] as num).toDouble(),
    totalAmount: (m['totalAmount'] as num).toDouble(),
    method: m['method'],
    createdAt: DateTime.parse(m['createdAt']),
  );
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  static const _key = 'loan_history';
  static int _nextId = 0;

  Future<List<HistoryEntry>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final entries = raw
        .map((s) => HistoryEntry.fromMap(jsonDecode(s)))
        .toList();
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  Future<void> insert(HistoryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    _nextId++;
    final newEntry = HistoryEntry(
      id: _nextId,
      type: entry.type,
      amount: entry.amount,
      fixedRate: entry.fixedRate,
      floatRate: entry.floatRate,
      termMonths: entry.termMonths,
      totalInterest: entry.totalInterest,
      totalAmount: entry.totalAmount,
      method: entry.method,
      createdAt: entry.createdAt,
    );
    raw.add(jsonEncode(newEntry.toMap()));
    await prefs.setStringList(_key, raw);
  }

  Future<void> delete(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    raw.removeWhere((s) {
      final m = jsonDecode(s);
      return m['id'] == id;
    });
    await prefs.setStringList(_key, raw);
  }

  Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}