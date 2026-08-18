import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_strings.dart';

class PostEntity extends Equatable {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final int likes;
  final int dislikes;
  final int views;
  final int userId;
  final String? authorName;
  final String? authorInitials;

  const PostEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.likes,
    this.dislikes = 0,
    this.views = 0,
    required this.userId,
    this.authorName,
    this.authorInitials,
  });

  String get displayAuthor {
    if (authorName != null && authorName!.isNotEmpty) return authorName!;
    final authors = [
      'Alice Miller',
      'John Doe',
      'Jessica Watson',
      'Robert Fox',
      'Emily Carter',
      'David Clark',
      'Sophia Turner',
      'James Wilson',
    ];
    return authors[userId % authors.length];
  }

  String get displayInitials {
    if (authorInitials != null && authorInitials!.isNotEmpty) {
      return authorInitials!;
    }
    final name = displayAuthor;
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length > 2 ? 2 : name.length).toUpperCase();
  }

  String get estimatedReadingTime {
    final wordCount = body.split(RegExp(r'\s+')).length;
    final minutes = (wordCount / 100).ceil();
    return '$minutes ${AppStrings.minReadSuffix}';
  }

  String get timeAgo {
    final hours = ((id * 3) % 24) + 1;
    return '$hours${AppStrings.hoursAgoSuffix}';
  }

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    tags,
    likes,
    dislikes,
    views,
    userId,
    authorName,
    authorInitials,
  ];
}
