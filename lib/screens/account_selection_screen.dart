import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../models/transaction.dart';
import '../providers/account_provider.dart';
import '../providers/transaction_provider.dart';
import '../services/database_helper.dart';
import '../widgets/create_account_dialog.dart';
import 'main_navigation_shell.dart';

class AccountSelectionScreen extends StatefulWidget {
  const AccountSelectionScreen({super.key});

  @override
  State<AccountSelectionScreen> createState() => _AccountSelectionScreenState();
}

class _AccountSelectionScreenState extends State<AccountSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAccountsAndGuide();
    });
  }

  void _checkAccountsAndGuide() {
    final accountProvider = context.read<AccountProvider>();
    if (!accountProvider.isLoading && accountProvider.accounts.isEmpty) {
      _showCreateDialog();
    }
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CreateAccountDialog(
        onCreated: (name, initialBalance) async {
          final newAccount = await context
              .read<AccountProvider>()
              .createAccount(name, initialBalance);
          if (mounted) {
            _selectAndOpenAccount(newAccount);
          }
        },
      ),
    );
  }

  void _selectAndOpenAccount(Account account) async {
    context.read<AccountProvider>().selectAccount(account);
    await context.read<TransactionProvider>().loadTransactions(account.id);
    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const MainNavigationShell(),
      ),
    );
  }

  void _confirmDeleteAccount(Account account) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Elimina Saldo'),
        content: Text(
          'Sei sicuro di voler eliminare "${account.name}"? Tutte le transazioni collegate a questo saldo verranno rimosse definitivamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AccountProvider>().deleteAccount(account.id);
            },
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'it_IT', symbol: '€');
    final accountProvider = context.watch<AccountProvider>();

    if (accountProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final accounts = accountProvider.accounts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('I Miei Saldi'),
        centerTitle: false,
      ),
      body: accounts.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 64,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Nessun Saldo Creato',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Per iniziare a monitorare le tue spese, crea il tuo primo saldo (es. "Conto Corrente" o "Contanti").',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      onPressed: _showCreateDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text(
                        'Crea Primo Saldo',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 12),
                  child: Text(
                    'Seleziona il saldo che vuoi visualizzare:',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ...accounts.map((account) {
                  return _buildAccountCard(context, account, currencyFormat);
                }),
              ],
            ),
      floatingActionButton: accounts.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _showCreateDialog,
              backgroundColor: const Color(0xFF0F172A),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Nuovo Saldo', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildAccountCard(BuildContext context, Account account, NumberFormat currencyFormat) {
    return FutureBuilder<List<Transaction>>(
      future: DatabaseHelper.instance.getTransactionsByAccount(account.id),
      builder: (context, snapshot) {
        final txs = snapshot.data ?? [];
        final totalIncome = txs
            .where((t) => t.type == TransactionType.income)
            .fold(0.0, (sum, t) => sum + t.amount);
        final totalExpense = txs
            .where((t) => t.type == TransactionType.expense)
            .fold(0.0, (sum, t) => sum + t.amount);
        final currentBalance = account.initialBalance + totalIncome - totalExpense;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _selectAndOpenAccount(account),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Importo iniziale: ${currencyFormat.format(account.initialBalance)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currencyFormat.format(currentBalance),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: currentBalance >= 0
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                          ),
                        ),
                        const SizedBox(height: 6),
                        IconButton(
                          icon: const Icon(Icons.more_horiz_rounded, size: 20, color: Colors.grey),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _confirmDeleteAccount(account),
                          tooltip: 'Elimina Saldo',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
