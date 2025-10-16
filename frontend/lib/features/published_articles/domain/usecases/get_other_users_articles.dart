import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/published_articles/domain/repository/published_articles_repository.dart';

class GetOtherUsersArticlesParams {
  final String currentUserId;

  GetOtherUsersArticlesParams({required this.currentUserId});
}

/// UseCase to get articles published by other users (not the current user)
class GetOtherUsersArticlesUseCase implements UseCase<List<ArticleEntity>, GetOtherUsersArticlesParams> {
  final PublishedArticlesRepository _repository;

  GetOtherUsersArticlesUseCase(this._repository);

  @override
  Future<List<ArticleEntity>> call({GetOtherUsersArticlesParams? params}) async {
    if (params == null) {
      throw ArgumentError('currentUserId parameter is required');
    }
    return await _repository.getOtherUsersArticles(params.currentUserId);
  }
}
