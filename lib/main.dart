import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'providers/account_provider.dart';
import 'providers/transaction_provider.dart';
import 'screens/account_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('it_IT', null);
  runApp(const MoneyManagerApp());
}

class MoneyManagerApp extends StatelessWidget {
  const MoneyManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AccountProvider()..loadAccounts(),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Money Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0F172A),
            brightness: Brightness.light,
            primary: const Color(0xFF0F172A),
            secondary: const Color(0xFF10B981),
          ),
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF8FAFC),
            elevation: 0,
            scrolledUnderElevation: 0,
            titleTextStyle: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          cardColor: Colors.white,
        ),
        home: const AccountSelectionScreen(),
      ),
    );
  }
}
