import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/published_articles/domain/repository/published_articles_repository.dart';

class PublishArticleParams {
  final String title;
  final String description;
  final String content;
  final String author;
  final dynamic imageFile;
  final String userId;

  PublishArticleParams({
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.imageFile,
    required this.userId,
  });
}

class PublishArticleUseCase implements UseCase<void, PublishArticleParams> {
  final PublishedArticlesRepository _repository;

  PublishArticleUseCase(this._repository);

  @override
  Future<void> call({PublishArticleParams? params}) async {
    if (params == null) {
      throw Exception('Parameters are required');
    }

    await _repository.publishArticle(
      title: params.title,
      description: params.description,
      content: params.content,
      author: params.author,
      imageFile: params.imageFile,
      userId: params.userId,
    );
  }
}
