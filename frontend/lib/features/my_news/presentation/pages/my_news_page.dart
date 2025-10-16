import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article_tile.dart';
import 'package:news_app_clean_architecture/features/published_articles/presentation/cubit/published_articles_cubit.dart';
import 'package:news_app_clean_architecture/features/published_articles/presentation/cubit/published_articles_state.dart';
import 'package:news_app_clean_architecture/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:news_app_clean_architecture/features/auth/presentation/cubit/auth_state.dart';

class MyNewsPage extends StatefulWidget {
  const MyNewsPage({Key? key}) : super(key: key);

  @override
  State<MyNewsPage> createState() => _MyNewsPageState();
}

class _MyNewsPageState extends State<MyNewsPage> {
  @override
  void initState() {
    super.initState();
    // Load user's own articles
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<PublishedArticlesCubit>().setCurrentUserId(authState.user.uid);
    }
    context.read<PublishedArticlesCubit>().getPublishedArticles(filter: ArticleFilter.myNews);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My News',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<PublishedArticlesCubit, PublishedArticlesState>(
        builder: (context, state) {
          if (state is PublishedArticlesLoading) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (state is PublishedArticlesError) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Failed to load articles'),
                ],
              ),
            );
          }
          if (state is PublishedArticlesDone) {
            final articles = state.articles!;
            if (articles.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.article_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No articles published yet',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return _buildNewsCard(article);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildNewsCard(ArticleEntity article) {
    return GestureDetector(
      onTap: () => _onArticlePressed(context, article),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey[200],
                child: article.urlToImage != null
                    ? Image.network(
                        article.urlToImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.image, size: 30, color: Colors.grey),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(Icons.image, size: 30, color: Colors.grey),
                      ),
              ),
            ),

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.edit, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          article.author ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.lightbulb, size: 12, color: Color(0xFF1E88E5)),
                            SizedBox(width: 4),
                            Text(
                              'Innovation',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF1E88E5),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        '7 hours ago',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFFF9F43),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) async {
    final cubit = context.read<PublishedArticlesCubit>();

    await Navigator.pushNamed(
      context,
      '/ArticleDetails',
      arguments: {
        'article': article,
        'onFavoriteToggle': (String documentId, bool currentStatus) async {
          await cubit.toggleArticleFavorite(documentId, currentStatus);
        },
      },
    );

    // Refresh the list when coming back
    if (mounted) {
      cubit.getPublishedArticles(filter: ArticleFilter.myNews);
    }
  }
}
