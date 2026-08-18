import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:type_b/features/posts/domain/entities/post_entity.dart';
import 'package:type_b/features/posts/presentation/widgets/post_card_widget.dart';

void main() {
  const tPost = PostEntity(
    id: 1,
    title: 'Test Post Title',
    body: 'Test post body content that is long enough to verify rendering.',
    tags: ['flutter', 'test'],
    likes: 42,
    userId: 1,
    authorName: 'John Doe',
    authorInitials: 'JD',
  );

  Widget createWidgetUnderTest({required VoidCallback onTap}) {
    return MaterialApp(
      home: Scaffold(
        body: PostCardWidget(post: tPost, onTap: onTap),
      ),
    );
  }

  group('PostCardWidget', () {
    testWidgets('renders post title, author, and likes count', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(onTap: () {}));

      expect(find.text('Test Post Title'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('JD'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('triggers onTap callback when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        createWidgetUnderTest(
          onTap: () {
            tapped = true;
          },
        ),
      );

      await tester.tap(find.byType(PostCardWidget));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
