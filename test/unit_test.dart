import 'package:flutter_test/flutter_test.dart';
import 'package:money_manager/models/account.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/providers/account_provider.dart';

void main() {
  group('Money Manager Unit Tests', () {
    test('Calcolo corretto del saldo conto', () {
      final provider = AccountProvider();
      final now = DateTime.now();
      final account = Account(
        id: 'acc1',
        name: 'Conto Corrente',
        initialBalance: 1000.0,
        createdAt: now,
      );

      final txs = [
        Transaction(
          id: '1',
          accountId: 'acc1',
          title: 'Stipendio',
          amount: 500.0,
          date: now,
          type: TransactionType.income,
          category: 'Stipendio',
        ),
        Transaction(
          id: '2',
          accountId: 'acc1',
          title: 'Spesa',
          amount: 150.0,
          date: now,
          type: TransactionType.expense,
          category: 'Spesa e Cibo',
        ),
        Transaction(
          id: '3',
          accountId: 'acc2', // Altro conto
          title: 'Caffè',
          amount: 2.0,
          date: now,
          type: TransactionType.expense,
          category: 'Ristoranti & Bar',
        ),
      ];

      final balance = provider.calculateCurrentBalance(account, txs);
      // 1000 iniziale + 500 entrata - 150 spesa = 1350
      expect(balance, 1350.0);
    });

    test('Serializzazione Account toMap e fromMap', () {
      final now = DateTime.now();
      final account = Account(
        id: 'acc_test',
        name: 'Contanti',
        initialBalance: 75.50,
        createdAt: now,
      );

      final map = account.toMap();
      final restored = Account.fromMap(map);

      expect(restored.id, 'acc_test');
      expect(restored.name, 'Contanti');
      expect(restored.initialBalance, 75.50);
    });
  });
}
