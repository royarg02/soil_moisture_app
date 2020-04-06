import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:soif/main.dart';
import 'package:soif/states/selected_card_state.dart';
import 'package:soif/states/theme_state.dart';

import 'package:soif/prefs/user_prefs.dart';
import 'package:soif/utils/app_info.dart';

import 'package:soif/widgets/options.dart';

void main() {
  // * A simple test that looks for the option button
  testWidgets('Options button finder test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized(); //for awaiting
    await loadAppInfo();
    await loadPrefs();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeState>(
            create: (context) => ThemeState(context),
          ),
          ChangeNotifierProvider<SelectedCardState>(
            create: (context) => SelectedCardState(),
          ),
        ],
        child: Root(),
      ),
    );
    Finder optionsButton = find.byType(OptionButton);

    expect(optionsButton, findsOneWidget);
  });

  //TODO; Add more tests
}
