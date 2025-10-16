import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/published_articles/domain/usecases/get_published_articles.dart';
import 'package:news_app_clean_architecture/features/published_articles/domain/usecases/publish_article_usecase.dart';
import 'package:news_app_clean_architecture/features/published_articles/domain/usecases/get_favorite_articles.dart';
import 'package:news_app_clean_architecture/features/published_articles/domain/usecases/get_user_articles.dart';
import 'package:news_app_clean_architecture/features/published_articles/domain/usecases/get_other_users_articles.dart';
import 'package:news_app_clean_architecture/features/published_articles/domain/usecases/toggle_favorite.dart';
import 'package:news_app_clean_architecture/features/published_articles/presentation/cubit/published_articles_state.dart';

enum ArticleFilter { otherUsers, favorites, myNews }

class PublishedArticlesCubit extends Cubit<PublishedArticlesState> {
  final GetPublishedArticlesUseCase _getPublishedArticlesUseCase;
  final PublishArticleUseCase _publishArticleUseCase;
  final GetFavoriteArticlesUseCase _getFavoriteArticlesUseCase;
  final GetUserArticlesUseCase _getUserArticlesUseCase;
  final GetOtherUsersArticlesUseCase _getOtherUsersArticlesUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  ArticleFilter _currentFilter = ArticleFilter.otherUsers;
  String? _currentUserId;

  ArticleFilter get currentFilter => _currentFilter;

  PublishedArticlesCubit(
    this._getPublishedArticlesUseCase,
    this._publishArticleUseCase,
    this._getFavoriteArticlesUseCase,
    this._getUserArticlesUseCase,
    this._getOtherUsersArticlesUseCase,
    this._toggleFavoriteUseCase,
  ) : super(const PublishedArticlesLoading());

  void setCurrentUserId(String userId) {
    _currentUserId = userId;
  }

  Future<void> getPublishedArticles({ArticleFilter? filter}) async {
    if (filter != null) {
      _currentFilter = filter;
    }

    emit(const PublishedArticlesLoading());
    try {
      List<ArticleEntity> articles;

      switch (_currentFilter) {
        case ArticleFilter.favorites:
          if (_currentUserId == null) {
            articles = [];
          } else {
            articles = await _getFavoriteArticlesUseCase(
              params: GetFavoriteArticlesParams(userId: _currentUserId!),
            );
          }
          break;
        case ArticleFilter.myNews:
          if (_currentUserId == null) {
            articles = [];
          } else {
            articles = await _getUserArticlesUseCase(
              params: GetUserArticlesParams(userId: _currentUserId!),
            );
          }
          break;
        case ArticleFilter.otherUsers:
        default:
          if (_currentUserId == null) {
            articles = await _getPublishedArticlesUseCase();
          } else {
            articles = await _getOtherUsersArticlesUseCase(
              params: GetOtherUsersArticlesParams(currentUserId: _currentUserId!),
            );
          }
          break;
      }

      emit(PublishedArticlesDone(articles));
    } catch (e) {
      emit(const PublishedArticlesError());
    }
  }

  // For backward compatibility
  bool get isShowingFavorites => _currentFilter == ArticleFilter.favorites;

  void toggleFavoritesFilter() {
    _currentFilter = _currentFilter == ArticleFilter.favorites
        ? ArticleFilter.otherUsers
        : ArticleFilter.favorites;
    getPublishedArticles();
  }

  Future<void> publishArticle({
    required String title,
    required String description,
    required String content,
    required String author,
    required dynamic imageFile,
    required String userId,
  }) async {
    try {
      await _publishArticleUseCase(
        params: PublishArticleParams(
          title: title,
          description: description,
          content: content,
          author: author,
          imageFile: imageFile,
          userId: userId,
        ),
      );
      // Refresh the list after publishing
      await getPublishedArticles();
    } catch (e) {
      emit(const PublishedArticlesError());
    }
  }

  Future<void> toggleArticleFavorite(String articleId, bool currentFavoriteStatus) async {
    if (_currentUserId == null) return;

    try {
      await _toggleFavoriteUseCase(
        params: ToggleFavoriteParams(
          articleId: articleId,
          isFavorite: !currentFavoriteStatus,
          userId: _currentUserId!,
        ),
      );
      // Refresh the list after toggling
      await getPublishedArticles();
    } catch (e) {
      emit(const PublishedArticlesError());
    }
  }
}
