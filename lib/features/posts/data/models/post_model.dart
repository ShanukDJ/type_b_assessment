import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.title,
    required super.body,
    required super.tags,
    required super.likes,
    super.dislikes = 0,
    super.views = 0,
    required super.userId,
    super.authorName,
    super.authorInitials,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    int parsedLikes = 0;
    int parsedDislikes = 0;

    final reactionsRaw = json['reactions'];
    if (reactionsRaw is Map<String, dynamic>) {
      parsedLikes = (reactionsRaw['likes'] as num?)?.toInt() ?? 0;
      parsedDislikes = (reactionsRaw['dislikes'] as num?)?.toInt() ?? 0;
    } else if (reactionsRaw is num) {
      parsedLikes = reactionsRaw.toInt();
    }

    final tagsRaw = json['tags'];
    final List<String> parsedTags = [];
    if (tagsRaw is List) {
      for (final tag in tagsRaw) {
        if (tag != null) parsedTags.add(tag.toString());
      }
    }

    return PostModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      tags: parsedTags,
      likes: parsedLikes,
      dislikes: parsedDislikes,
      views: (json['views'] as num?)?.toInt() ?? 0,
      userId: json['userId'] is int
          ? json['userId'] as int
          : int.tryParse(json['userId']?.toString() ?? '0') ?? 0,
      authorName: json['authorName']?.toString(),
      authorInitials: json['authorInitials']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'tags': tags,
      'reactions': {'likes': likes, 'dislikes': dislikes},
      'views': views,
      'userId': userId,
      'authorName': authorName,
      'authorInitials': authorInitials,
    };
  }
}
