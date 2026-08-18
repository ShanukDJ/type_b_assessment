import 'package:equatable/equatable.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

class FetchInitialPostsEvent extends PostsEvent {
  final bool isRefresh;

  const FetchInitialPostsEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class FetchMorePostsEvent extends PostsEvent {
  const FetchMorePostsEvent();
}

class SearchPostsEvent extends PostsEvent {
  final String query;

  const SearchPostsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearchEvent extends PostsEvent {
  const ClearSearchEvent();
}

class RefreshPostsEvent extends PostsEvent {
  const RefreshPostsEvent();
}

class SelectPostEvent extends PostsEvent {
  final int postId;

  const SelectPostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}
