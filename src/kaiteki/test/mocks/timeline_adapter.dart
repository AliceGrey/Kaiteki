import "package:kaiteki/auth/login_typedefs.dart";
import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/api_type.dart";
import "package:kaiteki/fediverse/capabilities.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/fediverse/model/timeline_query.dart";
import "package:kaiteki/model/auth/login_result.dart";
import "package:kaiteki/model/auth/secret.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

class TimelineAdapter extends BackendAdapter {
  final Set<TimelineKind> brokenTimelines;

  @override
  final TimelineAdapterCapabilities capabilities;

  TimelineAdapter(
    this.capabilities, [
    this.brokenTimelines = const {},
  ]);

  @override
  FutureOr<void> applySecrets(
    ClientSecret? clientSecret,
    AccountSecret accountSecret,
  ) {}

  @override
  Future<User?> followUser(String id) => throw UnimplementedError();

  @override
  FutureOr<Instance> getInstance() => throw UnimplementedError();

  @override
  Future<User> getMyself() => throw UnimplementedError();

  @override
  Future<Post> getPostById(String id) => throw UnimplementedError();

  @override
  Future<List<User>> getRepeatees(String id) => throw UnimplementedError();

  @override
  Future<List<Post>> getStatusesOfUserById(
    String id, {
    TimelineQuery<String>? query,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Post>> getThread(Post reply) => throw UnimplementedError();

  @override
  Future<List<Post>> getTimeline(
    TimelineKind type, {
    TimelineQuery<String>? query,
  }) async {
    if (brokenTimelines.contains(type)) throw UnimplementedError();
    return [
      if (query?.sinceId == null && query?.untilId == null)
        Post(
          postedAt: DateTime.now(),
          author: const User(
            displayName: "User",
            host: "example.social",
            id: "0",
            username: "User",
          ),
          id: DateTime.now().toIso8601String(),
          content: type.toString(),
        ),
    ];
  }

  @override
  Future<User> getUser(String username, [String? instance]) =>
      throw UnimplementedError();

  @override
  Future<User> getUserById(String id) => throw UnimplementedError();

  @override
  Future<LoginResult> login(
    ClientSecret? clientSecret,
    CredentialsCallback requestCredentials,
    CodeCallback requestMfa,
    OAuthCallback requestOAuth,
  ) =>
      throw UnimplementedError();

  @override
  Future<Post> postStatus(PostDraft draft, {Post? parentPost}) =>
      throw UnimplementedError();

  @override
  Future<void> repeatPost(String id) => throw UnimplementedError();

  @override
  Future<void> unrepeatPost(String id) => throw UnimplementedError();

  @override
  Future<Attachment> uploadAttachment(AttachmentDraft draft) =>
      throw UnimplementedError();

  @override
  Future<PaginatedList<String?, User>> getFollowers(
    String userId, {
    String? sinceId,
    String? untilId,
  }) =>
      throw UnimplementedError();

  @override
  Future<PaginatedList<String?, User>> getFollowing(
    String userId, {
    String? sinceId,
    String? untilId,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> deleteAccount(String password) => throw UnimplementedError();

  @override
  Future<User> lookupUser(String username, [String? host]) =>
      throw UnimplementedError();

  @override
  ApiType get type => ApiType.mastodon;
}

class TimelineAdapterCapabilities extends AdapterCapabilities {
  TimelineAdapterCapabilities([this.supportedTimelines = const {}]);

  @override
  Set<Formatting> get supportedFormattings => {};

  @override
  Set<Visibility> get supportedScopes => {};

  @override
  final Set<TimelineKind> supportedTimelines;

  @override
  bool get supportsSubjects => false;
}
