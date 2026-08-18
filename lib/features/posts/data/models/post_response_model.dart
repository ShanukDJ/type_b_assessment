import '../../domain/entities/post_response_entity.dart';
import 'post_model.dart';

class PostResponseModel extends PostResponseEntity {
  const PostResponseModel({
    required super.posts,
    required super.total,
    required super.skip,
    required super.limit,
  });

  factory PostResponseModel.fromJson(Map<String, dynamic> json) {
    final rawPosts = json['posts'];
    final List<PostModel> parsedPosts = [];

    if (rawPosts is List) {
      for (final item in rawPosts) {
        if (item is Map<String, dynamic>) {
          parsedPosts.add(PostModel.fromJson(item));
        }
      }
    }

    return PostResponseModel(
      posts: parsedPosts,
      total: (json['total'] as num?)?.toInt() ?? 0,
      skip: (json['skip'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts': posts.map((e) => (e as PostModel).toJson()).toList(),
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }
}
