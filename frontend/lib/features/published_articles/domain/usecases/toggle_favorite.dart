import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/published_articles/domain/repository/published_articles_repository.dart';

class ToggleFavoriteParams {
  final String articleId;
  final bool isFavorite;
  final String userId;

  ToggleFavoriteParams({
    required this.articleId,
    required this.isFavorite,
    required this.userId,
  });
}

/// UseCase to toggle favorite status of an article for a specific user
class ToggleFavoriteUseCase implements UseCase<void, ToggleFavoriteParams> {
  final PublishedArticlesRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  @override
  Future<void> call({ToggleFavoriteParams? params}) async {
    if (params == null) {
      throw ArgumentError('ToggleFavoriteParams are required');
    }
    await _repository.toggleFavorite(
      params.articleId,
      params.isFavorite,
      params.userId,
    );
  }
}
