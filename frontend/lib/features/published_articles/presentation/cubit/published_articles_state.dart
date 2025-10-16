import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

abstract class PublishedArticlesState extends Equatable {
  final List<ArticleEntity>? articles;

  const PublishedArticlesState({this.articles});

  @override
  List<Object?> get props => [articles];
}

class PublishedArticlesLoading extends PublishedArticlesState {
  const PublishedArticlesLoading();
}

class PublishedArticlesDone extends PublishedArticlesState {
  const PublishedArticlesDone(List<ArticleEntity> articles)
      : super(articles: articles);
}

class PublishedArticlesError extends PublishedArticlesState {
  const PublishedArticlesError();
}
