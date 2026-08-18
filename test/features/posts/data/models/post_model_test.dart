import 'package:flutter_test/flutter_test.dart';
import 'package:type_b/features/posts/data/models/post_model.dart';
import 'package:type_b/features/posts/domain/entities/post_entity.dart';

void main() {
  const tPostModel = PostModel(
    id: 1,
    title: 'His mother had always taught him',
    body: 'His mother had always taught him not to ever think of the word...',
    tags: ['history', 'american'],
    likes: 192,
    dislikes: 25,
    views: 305,
    userId: 121,
  );

  group('PostModel', () {
    test('postModel_isSubclassOfPostEntity', () {
      expect(tPostModel, isA<PostEntity>());
    });

    test('fromJson_validObjectReactions_returnsValidPostModel', () {
      final jsonMap = {
        'id': 1,
        'title': 'His mother had always taught him',
        'body':
            'His mother had always taught him not to ever think of the word...',
        'tags': ['history', 'american'],
        'reactions': {'likes': 192, 'dislikes': 25},
        'views': 305,
        'userId': 121,
      };

      final result = PostModel.fromJson(jsonMap);

      expect(result, equals(tPostModel));
      expect(result.likes, equals(192));
      expect(result.dislikes, equals(25));
      expect(result.views, equals(305));
      expect(result.displayAuthor, isNotEmpty);
      expect(result.displayInitials, isNotEmpty);
      expect(result.estimatedReadingTime, contains('min read'));
      expect(result.timeAgo, contains('h ago'));
    });

    test('fromJson_intReactions_parsesLikesCorrectly', () {
      final jsonMap = {
        'id': 2,
        'title': 'He was an expert but not in a discipline',
        'body':
            'He was an expert but not in a discipline that could ever help him...',
        'tags': ['fiction'],
        'reactions': 85,
        'views': 120,
        'userId': 45,
      };

      final result = PostModel.fromJson(jsonMap);

      expect(result.id, equals(2));
      expect(result.likes, equals(85));
      expect(result.dislikes, equals(0));
    });

    test('toJson_returnsExpectedMap', () {
      final jsonMap = tPostModel.toJson();

      expect(jsonMap['id'], equals(1));
      expect(jsonMap['title'], equals('His mother had always taught him'));
      expect(jsonMap['reactions']['likes'], equals(192));
      expect(jsonMap['reactions']['dislikes'], equals(25));
      expect(jsonMap['views'], equals(305));
    });
  });
}
