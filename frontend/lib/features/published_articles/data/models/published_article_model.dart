import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

class PublishedArticleModel extends ArticleEntity {
  final String? documentId; // Store Firestore document ID

  const PublishedArticleModel({
    super.id,
    required super.title,
    super.description,
    required super.content,
    required super.author,
    required super.urlToImage,
    required super.publishedAt,
    super.isFavorite = false,
    super.userId,
    this.documentId,
  });

  // Convert from Firestore document to model
  factory PublishedArticleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PublishedArticleModel(
      id: doc.id.hashCode, // Generate numeric ID from document ID
      documentId: doc.id, // Store actual document ID
      title: data['title'] ?? '',
      description: data['description'],
      content: data['content'] ?? '',
      author: data['author'] ?? '',
      urlToImage: data['thumbnailURL'] ?? '',
      publishedAt: (data['publishedAt'] as Timestamp?)?.toDate().toIso8601String() ?? '',
      isFavorite: data['isFavorite'] ?? false,
      userId: data['userId'] ?? '',
    );
  }

  // Convert model to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description ?? '',
      'content': content,
      'author': author,
      'thumbnailURL': urlToImage,
      'isFavorite': isFavorite ?? false,
      'publishedAt': Timestamp.fromDate(DateTime.parse(publishedAt!)),
      'userId': userId,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    };
  }

  // Convert from ArticleEntity to PublishedArticleModel
  factory PublishedArticleModel.fromEntity(ArticleEntity entity) {
    return PublishedArticleModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      content: entity.content,
      author: entity.author,
      urlToImage: entity.urlToImage,
      publishedAt: entity.publishedAt,
      isFavorite: entity.isFavorite,
      userId: entity.userId,
    );
  }
}
