import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/l10n/localizations.dart";
import "package:kaiteki/theming/default/themes.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/ui/shared/timeline.dart";
import "package:kaiteki_core/model.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../mocks/timeline_adapter.dart";

void main() {
  late SharedPreferences sharedPreferences;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
  });

  testWidgets("Timeline changed after kind switch", (tester) async {
    Future<Widget> wrapper(Widget widget) async {
      return ProviderScope(
        overrides: [
          adapterProvider.overrideWith(
            (ref) => TimelineAdapter(TimelineAdapterCapabilities()),
          ),
          sharedPreferencesProvider.overrideWith((_) => sharedPreferences),
        ],
        child: MaterialApp(
          theme: getDefaultTheme(Brightness.light, true),
          localizationsDelegates: KaitekiLocalizations.localizationsDelegates,
          supportedLocales: KaitekiLocalizations.supportedLocales,
          home: Scaffold(body: widget),
        ),
      );
    }

    // Switch to home timeline
    await tester.pumpWidget(
      await wrapper(const Timeline.kind()),
    );

    await tester.pumpAndSettle();
    expect(find.text(TimelineKind.home.toString()), findsOneWidget);

    // Switch to federated timeline
    await tester.pumpWidget(
      await wrapper(const Timeline.kind(kind: TimelineKind.federated)),
    );

    await tester.pumpAndSettle();
    expect(find.text(TimelineKind.federated.toString()), findsOneWidget);
  });

  testWidgets("Timeline shows failures properly", (tester) async {
    Future<Widget> wrapper(Widget widget) async {
      return ProviderScope(
        overrides: [
          adapterProvider.overrideWith((ref) {
            return TimelineAdapter(
              TimelineAdapterCapabilities(),
              {TimelineKind.federated, TimelineKind.hybrid},
            );
          }),
          sharedPreferencesProvider.overrideWith((_) => sharedPreferences),
        ],
        child: MaterialApp(
          theme: getDefaultTheme(Brightness.light, true),
          localizationsDelegates: KaitekiLocalizations.localizationsDelegates,
          supportedLocales: KaitekiLocalizations.supportedLocales,
          home: Scaffold(body: widget),
        ),
      );
    }

    // Switch to home timeline
    await tester.pumpWidget(
      await wrapper(const Timeline.kind()),
    );

    await tester.pumpAndSettle();
    expect(find.text(TimelineKind.home.toString()), findsOneWidget);

    // Switch to federated timeline
    await tester.pumpWidget(
      await wrapper(const Timeline.kind(kind: TimelineKind.federated)),
    );

    await tester.pumpAndSettle();
    expect(find.byType(IconLandingWidget), findsOneWidget);

    // Switch to hybrid timeline
    await tester.pumpWidget(
      await wrapper(const Timeline.kind(kind: TimelineKind.hybrid)),
    );

    await tester.pumpAndSettle();
    expect(find.byType(IconLandingWidget), findsOneWidget);
  });
}
