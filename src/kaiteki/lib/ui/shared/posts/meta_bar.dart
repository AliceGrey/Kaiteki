import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/shared/users/user_badge.dart";
import "package:kaiteki/ui/shared/users/user_display_name_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";

class MetaBar extends ConsumerWidget {
  const MetaBar({
    super.key,
    required Post post,
    this.twolineAuthor = false,
    this.showAvatar = false,
    this.showTime = true,
    this.showVisibility = true,
    this.showLanguage = true,
    this.onOpen,
  }) : _post = post;

  final Post _post;
  final bool showAvatar;
  final bool showTime;
  final bool showVisibility;
  final bool showLanguage;
  final bool twolineAuthor;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 32,
      ),
      child: Row(
        children: [
          ...buildLeft(context, ref),
          const SizedBox(width: 8),
          ...buildRight(context),
        ],
      ),
    );
  }

  List<Widget> buildLeft(BuildContext context, WidgetRef ref) {
    final isAdministrator = _post.author.flags?.isAdministrator ?? false;
    final isModerator = _post.author.flags?.isModerator ?? false;
    final isBot = _post.author.type == UserType.bot;
    return [
      if (showAvatar)
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: AvatarWidget(_post.author, size: 40),
        ),
      Expanded(
        child: Row(
          children: [
            Flexible(
              child: UserDisplayNameWidget(
                _post.author,
                orientation: twolineAuthor ? Axis.vertical : Axis.horizontal,
              ),
            ),
            if (ref.watch(showUserBadges).value) ...[
              if (isAdministrator) ...[
                const SizedBox(width: 8),
                const AdministratorUserBadge(),
              ],
              if (isModerator) ...[
                const SizedBox(width: 8),
                const ModeratorUserBadge(),
              ],
              if (isBot) ...[
                const SizedBox(width: 8),
                const BotUserBadge(),
              ],
            ],
          ],
        ),
      ),
    ];
  }

  List<Widget> buildRight(BuildContext context) {
    final visibility = _post.visibility;
    final secondaryColor = Theme.of(context).disabledColor;
    final secondaryTextTheme = TextStyle(color: secondaryColor);
    final l10n = context.l10n;

    const iconSize = 18.0;

    final language = _post.language;
    return [
      if (_post.state.pinned)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Tooltip(
            message: l10n.postPinned,
            child: Icon(
              Icons.push_pin_rounded,
              size: iconSize,
              color: secondaryColor,
            ),
          ),
        ),
      if (showLanguage && language != null)
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            language,
            style: (Theme.of(context).ktkTextTheme?.monospaceTextStyle ??
                    DefaultKaitekiTextTheme(context).monospaceTextStyle)
                .copyWith(color: secondaryColor),
          ),
        ),
      if (showTime)
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Tooltip(
            message: _post.postedAt.toString(),
            child: Text(
              DateTime.now().difference(_post.postedAt).toStringHuman(
                    context: context,
                  ),
              style: secondaryTextTheme,
            ),
          ),
        ),
      if (visibility != null && showVisibility)
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Tooltip(
            message: visibility.toDisplayString(l10n),
            child: Icon(
              visibility.toIconData(),
              size: iconSize,
              color: secondaryColor,
            ),
          ),
        ),
      if (onOpen == null)
        const SizedBox(width: 8)
      else
        IconButton(
          icon: Icon(
            Icons.open_in_full_rounded,
            size: iconSize,
            color: secondaryColor,
          ),
          visualDensity: VisualDensity.compact,
          onPressed: onOpen,
          tooltip: "Open post",
          splashRadius: 16,
        ),
    ];
  }
}
