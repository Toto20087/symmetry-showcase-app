import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

abstract class PublishedArticlesRepository {
  Future<List<ArticleEntity>> getPublishedArticles();
  Future<List<ArticleEntity>> getFavoriteArticles(String userId);
  Future<List<ArticleEntity>> getUserArticles(String userId);
  Future<List<ArticleEntity>> getOtherUsersArticles(String currentUserId);
  Future<void> publishArticle({
    required String title,
    required String description,
    required String content,
    required String author,
    required dynamic imageFile,
    required String userId,
  });
  Future<void> deleteArticle(String articleId);
  Future<void> toggleFavorite(String articleId, bool isFavorite, String userId);
}
