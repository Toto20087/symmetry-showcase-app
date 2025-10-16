import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/published_articles/domain/repository/published_articles_repository.dart';

class GetUserArticlesParams {
  final String userId;

  GetUserArticlesParams({required this.userId});
}

/// UseCase to get articles published by a specific user
class GetUserArticlesUseCase implements UseCase<List<ArticleEntity>, GetUserArticlesParams> {
  final PublishedArticlesRepository _repository;

  GetUserArticlesUseCase(this._repository);

  @override
  Future<List<ArticleEntity>> call({GetUserArticlesParams? params}) async {
    if (params == null) {
      throw ArgumentError('userId parameter is required');
    }
    return await _repository.getUserArticles(params.userId);
  }
}
