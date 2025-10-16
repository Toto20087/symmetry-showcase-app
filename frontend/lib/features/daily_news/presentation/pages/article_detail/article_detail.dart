import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../../injection_container.dart';
import '../../../../../features/published_articles/data/models/published_article_model.dart';
import '../../../../../features/published_articles/presentation/cubit/published_articles_cubit.dart';
import '../../../domain/entities/article.dart';
import '../../bloc/article/local/local_article_bloc.dart';
import '../../bloc/article/local/local_article_event.dart';

class ArticleDetailsView extends HookWidget {
  final ArticleEntity? article;
  final Function(String, bool)? onFavoriteToggle;

  const ArticleDetailsView({
    Key? key,
    this.article,
    this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFavorite = useState(article?.isFavorite ?? false);

    return BlocProvider(
      create: (_) => sl<LocalArticleBloc>(),
      child: Scaffold(
        body: _buildBody(context, isFavorite),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ValueNotifier<bool> isFavorite) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildArticleImageWithOverlay(context, isFavorite),
          _buildArticleTitle(),
          _buildArticleDescription(),
        ],
      ),
    );
  }

  Widget _buildArticleImageWithOverlay(BuildContext context, ValueNotifier<bool> isFavorite) {

    return Stack(
      children: [
        // Full-width image
        Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(article!.urlToImage!),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Gradient overlay at bottom for better text readability
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),

        // Back arrow button (top left)
        Positioned(
          top: 50,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),

        // Bookmark button (bottom right on image)
        Positioned(
          bottom: 16,
          right: 16,
          child: GestureDetector(
            onTap: () => _onFloatingActionButtonPressed(context, isFavorite),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isFavorite.value ? Icons.bookmark : Icons.bookmark_outline,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArticleTitle() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(
        article!.title!,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _buildArticleDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
      child: MarkdownBody(
        data: article!.content ?? '',
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
          h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
          h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.4),
          h3: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
        ),
      ),
    );
  }

  void _onBackButtonTapped(BuildContext context) {
    Navigator.pop(context);
  }

  void _onFloatingActionButtonPressed(BuildContext context, ValueNotifier<bool> isFavorite) async {
    // Check if article is a PublishedArticleModel with document ID
    if (article is PublishedArticleModel &&
        (article as PublishedArticleModel).documentId != null &&
        onFavoriteToggle != null) {
      final publishedArticle = article as PublishedArticleModel;
      final documentId = publishedArticle.documentId!;
      final currentFavoriteStatus = isFavorite.value;

      // Toggle favorite using callback
      try {
        // Update local state immediately for instant UI feedback
        isFavorite.value = !currentFavoriteStatus;

        await onFavoriteToggle!(documentId, currentFavoriteStatus);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.black,
              content: Text(currentFavoriteStatus ? 'Removed from favorites' : 'Added to favorites'),
            ),
          );
        }
      } catch (e) {
        // Revert state on error
        isFavorite.value = currentFavoriteStatus;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Failed to update favorite status'),
            ),
          );
        }
      }
    } else {
      // Fallback to original saved articles functionality
      BlocProvider.of<LocalArticleBloc>(context).add(SaveArticle(article!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.black,
          content: Text('Article saved successfully.'),
        ),
      );
    }
  }
}
