import 'package:flutter_test/flutter_test.dart';
import 'package:smart_ration_box/app.dart';

void main() {
  testWidgets('Dashboard renders title', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartRationBoxApp());
    expect(find.text('RationBox'), findsOneWidget);
  });
}
