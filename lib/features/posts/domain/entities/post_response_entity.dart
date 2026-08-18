import 'package:equatable/equatable.dart';
import 'post_entity.dart';

class PostResponseEntity extends Equatable {
  final List<PostEntity> posts;
  final int total;
  final int skip;
  final int limit;

  const PostResponseEntity({
    required this.posts,
    required this.total,
    required this.skip,
    required this.limit,
  });

  bool get hasReachedMax => skip + posts.length >= total;

  @override
  List<Object?> get props => [posts, total, skip, limit];
}
