import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/published_articles/data/data_sources/firestore_article_datasource.dart';
import 'package:news_app_clean_architecture/features/published_articles/data/data_sources/storage_datasource.dart';
import 'package:news_app_clean_architecture/features/published_articles/data/models/published_article_model.dart';
import 'package:news_app_clean_architecture/features/published_articles/domain/repository/published_articles_repository.dart';

class PublishedArticlesRepositoryImpl implements PublishedArticlesRepository {
  final FirestoreArticleDataSource _firestoreDataSource;
  final StorageDataSource _storageDataSource;

  PublishedArticlesRepositoryImpl(
    this._firestoreDataSource,
    this._storageDataSource,
  );

  @override
  Future<List<ArticleEntity>> getPublishedArticles() async {
    try {
      final articles = await _firestoreDataSource.getArticles();
      return articles;
    } catch (e) {
      throw Exception('Failed to get published articles: $e');
    }
  }

  @override
  Future<void> publishArticle({
    required String title,
    required String description,
    required String content,
    required String author,
    required dynamic imageFile,
    required String userId,
  }) async {
    try {
      // Generate a temporary article ID for the image path
      final tempArticleId = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload image first
      final imagePath = await _storageDataSource.uploadArticleImage(
        tempArticleId,
        imageFile,
      );

      // Create article model
      final article = PublishedArticleModel(
        title: title,
        description: description,
        content: content,
        author: author,
        urlToImage: imagePath,
        publishedAt: DateTime.now().toIso8601String(),
        userId: userId,
      );

      // Publish to Firestore
      await _firestoreDataSource.publishArticle(article);
    } catch (e) {
      throw Exception('Failed to publish article: $e');
    }
  }

  @override
  Future<void> deleteArticle(String articleId) async {
    try {
      await _firestoreDataSource.deleteArticle(articleId);
    } catch (e) {
      throw Exception('Failed to delete article: $e');
    }
  }

  @override
  Future<List<ArticleEntity>> getFavoriteArticles(String userId) async {
    try {
      final articles = await _firestoreDataSource.getFavoriteArticles(userId);
      return articles;
    } catch (e) {
      throw Exception('Failed to get favorite articles: $e');
    }
  }

  @override
  Future<void> toggleFavorite(String articleId, bool isFavorite, String userId) async {
    try {
      await _firestoreDataSource.toggleFavorite(articleId, isFavorite, userId);
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  @override
  Future<List<ArticleEntity>> getUserArticles(String userId) async {
    try {
      final articles = await _firestoreDataSource.getUserArticles(userId);
      return articles;
    } catch (e) {
      throw Exception('Failed to get user articles: $e');
    }
  }

  @override
  Future<List<ArticleEntity>> getOtherUsersArticles(String currentUserId) async {
    try {
      final articles = await _firestoreDataSource.getOtherUsersArticles(currentUserId);
      return articles;
    } catch (e) {
      throw Exception('Failed to get other users articles: $e');
    }
  }
}
