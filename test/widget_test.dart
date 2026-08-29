import 'package:flutter_test/flutter_test.dart';
import 'package:naql_customer/injection_container.dart' as di;
import 'package:naql_customer/main.dart';

void main() {
  testWidgets('NaqlApp builds successfully', (tester) async {
    await di.init();
    await tester.pumpWidget(const NaqlApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byType(NaqlApp), findsOneWidget);
  });
}
