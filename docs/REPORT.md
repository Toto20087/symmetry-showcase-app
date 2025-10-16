# Symmetry Applicant Showcase App - Project Report

## 1. Introduction

When I first encountered this project, I felt a mix of excitement and challenge. The scope was clear: build a news application where users can publish their own articles. What stood out immediately was Symmetry's emphasis on Clean Architecture and their three core values - Truth is King, Total Accountability, and Maximally Overdeliver.

My experience coming into this project included solid programming fundamentals, but Flutter, Firebase, and BLoC were completly new territories for me. This presented both a challenge and an opportunity to demonstrate my capacity to learn quickly and deliver quality code.

## 2. Learning Journey

### Technologies Learned

**Flutter Framework**

- Started with some videos in youtube that explains what is Flutter, when is useful and how to use it. Some basic tutorials to get to know the tool.
- Then i started reading the official Flutter documentation
- Focused on understanding widgets, state management, and the Flutter rendering pipeline
- Practiced building UI components helping myself with some youtube tutorials and the explanations of some AI tools of certain things that i was missing.

**Firebase Ecosystem**

- Same as i did with Flutter, i started with some videos in youtube where i can see what is Firbase about.
- I have a solid with the rules thing because i have used SUPABASE in the past and it is very similar with the "Row Level Security".
- Understand how NoSQL design works because i have always work with SQL database in the past
- Implemented Firestore Database
- Claim my free credit in my account so i can have access to multiple tools inside of a Firebase project
- Implemented Firebase Cloud Storage for image handling
- Implement Firebase Authentication (Google Sign-In and Email/Password)

**Flutter BLoC & State Management**

- Studied the BLoC pattern and Cubit architecture
- Learned how to separate business logic from presentation
- Implemented proper state management using flutter_bloc package

**Clean Architecture**

- Deeply studied the three-layer architecture (Data, Domain, Presentation)
- Understood dependency inversion and how domain layer stays pure Dart
- Learned to properly separate concerns between layers
- Implemented repository patterns and use cases

### Resources Utilized

1. Official Flutter documentation and tutorials
2. BLoC library documentation and video tutorials
3. Firebase documentation for Firestore, Auth, and Storage
4. YouTube tutorials on Clean Architecture with Flutter
5. Stack Overflow and Flutter community forums for specific implementation challenges
6. AI tools to give me explanations on certain things that i was missing or falling short.

### Application of Knowledge

The knowledge was applied systematically:

1. First designed the database schema following NoSQL best practices
2. Built the domain layer with entities and repository interfaces
3. Implemented data layer with Firestore integration
4. Created presentation layer with proper state management
5. Iteratively tested and refined each component

## 3. Challenges Faced

### Challenge 1: Understanding Clean Architecture Boundaries

**Problem:** Initially struggled with understanding where code should live - particularly the distinction between models and entities.

**Solution:** Re-read the architecture documentation multiple times and studied the existing codebase structure. Realized that entities are pure business objects while models handle data transformation from external sources.

**Lesson Learned:** Clean Architecture requires discipline and careful planning, but pays dividends in maintainability and testability.

### Challenge 2: Firestore Data Modeling

**Problem:** Coming from a SQL background, NoSQL data modeling was conceptually different. Struggled with deciding between subcollections and embedded data.

**Solution:** Researched Firestore best practices, particularly query performance. Decided to use subcollections for user-specific data like bookmarks to maintain proper data isolation.

**Lesson Learned:** NoSQL requires thinking in terms of access patterns rather than normalized data structures.

### Challenge 3: State Management with BLoC

**Problem:** Understanding when to emit new states and how to handle loading/error states consistently across features.

**Solution:** Created a consistent pattern for all cubits - always start with loading state, handle errors with specific error states, and emit success states with data. Used sealed classes for type-safe state handling.

**Lesson Learned:** Consistent patterns across the codebase make it easier to reason about state management and catch bugs early.

### Challenge 4: Firebase Authentication Integration

**Problem:** Managing authentication state across the app and ensuring proper user context for operations like article publishing and bookmarking.

**Solution:** Created an AuthCubit that manages authentication state globally, then passed user context to other cubits that need it. Implemented proper Firebase Auth listeners to track auth state changes.

**Lesson Learned:** Authentication should be centralized and other features should depend on it through well-defined interfaces.

### Challenge 5: User-Specific Bookmarks Implementation

**Problem:** Initially implemented bookmarks as a boolean field on articles, which made bookmarks global rather than per-user.

**Solution:** Redesigned the architecture to use Firestore subcollections (`users/{userId}/favorites/{articleId}`), ensuring complete data isolation between users. Updated the entire data flow from datasource to presentation layer.

**Lesson Learned:** Database design has cascading effects throughout the architecture. It's worth investing time upfront to design data structures properly.

## 4. Reflection and Future Directions

### Technical Growth

This project significantly expanded my technical capabilities:

1. **Mobile Development Expertise:** Gained confidence in Flutter development and mobile-first thinking
2. **Architecture Skills:** Deeply understood Clean Architecture and its benefits
3. **Backend Integration:** Get to know Firebase services and cloud-based backend development
4. **State Management:** Became proficient with BLoC pattern and reactive programming

### Professional Growth

Beyond technical skills, this project taught me:

1. **Learning Velocity:** Demonstrated ability to quickly learn multiple new technologies simultaneously
2. **Problem Solving:** Improved at breaking down complex problems into manageable pieces
3. **Code Quality:** Developed appreciation for well-structured, maintainable code
4. **Documentation:** Learned importance of documenting architecture decisions and database schemas

### Future Improvements

If I were to continue developing this application, I would focus on:

1. **Performance Optimization**

   - Implement pagination for article lists
   - Add image caching and lazy loading
   - Optimize Firestore queries with proper indexing

2. **Enhanced Features**

   - Real-time collaboration on article drafts
   - Article categories and tagging system
   - Advanced search with filters
   - Comments and discussions on articles
   - Followers and following implementations (so users can follow each other)
   - Real-time notifications

3. **Testing**

   - Comprehensive unit tests for business logic
   - Widget tests for UI components
   - Integration tests for critical user flows
   - Mock Firebase services for testing

4. **User Experience**

   - Offline support with local caching
   - Push notifications for new content
   - Dark mode support
   - Accessibility improvements

5. **Technical Debt**
   - Refactor some larger widgets into smaller, reusable components
   - Add error boundary handling
   - Implement proper logging and analytics
   - Add CI/CD pipeline for automated testing and deployment

## 5. Proof of the Project

### Application Features Demonstrated

The final version of the application includes:

**Core Features:**

- User authentication (Google Sign-In and Email/Password)
- Article browsing with beautiful card layouts
- Article publishing with markdown support and image uploads
- User-specific bookmarks system
- Profile management
- Multi-tab navigation (Home, My News, Add News, Bookmarks, Profile)

**Technical Implementation:**

- Clean Architecture with proper layer separation
- BLoC/Cubit state management throughout
- Firebase Firestore for data persistence
- Firebase Storage for image management
- Firebase Authentication for user management
- Responsive UI following Figma prototype

### Database Schema

The implemented schema includes:

**Articles Collection:**

- id, title, description, content, author, userId
- thumbnailURL (Firebase Storage reference)
- publishedAt, createdAt, updatedAt timestamps

**Users Collection:**

- User profile with uid, email, displayName
- Favorites subcollection for user-specific bookmarks

### Screenshots and Videos

_Note: Screenshots are in the following figma file:https://www.figma.com/design/q5JFUYyvFJu5D4e7zE4leI/SYMMETRY-DESIGN?node-id=0-1&t=OQgVsxm3brWvQUNt-1_

_Note: The video is inside of the following link:https://youtu.be/pbl5oyFeMBQ_

- Login/Registration screens
- Home page with article feed
- Article detail view
- Article publishing flow
- Bookmarks page showing user-specific favorites
- Profile page
- My News showing user's published articles

## 6. Overdelivery

### What Was Required vs What Was Delivered

**Original Requirements (from README and Figma):**

1. **Backend:** Design and implement a Firestore schema for articles with Firebase Cloud Storage for thumbnails
2. **Frontend:** Implement the Figma prototype showing a news feed and the ability to publish articles

**What Was Actually Delivered:**

Beyond the core requirements, I implemented a complete production-ready news application with multiple additional features:

#### ✅ Required Features (Completed)

- Article schema designed and documented in `/backend/docs/DB_SCHEMA.md`
- Firestore implementation with proper collections and fields
- Firestore security rules enforcement
- News feed displaying articles
- Article publishing functionality with image upload
- Firebase Cloud Storage integration for article thumbnails
- Clean Architecture implementation across all layers
- UI matching Figma prototype

#### ➕ Extra Features (Overdelivery)

**1. Complete User Authentication System**

- Google Sign-In integration
- Email/Password authentication
- User profile management
- Persistent authentication sessions
- AuthCubit for global authentication state management

**2. User-Specific Bookmarks/Favorites System**

- Firestore subcollections: `users/{userId}/favorites/{articleId}`
- Complete user-specific data isolation
- Repository pattern with user context
- Dedicated Bookmarks page with error handling

**3. My News Page (User's Published Articles)**

- Separate page showing only the current user's published articles
- Article filtering by userId
- Tab-based navigation with proper state management

**4. Profile Management Page**

- User profile display with authentication info
- Account management capabilities
- Clean UI matching app design

**5. Advanced Five-Tab Navigation**

- Home (other users' articles)
- My News (user's articles)
- Add News (floating action button)
- Bookmarks (user's favorites)
- Profile (user management)
- Proper state preservation across tabs
- User context propagation

**6. Markdown Support for Articles**

- Rich text formatting using markdown
- Professional content rendering in article detail view

**7. Article Detail View**

- Full-screen article reading experience
- Image display with error handling
- Interactive bookmark button with optimistic UI
- Markdown content rendering

**8. Enhanced Database Architecture**

- Extended schema with users collection
- Subcollections for user-specific data
- Comprehensive documentation in `DB_SCHEMA.md`
- Proper data isolation between users

**9. Production-Ready Security**

- Comprehensive Firestore security rules
- User-specific read/write permissions
- Favorites subcollection access control

#### Feature 2: Enhanced Profile Management

### Quantifying the Overdelivery

**Scope Comparison:**

| Category            | Required           | Delivered                                | Multiplier      |
| ------------------- | ------------------ | ---------------------------------------- | --------------- |
| Features            | 2 (feed + publish) | 9+ features                              | 4.5x            |
| Screens             | 2 (home + publish) | 8+ screens                               | 4x              |
| Backend Collections | 1 (articles)       | 2 (articles + users with subcollections) | 2x              |
| Authentication      | Not specified      | Complete auth system                     | N/A (extra)     |
| Architecture        | Clean Architecture | Full Clean Architecture + BLoC           | 100% compliance |

**Additional Effort Investment:**

- Could have met basic requirements in: ~3-4 days
- Actual time invested: ~2 weeks
- Additional features/architecture: ~65-70% of total development time

This represents a strong commitment to the "Maximally Overdeliver" value - not just checking boxes, but building a production-ready application.

### 1. Prototypes Created

#### Extended Database Schema Documentation

**Beyond Requirements:** The assignment asked for a schema in `DB_SCHEMA.md`, but I went further by:

- Adding a complete users collection with subcollections
- Documenting user-specific bookmarks architecture
- Including storage structure details
- Providing example documents
- Explaining query patterns and indexing

**Files:** `/backend/docs/DB_SCHEMA.md`

#### Complete Clean Architecture Implementation

**Beyond Requirements:** While Clean Architecture was mentioned in learning resources, implementing it strictly across all features with:

- Complete separation of concerns
- Repository pattern with interfaces
- Use cases for all business logic
- Dependency injection with GetIt
- Zero coupling between layers

This level of architectural discipline is production-grade.

#### Multi-User Authentication System

**Beyond Requirements:** Not mentioned in requirements at all. Added complete authentication with:

- Firebase Authentication integration
- Multiple sign-in methods (Google + Email/Password)
- Global state management with AuthCubit
- User context propagation throughout app

### 2. How Can You Improve This

#### Additional Features Worth Implementing

1. **Social Features**

   - User profiles with follower/following system
   - Notification system when someone bookmarks your article
   - Comments and discussions on articles
   - Article sharing capabilities

2. **Content Discovery**

   - Article recommendation algorithm based on reading history
   - Trending articles section
   - Search functionality with filters (author, date, keywords)
   - Category/tag-based article organization

3. **Content Creation Enhancements**

   - Draft system for unfinished articles
   - Rich text editor with live markdown preview
   - Multiple image uploads per article
   - Article editing capabilities after publication

4. **Analytics and Insights**

   - View count for articles
   - Author dashboard showing article performance
   - Reading time estimates
   - Popular articles analytics

5. **Technical Improvements**
   - Implement comprehensive testing (unit, widget, integration)
   - Add offline support with local caching
   - Implement proper error logging and monitoring
   - Add analytics for user behavior tracking
   - Create CI/CD pipeline for automated deployment

#### Architectural Enhancements

1. **Repository Pattern Enhancement**

   - Add caching layer in repositories
   - Implement repository retry logic for failed operations
   - Add connection status monitoring

2. **State Management**

   - Consider implementing BLoC instead of Cubit for more complex state
   - Add state persistence for better user experience
   - Implement proper error recovery mechanisms

3. **Performance**

   - Implement virtual scrolling for large article lists
   - Add image optimization pipeline
   - Lazy load article content
   - Implement proper Firestore query pagination

4. **Security**
   - Enhanced Firestore security rules
   - Input validation and sanitization
   - Rate limiting for article publishing
   - Content moderation system

## 7. Extra Sections

### Code Quality Metrics

**Architecture Compliance:**

- ✅ All features follow Clean Architecture principles
- ✅ Domain layer has zero Flutter/external dependencies
- ✅ Proper separation of concerns across layers
- ✅ Repository pattern implemented correctly

**State Management:**

- ✅ Consistent use of Cubit pattern
- ✅ Proper state classes (Loading, Success, Error)
- ✅ No direct UI-to-database communication

**Firebase Integration:**

- ✅ Firestore rules enforce schema
- ✅ Proper authentication flow
- ✅ Secure storage access
- ✅ Real-time data synchronization

### Key Technical Decisions

#### Decision 1: Cubit vs BLoC

**Choice:** Used Cubit for state management instead of full BLoC

**Rationale:** Cubits provide simpler API for most use cases in this app. The added complexity of events in BLoC wasn't necessary for the current feature set.

**Trade-off:** BLoC would provide better testability and event tracking, but Cubit offers faster development and easier understanding for this project scope.

#### Decision 2: Subcollections for User Data

**Choice:** Used Firestore subcollections for user-specific data (bookmarks)

**Rationale:** Provides natural data isolation, easier querying, and better security rules granularity.

**Trade-off:** More complex queries when needing to aggregate data across users, but much better for data privacy and security.

#### Decision 3: Firebase Cloud Storage for Images

**Choice:** Used Firebase Cloud Storage rather than embedding images as base64 or using external CDN

**Rationale:** Integrates seamlessly with Firebase ecosystem, provides good performance, and includes built-in security rules.

**Trade-off:** Tied to Firebase ecosystem, but acceptable given project requirements.

### Lessons Learned

1. **Start with Architecture:** Time invested in understanding and planning Clean Architecture paid off significantly in development speed and code quality.

2. **Database Design Matters:** The user-specific bookmarks refactoring showed how important it is to get database design right the first time.

3. **Documentation is Development:** Writing DB_SCHEMA.md and maintaining documentation helped clarify thinking and made implementation smoother.

4. **State Management Consistency:** Having consistent patterns for state management across all cubits made debugging and feature addition much easier.

5. **Test Early:** Should have written tests alongside feature development rather than planning to add them later.

### Alignment with Symmetry Values

**Truth is King:**

- Made architectural decisions based on technical merit, not convenience
- Documented rationale for technical choices
- Refactored user bookmarks when initial implementation was flawed

**Total Accountability:**

- Took ownership of the entire codebase from backend to frontend
- Ensured all features were fully functional before considering them complete
- Documented challenges faced and solutions implemented

**Maximally Overdeliver:**

- Implemented user-specific bookmarks beyond basic requirements
- Created comprehensive database schema documentation
- Followed Clean Architecture strictly even when it required more effort
- Added markdown support for article content

---

## Conclusion

This project has been an incredible learning experience that pushed me to quickly master new technologies while maintaining high code quality standards. The emphasis on Clean Architecture, combined with Symmetry's core values, created a framework for delivering exceptional work.

I successfully implemented a fully functional news application with article publishing, user authentication, and user-specific bookmarks - all while adhering to Clean Architecture principles and maintaining a focus on code quality and maintainability.

The journey from zero Flutter knowledge to delivering a production-ready application demonstrates my capacity to learn quickly, solve complex problems, and deliver results that exceed expectations. I'm excited about the possibility of bringing this same energy and commitment to Symmetry's development team.
