import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/repository/article_repository_impl.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'features/daily_news/data/data_sources/local/app_database.dart';
import 'features/daily_news/domain/usecases/get_saved_article.dart';
import 'features/daily_news/domain/usecases/remove_article.dart';
import 'features/daily_news/domain/usecases/save_article.dart';
import 'features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'features/published_articles/data/data_sources/firestore_article_datasource.dart';
import 'features/published_articles/data/data_sources/storage_datasource.dart';
import 'features/published_articles/data/repository/published_articles_repository_impl.dart';
import 'features/published_articles/domain/repository/published_articles_repository.dart';
import 'features/published_articles/domain/usecases/get_published_articles.dart';
import 'features/published_articles/domain/usecases/publish_article_usecase.dart';
import 'features/published_articles/domain/usecases/get_favorite_articles.dart';
import 'features/published_articles/domain/usecases/get_user_articles.dart';
import 'features/published_articles/domain/usecases/get_other_users_articles.dart';
import 'features/published_articles/domain/usecases/toggle_favorite.dart';
import 'features/published_articles/presentation/cubit/published_articles_cubit.dart';
import 'features/auth/data/data_sources/firebase_auth_datasource.dart';
import 'features/auth/data/repository/auth_repository_impl.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  // Only initialize database on non-web platforms
  if (!kIsWeb) {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    sl.registerSingleton<AppDatabase>(database);
  }
  
  // Dio
  sl.registerSingleton<Dio>(Dio());

  // Dependencies
  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));

  if (!kIsWeb) {
    sl.registerSingleton<ArticleRepository>(
      ArticleRepositoryImpl(sl(),sl())
    );
  }
  
  //UseCases
  if (!kIsWeb) {
    sl.registerSingleton<GetArticleUseCase>(
      GetArticleUseCase(sl())
    );

    sl.registerSingleton<GetSavedArticleUseCase>(
      GetSavedArticleUseCase(sl())
    );

    sl.registerSingleton<SaveArticleUseCase>(
      SaveArticleUseCase(sl())
    );

    sl.registerSingleton<RemoveArticleUseCase>(
      RemoveArticleUseCase(sl())
    );
  }

  // Firebase instances
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  // Published Articles Data Sources
  sl.registerSingleton<FirestoreArticleDataSource>(
    FirestoreArticleDataSourceImpl(sl())
  );

  sl.registerSingleton<StorageDataSource>(
    StorageDataSourceImpl(sl())
  );

  // Published Articles Repository
  sl.registerSingleton<PublishedArticlesRepository>(
    PublishedArticlesRepositoryImpl(sl(), sl())
  );

  // Published Articles UseCases
  sl.registerSingleton<GetPublishedArticlesUseCase>(
    GetPublishedArticlesUseCase(sl())
  );

  sl.registerSingleton<PublishArticleUseCase>(
    PublishArticleUseCase(sl())
  );

  sl.registerSingleton<GetFavoriteArticlesUseCase>(
    GetFavoriteArticlesUseCase(sl())
  );

  sl.registerSingleton<GetUserArticlesUseCase>(
    GetUserArticlesUseCase(sl())
  );

  sl.registerSingleton<GetOtherUsersArticlesUseCase>(
    GetOtherUsersArticlesUseCase(sl())
  );

  sl.registerSingleton<ToggleFavoriteUseCase>(
    ToggleFavoriteUseCase(sl())
  );


  //Blocs
  if (!kIsWeb) {
    sl.registerFactory<RemoteArticlesBloc>(
      ()=> RemoteArticlesBloc(sl())
    );

    sl.registerFactory<LocalArticleBloc>(
      ()=> LocalArticleBloc(sl(),sl(),sl())
    );
  }

  sl.registerFactory<PublishedArticlesCubit>(
    ()=> PublishedArticlesCubit(sl(), sl(), sl(), sl(), sl(), sl())
  );

  // Auth Data Source
  sl.registerSingleton<FirebaseAuthDataSource>(
    FirebaseAuthDataSourceImpl(sl(), sl())
  );

  // Auth Repository
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(sl())
  );

  // Auth UseCases
  sl.registerSingleton<SignInWithEmailUseCase>(
    SignInWithEmailUseCase(sl())
  );

  sl.registerSingleton<SignUpWithEmailUseCase>(
    SignUpWithEmailUseCase(sl())
  );

  sl.registerSingleton<SignInWithGoogleUseCase>(
    SignInWithGoogleUseCase(sl())
  );

  sl.registerSingleton<SignOutUseCase>(
    SignOutUseCase(sl())
  );

  sl.registerSingleton<GetCurrentUserUseCase>(
    GetCurrentUserUseCase(sl())
  );

  // Auth Cubit
  sl.registerSingleton<AuthCubit>(
    AuthCubit(
      signInWithEmailUseCase: sl(),
      signUpWithEmailUseCase: sl(),
      signInWithGoogleUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    )
  );

}