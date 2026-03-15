import 'package:flutter_test/flutter_test.dart';
import 'package:apex_firm_mobile/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ApexFundsApp());
    expect(find.text('APEX FUNDS'), findsOneWidget);
  });
}
