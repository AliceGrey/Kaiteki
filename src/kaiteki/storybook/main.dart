import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:kaiteki/theming/default/themes.dart";
import "package:kaiteki/ui/shared/users/user_badge.dart";
import "package:storybook_flutter/storybook_flutter.dart";

import "stories/avatars.dart";
import "stories/count_buttons.dart";
import "stories/dialogs.dart";
import "stories/posts.dart";

void main() => runApp(const KaitekiStorybook());

class KaitekiStorybook extends StatelessWidget {
  const KaitekiStorybook({super.key});

  @override
  Widget build(BuildContext context) {
    return Storybook(
      wrapperBuilder: (context, child) => MaterialApp(
        theme: getDefaultTheme(Brightness.light, true),
        darkTheme: getDefaultTheme(Brightness.dark, true),
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) => Scaffold(
            // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            body: Center(child: child),
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
      stories: [
        discardPost,
        apiWebCompatibility,
        keyboardShortcuts,
        userBadges,
        poll,
        avatars,
        countButtons,
      ],
    );
  }
}

final userBadges = Story(
  name: "User badges",
  builder: (_) => const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      BotUserBadge(),
      SizedBox(width: 8),
      ModeratorUserBadge(),
      SizedBox(width: 8),
      AdministratorUserBadge(),
    ],
  ),
);

final countButtons = Story(
  name: "Count buttons",
  builder: (_) => const CountButtons(),
);
