import 'package:flutter/material.dart';

import '../../features/daily_news/domain/entities/article.dart';
import '../../features/daily_news/presentation/pages/article_detail/article_detail.dart';
import '../../features/daily_news/presentation/pages/home/daily_news.dart';
import '../../features/daily_news/presentation/pages/saved_article/saved_article.dart';
import '../../features/published_articles/presentation/pages/published_articles_page.dart';
import '../../features/published_articles/presentation/pages/publish_article_page.dart';
import '../../features/published_articles/presentation/pages/publishing_loading_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart' as signup;
import '../../features/main_navigation/presentation/pages/main_navigation_page.dart';


class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const MainNavigationPage());

      case '/DailyNews':
        return _materialRoute(const DailyNews());

      case '/ArticleDetails':
        final args = settings.arguments;
        if (args is Map) {
          return _materialRoute(ArticleDetailsView(
            article: args['article'] as ArticleEntity,
            onFavoriteToggle: args['onFavoriteToggle'] as Function(String, bool)?,
          ));
        } else {
          return _materialRoute(ArticleDetailsView(article: args as ArticleEntity));
        }

      case '/SavedArticles':
        return _materialRoute(const SavedArticles());

      case '/PublishArticle':
        return _materialRoute(const PublishArticlePage());

      case '/PublishingLoading':
        return _materialRoute(const PublishingLoadingPage());

      case '/Login':
        return _materialRoute(const LoginPage());

      case '/Signup':
        return _materialRoute(const signup.SignUpPage());

      default:
        return _materialRoute(const MainNavigationPage());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
