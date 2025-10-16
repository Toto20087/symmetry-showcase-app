import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/published_articles/presentation/pages/published_articles_page.dart';
import 'package:news_app_clean_architecture/features/my_news/presentation/pages/my_news_page.dart';
import 'package:news_app_clean_architecture/features/profile/presentation/pages/profile_page.dart';
import 'package:news_app_clean_architecture/features/published_articles/presentation/cubit/published_articles_cubit.dart';
import 'package:news_app_clean_architecture/features/published_articles/presentation/cubit/published_articles_state.dart';
import 'package:news_app_clean_architecture/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:news_app_clean_architecture/features/auth/presentation/cubit/auth_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article_tile.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({Key? key}) : super(key: key);

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  // Pages for each tab
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Initialize pages
    _pages = [
      const HomePage(), // Home - shows other users' news
      const MyNewsPage(), // My News
      const SizedBox(), // Placeholder for Add button (navigates instead)
      const BookmarksPage(), // Bookmarks
      const ProfilePage(), // Profile
    ];

    // Load articles after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        final cubit = context.read<PublishedArticlesCubit>();
        cubit.setCurrentUserId(authState.user.uid);
        // Load initial articles for Home page (other users' news)
        cubit.getPublishedArticles(filter: ArticleFilter.otherUsers);
      }
    });
  }

  void _onBottomNavTapped(int index) {
    if (index == 2) {
      // Add News button - navigate to publish page
      Navigator.pushNamed(context, '/PublishArticle');
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    // Load appropriate articles based on selected tab
    final cubit = context.read<PublishedArticlesCubit>();
    final authState = context.read<AuthCubit>().state;

    if (authState is AuthAuthenticated) {
      cubit.setCurrentUserId(authState.user.uid);

      if (index == 0) {
        // Home - show other users' news
        cubit.getPublishedArticles(filter: ArticleFilter.otherUsers);
      } else if (index == 1) {
        // My News - show user's own articles
        cubit.getPublishedArticles(filter: ArticleFilter.myNews);
      } else if (index == 3) {
        // Bookmarks - show favorites
        cubit.getPublishedArticles(filter: ArticleFilter.favorites);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return SizedBox(
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home Button
                  _buildNavItem(
                    icon: Icons.home,
                    label: 'Home',
                    isSelected: _selectedIndex == 0,
                    onTap: () => _onBottomNavTapped(0),
                  ),

                  // My News Button
                  _buildNavItem(
                    icon: Icons.article,
                    label: 'My News',
                    isSelected: _selectedIndex == 1,
                    onTap: () => _onBottomNavTapped(1),
                  ),

                  // Spacer for center button
                  const SizedBox(width: 80),

                  // Bookmark Button
                  _buildNavItem(
                    icon: Icons.bookmark,
                    label: 'Bookmark',
                    isSelected: _selectedIndex == 3,
                    onTap: () => _onBottomNavTapped(3),
                  ),

                  // Profile Button
                  _buildNavItem(
                    icon: Icons.person,
                    label: 'Profile',
                    isSelected: _selectedIndex == 4,
                    onTap: () => _onBottomNavTapped(4),
                  ),
                ],
              ),
            ),
          ),

          // Floating Center Add Button
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width / 2 - 35,
            child: GestureDetector(
              onTap: () => _onBottomNavTapped(2),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF3D4A5C),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF6B9E6A) : Colors.grey,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF6B9E6A) : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Home Page - shows news from other users
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load other users' articles
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<PublishedArticlesCubit>().setCurrentUserId(authState.user.uid);
    }
    context.read<PublishedArticlesCubit>().getPublishedArticles(filter: ArticleFilter.otherUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocBuilder<PublishedArticlesCubit, PublishedArticlesState>(
        builder: (context, state) {
          if (state is PublishedArticlesLoading) {
            return _buildLoadingState();
          }
          if (state is PublishedArticlesError) {
            return _buildErrorState();
          }
          if (state is PublishedArticlesDone) {
            return _buildArticlesPage(state.articles!);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorState() {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text('Failed to load articles'),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesPage(List articles) {
    // Filter articles based on search query
    final filteredArticles = _searchQuery.isEmpty
        ? articles
        : articles.where((article) {
            return article.title!
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
          }).toList();

    // Sort by date (newest first) for "Latest News"
    final sortedArticles = List.from(filteredArticles)
      ..sort((a, b) => (b.publishedAt ?? '').compareTo(a.publishedAt ?? ''));

    final latestArticles = sortedArticles.take(5).toList();

    return articles.isEmpty
        ? const Center(
            child: Text(
              'No articles available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar section
                _buildSearchBar(),

                // Latest News horizontal section
                if (latestArticles.isNotEmpty) ...[
                  _buildSectionTitle('Latest News'),
                  _buildLatestNewsSection(latestArticles),
                ],

                // All News vertical section
                _buildSectionTitle('All News'),
                _buildAllNewsSection(filteredArticles),
              ],
            ),
          );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 50, 16, 24),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search News...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFFF9F43),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E88E5),
        ),
      ),
    );
  }

  Widget _buildLatestNewsSection(List articles) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return _buildLatestNewsCard(article);
        },
      ),
    );
  }

  Widget _buildLatestNewsCard(article) {
    return GestureDetector(
      onTap: () => _onArticlePressed(context, article),
      child: Container(
        width: 320,
        margin: const EdgeInsets.only(right: 16, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey[200],
                child: article.urlToImage != null
                    ? Image.network(
                        article.urlToImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.image, size: 50, color: Colors.grey),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.edit, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          article.author ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '5 hours ago',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFF9F43),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllNewsSection(List articles) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return _buildAllNewsCard(article);
      },
    );
  }

  Widget _buildAllNewsCard(article) {
    return GestureDetector(
      onTap: () => _onArticlePressed(context, article),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey[200],
                child: article.urlToImage != null
                    ? Image.network(
                        article.urlToImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.image, size: 30, color: Colors.grey),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(Icons.image, size: 30, color: Colors.grey),
                      ),
              ),
            ),

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.edit, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          article.author ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.lightbulb, size: 12, color: Color(0xFF1E88E5)),
                            SizedBox(width: 4),
                            Text(
                              'Innovation',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF1E88E5),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        '7 hours ago',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFFF9F43),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onArticlePressed(BuildContext context, article) async {
    final cubit = context.read<PublishedArticlesCubit>();

    await Navigator.pushNamed(
      context,
      '/ArticleDetails',
      arguments: {
        'article': article,
        'onFavoriteToggle': (String documentId, bool currentStatus) async {
          await cubit.toggleArticleFavorite(documentId, currentStatus);
        },
      },
    );

    // Refresh the list when coming back
    if (mounted) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        cubit.setCurrentUserId(authState.user.uid);
        cubit.getPublishedArticles(filter: ArticleFilter.otherUsers);
      }
    }
  }
}

// Bookmarks Page
class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Bookmarks',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<PublishedArticlesCubit, PublishedArticlesState>(
        builder: (context, state) {
          if (state is PublishedArticlesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PublishedArticlesError) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Failed to load bookmarks'),
                ],
              ),
            );
          }
          if (state is PublishedArticlesDone) {
            final articles = state.articles!;
            if (articles.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No bookmarked articles yet',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return _buildBookmarkCard(article);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildBookmarkCard(article) {
    return GestureDetector(
      onTap: () => _onArticlePressed(context, article),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey[200],
                child: article.urlToImage != null
                    ? Image.network(
                        article.urlToImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.image, size: 30, color: Colors.grey),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(Icons.image, size: 30, color: Colors.grey),
                      ),
              ),
            ),

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.edit, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          article.author ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.lightbulb, size: 12, color: Color(0xFF1E88E5)),
                            SizedBox(width: 4),
                            Text(
                              'Innovation',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF1E88E5),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        '7 hours ago',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFFF9F43),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onArticlePressed(BuildContext context, article) async {
    final cubit = context.read<PublishedArticlesCubit>();

    await Navigator.pushNamed(
      context,
      '/ArticleDetails',
      arguments: {
        'article': article,
        'onFavoriteToggle': (String documentId, bool currentStatus) async {
          await cubit.toggleArticleFavorite(documentId, currentStatus);
        },
      },
    );

    // Refresh the list when coming back
    if (mounted) {
      cubit.getPublishedArticles(filter: ArticleFilter.favorites);
    }
  }
}
