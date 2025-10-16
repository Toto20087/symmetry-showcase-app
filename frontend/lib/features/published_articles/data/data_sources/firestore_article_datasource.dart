import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/features/published_articles/data/models/published_article_model.dart';

abstract class FirestoreArticleDataSource {
  Future<List<PublishedArticleModel>> getArticles();
  Future<List<PublishedArticleModel>> getFavoriteArticles(String userId);
  Future<List<PublishedArticleModel>> getUserArticles(String userId);
  Future<List<PublishedArticleModel>> getOtherUsersArticles(String currentUserId);
  Future<void> publishArticle(PublishedArticleModel article);
  Future<void> deleteArticle(String articleId);
  Future<void> toggleFavorite(String articleId, bool isFavorite, String userId);
}

class FirestoreArticleDataSourceImpl implements FirestoreArticleDataSource {
  final FirebaseFirestore _firestore;

  FirestoreArticleDataSourceImpl(this._firestore);

  @override
  Future<List<PublishedArticleModel>> getArticles() async {
    try {
      final querySnapshot = await _firestore
          .collection('articles')
          .orderBy('publishedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PublishedArticleModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch articles: $e');
    }
  }

  @override
  Future<void> publishArticle(PublishedArticleModel article) async {
    try {
      await _firestore.collection('articles').add(article.toFirestore());
    } catch (e) {
      throw Exception('Failed to publish article: $e');
    }
  }

  @override
  Future<void> deleteArticle(String articleId) async {
    try {
      await _firestore.collection('articles').doc(articleId).delete();
    } catch (e) {
      throw Exception('Failed to delete article: $e');
    }
  }

  @override
  Future<List<PublishedArticleModel>> getFavoriteArticles(String userId) async {
    try {
      // Get the user's favorites from the favorites subcollection
      final favoritesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();

      if (favoritesSnapshot.docs.isEmpty) {
        return [];
      }

      // Get the article IDs from favorites
      final articleIds = favoritesSnapshot.docs.map((doc) => doc.id).toList();

      // Fetch all articles and filter by the favorite IDs
      final articlesSnapshot = await _firestore
          .collection('articles')
          .orderBy('publishedAt', descending: true)
          .get();

      return articlesSnapshot.docs
          .map((doc) => PublishedArticleModel.fromFirestore(doc))
          .where((article) => articleIds.contains(article.documentId))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch favorite articles: $e');
    }
  }

  @override
  Future<void> toggleFavorite(String articleId, bool isFavorite, String userId) async {
    try {
      final favoriteRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(articleId);

      if (isFavorite) {
        // Add to favorites
        await favoriteRef.set({
          'articleId': articleId,
          'favoritedAt': Timestamp.now(),
        });
      } else {
        // Remove from favorites
        await favoriteRef.delete();
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  @override
  Future<List<PublishedArticleModel>> getUserArticles(String userId) async {
    try {
      // Fetch all articles and filter in memory to avoid index requirement
      final querySnapshot = await _firestore
          .collection('articles')
          .orderBy('publishedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PublishedArticleModel.fromFirestore(doc))
          .where((article) => article.userId == userId)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user articles: $e');
    }
  }

  @override
  Future<List<PublishedArticleModel>> getOtherUsersArticles(String currentUserId) async {
    try {
      // Fetch all articles and filter in memory to avoid composite index requirement
      final querySnapshot = await _firestore
          .collection('articles')
          .orderBy('publishedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PublishedArticleModel.fromFirestore(doc))
          .where((article) => article.userId != currentUserId)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch other users articles: $e');
    }
  }
}
