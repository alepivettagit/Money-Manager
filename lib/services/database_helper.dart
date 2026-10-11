import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' hide Transaction;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/account.dart';
import '../models/transaction.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Chiavi di fallback per Web
  static const String _webAccountsKey = 'web_accounts_list';
  static const String _webTransactionsKey = 'web_transactions_list';

  DatabaseHelper._init();

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('Database SQLite nativo non supportato direttamente su Web');
    }
    if (_database != null) return _database!;
    _database = await _initDB('money_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE accounts (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        initialBalance REAL NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        accountId TEXT NOT NULL,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY (accountId) REFERENCES accounts (id) ON DELETE CASCADE
      )
    ''');

    await _checkMigrationAndSeed(db);
  }

  Future<void> _checkMigrationAndSeed(Database db) async {
    final prefs = await SharedPreferences.getInstance();
    final legacyList = prefs.getStringList('money_manager_transactions');

    if (legacyList != null && legacyList.isNotEmpty) {
      final mainAccount = Account(
        id: const Uuid().v4(),
        name: 'Conto Principale',
        initialBalance: 0.0,
        createdAt: DateTime.now(),
      );
      await db.insert('accounts', mainAccount.toMap());

      for (final item in legacyList) {
        try {
          final jsonMap = jsonDecode(item) as Map<String, dynamic>;
          final tx = Transaction(
            id: jsonMap['id'] as String,
            accountId: mainAccount.id,
            title: jsonMap['title'] as String,
            amount: (jsonMap['amount'] as num).toDouble(),
            date: DateTime.parse(jsonMap['date'] as String),
            type: jsonMap['type'] == 'expense' ? TransactionType.expense : TransactionType.income,
            category: jsonMap['category'] as String,
            note: jsonMap['note'] as String?,
          );
          await db.insert('transactions', tx.toMap());
        } catch (_) {}
      }
      await prefs.remove('money_manager_transactions');
    }
  }

  // --- ACCOUNTS CRUD ---
  Future<List<Account>> getAccounts() async {
    if (kIsWeb) {
      return await _getWebAccounts();
    }
    final db = await database;
    final result = await db.query('accounts', orderBy: 'createdAt ASC');
    return result.map((map) => Account.fromMap(map)).toList();
  }

  Future<void> insertAccount(Account account) async {
    if (kIsWeb) {
      await _insertWebAccount(account);
      return;
    }
    final db = await database;
    await db.insert('accounts', account.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateAccount(Account account) async {
    if (kIsWeb) {
      await _insertWebAccount(account);
      return;
    }
    final db = await database;
    await db.update('accounts', account.toMap(), where: 'id = ?', whereArgs: [account.id]);
  }

  Future<void> deleteAccount(String accountId) async {
    if (kIsWeb) {
      await _deleteWebAccount(accountId);
      return;
    }
    final db = await database;
    await db.delete('accounts', where: 'id = ?', whereArgs: [accountId]);
    await db.delete('transactions', where: 'accountId = ?', whereArgs: [accountId]);
  }

  // --- TRANSACTIONS CRUD ---
  Future<List<Transaction>> getTransactionsByAccount(String accountId) async {
    if (kIsWeb) {
      return await _getWebTransactions(accountId);
    }
    final db = await database;
    final result = await db.query(
      'transactions',
      where: 'accountId = ?',
      whereArgs: [accountId],
      orderBy: 'date DESC',
    );
    return result.map((map) => Transaction.fromMap(map)).toList();
  }

  Future<void> insertTransaction(Transaction transaction) async {
    if (kIsWeb) {
      await _insertWebTransaction(transaction);
      return;
    }
    final db = await database;
    await db.insert('transactions', transaction.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteTransaction(String id) async {
    if (kIsWeb) {
      await _deleteWebTransaction(id);
      return;
    }
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================
  // GESTIONE SPECIFICA PER ANTEPRIMA WEB
  // ==========================================
  Future<List<Account>> _getWebAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_webAccountsKey);
    if (rawList == null || rawList.isEmpty) {
      return [];
    }
    return rawList.map((str) => Account.fromMap(jsonDecode(str) as Map<String, dynamic>)).toList();
  }

  Future<void> _insertWebAccount(Account account) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = await _getWebAccounts();
    accounts.removeWhere((a) => a.id == account.id);
    accounts.add(account);
    await prefs.setStringList(
      _webAccountsKey,
      accounts.map((a) => jsonEncode(a.toMap())).toList(),
    );
  }

  Future<void> _deleteWebAccount(String accountId) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = await _getWebAccounts();
    accounts.removeWhere((a) => a.id == accountId);
    await prefs.setStringList(
      _webAccountsKey,
      accounts.map((a) => jsonEncode(a.toMap())).toList(),
    );

    final rawTxs = prefs.getStringList(_webTransactionsKey) ?? [];
    final updatedTxs = rawTxs
        .map((s) => Transaction.fromMap(jsonDecode(s) as Map<String, dynamic>))
        .where((t) => t.accountId != accountId)
        .map((t) => jsonEncode(t.toMap()))
        .toList();
    await prefs.setStringList(_webTransactionsKey, updatedTxs);
  }

  Future<List<Transaction>> _getWebTransactions(String accountId) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_webTransactionsKey) ?? [];
    return rawList
        .map((s) => Transaction.fromMap(jsonDecode(s) as Map<String, dynamic>))
        .where((t) => t.accountId == accountId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _insertWebTransaction(Transaction tx) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_webTransactionsKey) ?? [];
    final txs = rawList
        .map((s) => Transaction.fromMap(jsonDecode(s) as Map<String, dynamic>))
        .toList();
    txs.removeWhere((t) => t.id == tx.id);
    txs.insert(0, tx);
    await prefs.setStringList(
      _webTransactionsKey,
      txs.map((t) => jsonEncode(t.toMap())).toList(),
    );
  }

  Future<void> _deleteWebTransaction(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_webTransactionsKey) ?? [];
    final txs = rawList
        .map((s) => Transaction.fromMap(jsonDecode(s) as Map<String, dynamic>))
        .where((t) => t.id != id)
        .toList();
    await prefs.setStringList(
      _webTransactionsKey,
      txs.map((t) => jsonEncode(t.toMap())).toList(),
    );
  }
}
