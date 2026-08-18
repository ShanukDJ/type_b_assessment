import 'package:flutter_test/flutter_test.dart';
import 'package:type_b/features/posts/data/models/post_model.dart';
import 'package:type_b/features/posts/data/models/post_response_model.dart';
import 'package:type_b/features/posts/domain/entities/post_response_entity.dart';

void main() {
  const tPostModel = PostModel(
    id: 1,
    title: 'Post Title',
    body: 'Post Body',
    tags: ['news'],
    likes: 10,
    userId: 1,
  );

  const tPostResponseModel = PostResponseModel(
    posts: [tPostModel],
    total: 251,
    skip: 0,
    limit: 10,
  );

  group('PostResponseModel', () {
    test('isSubclassOfPostResponseEntity', () {
      expect(tPostResponseModel, isA<PostResponseEntity>());
    });

    test('fromJson_validJson_returnsPostResponseModel', () {
      final jsonMap = {
        'posts': [
          {
            'id': 1,
            'title': 'Post Title',
            'body': 'Post Body',
            'tags': ['news'],
            'reactions': {'likes': 10, 'dislikes': 0},
            'views': 0,
            'userId': 1,
          },
        ],
        'total': 251,
        'skip': 0,
        'limit': 10,
      };

      final result = PostResponseModel.fromJson(jsonMap);

      expect(result.posts.length, equals(1));
      expect(result.total, equals(251));
      expect(result.skip, equals(0));
      expect(result.limit, equals(10));
      expect(result.hasReachedMax, isFalse);
    });

    test('hasReachedMax_whenPostsEqualTotal_returnsTrue', () {
      const response = PostResponseModel(
        posts: [tPostModel],
        total: 1,
        skip: 0,
        limit: 10,
      );

      expect(response.hasReachedMax, isTrue);
    });

    test('toJson_returnsExpectedMap', () {
      final jsonMap = tPostResponseModel.toJson();

      expect(jsonMap['total'], equals(251));
      expect(jsonMap['skip'], equals(0));
      expect(jsonMap['limit'], equals(10));
      expect((jsonMap['posts'] as List).length, equals(1));
    });
  });
}
