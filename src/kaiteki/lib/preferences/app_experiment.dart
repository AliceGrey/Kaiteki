import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:kaiteki/preferences/app_preferences.dart";

enum AppExperiment {
  remoteUserFetching(
    "Fetch users from remote instances",
    "Allows querying the remote instance for user details",
  ),
  timelineViews("Timeline views"),
  denseReactions(
    "Denser reactions",
    "Reduces the spacing between reactions in order to show more of them",
  ),
  newUserScreen(
    "New User Screen",
    "Use the new design of the user screen",
  ),
  feedback(
    "App Feedback",
    "Enable the feedback screen; currently unfunctional",
  ),
  chats("Chats"),
  instanceVetting(
    "Instance vetting",
    "See the information of an instance at a glance",
  ),
  userSignatures(
    "User signatures",
    "Show the user's bio under their posts",
  );

  final String displayName;
  final String? description;

  const AppExperiment(this.displayName, [this.description]);

  Provider<bool> get provider => experimentsProvider(this);
}

final experimentsProvider = Provider.family<bool, AppExperiment>(
  (ref, e) => ref.watch(experiments.select((v) => v.value.contains(e))),
  dependencies: [experiments],
);
