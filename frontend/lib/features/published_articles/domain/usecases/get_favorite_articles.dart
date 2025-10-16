import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/published_articles/domain/repository/published_articles_repository.dart';

class GetFavoriteArticlesParams {
  final String userId;

  GetFavoriteArticlesParams({required this.userId});
}

/// UseCase to get favorite articles for a specific user
class GetFavoriteArticlesUseCase implements UseCase<List<ArticleEntity>, GetFavoriteArticlesParams> {
  final PublishedArticlesRepository _repository;

  GetFavoriteArticlesUseCase(this._repository);

  @override
  Future<List<ArticleEntity>> call({GetFavoriteArticlesParams? params}) async {
    if (params == null) {
      throw ArgumentError('userId parameter is required');
    }
    return await _repository.getFavoriteArticles(params.userId);
  }
}
