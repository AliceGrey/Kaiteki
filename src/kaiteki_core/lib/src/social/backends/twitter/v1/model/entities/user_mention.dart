import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki_core/utils.dart';
import 'package:kaiteki_core/src/social/backends/twitter/v1/model/entities/entity.dart';

part 'user_mention.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserMention extends Entity {
  final int id;
  final String idStr;
  final String name;
  final String screenName;

  const UserMention({
    required this.id,
    required this.idStr,
    required this.name,
    required this.screenName,
    required List<int> indices,
  }) : super(indices);

  factory UserMention.fromJson(JsonMap json) => _$UserMentionFromJson(json);

  JsonMap toJson() => _$UserMentionToJson(this);
}
