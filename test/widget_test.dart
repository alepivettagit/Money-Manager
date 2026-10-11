import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:money_manager/main.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('Money Manager app smoke test', (WidgetTester tester) async {
    await initializeDateFormatting('it_IT', null);
    SharedPreferences.setMockInitialValues({});

    await tester.runAsync(() async {
      await tester.pumpWidget(const MoneyManagerApp());
      await Future.delayed(const Duration(milliseconds: 600));
    });

    await tester.pump();
    await tester.pump(const Duration(seconds: 11));

    expect(find.text('I Miei Saldi'), findsOneWidget);
  });
}
