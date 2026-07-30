import 'package:flutter_test/flutter_test.dart';
import 'package:ai_kids_academy/main.dart';

void main() {
  testWidgets('AI Kids Academy app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AIKidsAcademyApp(hasProfile: false));
    expect(find.text('AI Kids Academy'), findsOneWidget);
  });
}
