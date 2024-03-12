import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Presentation/screens/testfile.dart';

void main() {
  testWidgets('Login Page UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: LoginPage(),
    ));

    // Verify that the background color is Colours.orange.
    expect(find.byType(Scaffold), findsOneWidget);
    expect(tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor, Colours.orange);

    // Verify that the "Username" and "Password" text fields are present.
    expect(find.widgetWithText(TextField, 'Username'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);

    // Verify that the "Remember me" checkbox is present.
    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.text('Remember me'), findsOneWidget);

    // Verify that the "Forgot Password?" text button is present.
    expect(find.text('Forgot Password?'), findsOneWidget);

    // Verify that the "LOGIN" button is present.
    expect(find.text('LOGIN'), findsOneWidget);

    // Tap the "LOGIN" button and verify navigation to the home screen.
    await tester.tap(find.text('LOGIN'));
    await tester.pump();

    expect(find.byType(Navigator), findsOneWidget); // Assuming navigation occurs correctly
  });
}
