import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/debouncer.dart';
import '../bloc/posts_bloc.dart';
import '../bloc/posts_event.dart';

class SearchBarWidget extends StatefulWidget {
  final AppConfig appConfig;

  const SearchBarWidget({super.key, required this.appConfig});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _controller;
  late final Debouncer _debouncer;
  bool _hasQuery = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _debouncer = Debouncer(milliseconds: widget.appConfig.searchDebounceMs);
    _controller.addListener(() {
      final hasText = _controller.text.isNotEmpty;
      if (hasText != _hasQuery) {
        setState(() {
          _hasQuery = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    _debouncer.run(() {
      if (mounted) {
        if (query.trim().isEmpty) {
          context.read<PostsBloc>().add(const ClearSearchEvent());
        } else {
          context.read<PostsBloc>().add(SearchPostsEvent(query.trim()));
        }
      }
    });
  }

  void _clearSearch() {
    _controller.clear();
    _debouncer.cancel();
    context.read<PostsBloc>().add(const ClearSearchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.line.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        child: TextField(
          controller: _controller,
          onChanged: _onChanged,
          textInputAction: TextInputAction.search,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: AppStrings.searchPostsPlaceholder,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondary.withValues(alpha: 0.8),
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.secondary,
              size: 20,
            ),
            suffixIcon: _hasQuery
                ? IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.secondary,
                      size: 18,
                    ),
                    onPressed: _clearSearch,
                  )
                : null,
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 13,
            ),
          ),
        ),
      ),
    );
  }
}
