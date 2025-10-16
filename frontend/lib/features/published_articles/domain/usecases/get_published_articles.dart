import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/published_articles/domain/repository/published_articles_repository.dart';

/// UseCase to get published articles from Firebase
class GetPublishedArticlesUseCase implements UseCase<List<ArticleEntity>, void> {
  final PublishedArticlesRepository _repository;

  GetPublishedArticlesUseCase(this._repository);

  @override
  Future<List<ArticleEntity>> call({void params}) async {
    return await _repository.getPublishedArticles();
  }
}
