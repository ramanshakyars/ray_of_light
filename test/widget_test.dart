import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rayoflite/core/config/config-routes.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/main.dart';

void main() {
  testWidgets('App builds with router', (WidgetTester tester) async {
    final router = createRouter(RouteNames.landingPage);

    await tester.pumpWidget(MyApp(router: router));
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
