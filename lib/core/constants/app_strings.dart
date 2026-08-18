/// Predefined static strings singleton for NewsBay application
class AppStrings {
  AppStrings._();

  static final AppStrings _instance = AppStrings._();
  static AppStrings get instance => _instance;
  factory AppStrings() => _instance;

  // General App
  static const String appName = 'NewsBay';

  // Navigation
  static const String navHome = 'Home';
  static const String navTopRate = 'Top Rate';
  static const String navNews = 'News';
  static const String navChat = 'Chat';
  static const String navProfile = 'Profile';

  // Authentication & Login
  static const String welcomeBack = 'Welcome Back';
  static const String emailOrUsername = 'Email Address / Username';
  static const String password = 'Password';
  static const String rememberMe = 'Remember me';
  static const String forgotPassword = 'Forgot password?';
  static const String login = 'Login';
  static const String orDivider = 'or';
  static const String loginWithGoogle = 'Login with Google';
  static const String loginWithBiometrics = 'Login with Biometrics';
  static const String notAMember = 'Not a member? ';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String signUp = 'Sign up';
  static const String quickDemoAccounts = 'Quick Demo Accounts:';
  static const String usernameValidation =
      'Please enter your username or email';
  static const String passwordValidation = 'Please enter your password';
  static const String passwordRecoveryComingSoon =
      'Password recovery feature coming soon!';
  static const String googleSignInDemoNotice =
      'Google Sign-In is simulated in demo mode.';
  static const String biometricAuthSuccess =
      'Biometric authentication successful!';
  static const String biometricAuthFailed =
      'Biometric authentication failed or cancelled.';

  // Registration
  static const String createAccount = 'Create Account';
  static const String joinNewsBay = 'Join NewsBay today';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String username = 'Username';
  static const String email = 'Email Address';
  static const String confirmPassword = 'Confirm Password';
  static const String register = 'Sign Up';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String fieldRequired = 'This field is required';
  static const String registrationSuccess =
      'Account created successfully! Please log in.';

  // Dashboard & Feed
  static const String goodMorning = 'Good Morning!';
  static const String goodAfternoon = 'Good Afternoon!';
  static const String goodEvening = 'Good Evening!';
  static const String searchPostsPlaceholder = 'Search posts ...';
  static const String featuredPosts = 'Featured Posts';
  static const String recentPosts = 'Recent Posts';
  static const String viewAll = 'View All';
  static const String searchResults = 'Search Results';
  static const String total = 'Total:';
  static const String reachedEndOfFeed = '🎉 You have reached the end';
  static const String clearSearch = 'Clear Search';
  static const String noMatchingPosts = 'No Matching Posts';
  static const String noPostsAvailable = 'No Posts Available';
  static const String noArticlesAvailableMessage =
      'No articles are available right now. Pull down to refresh.';
  static const String errorTitle = 'Oops! Something went wrong';
  static const String defaultErrorMessage = 'Failed to load posts.';
  static const String tryAgain = 'Try Again';

  // Offline Banner & Sync
  static const String offlineModeTitle = 'You are currently offline';
  static const String offlineModeSubtitle =
      'Showing cached articles. Connect to the internet for live updates.';
  static const String syncedJustNow = 'Synced just now';

  // Post Detail
  static const String postDetailTitle = 'Post Detail';
  static const String articleContent = 'Article Content';
  static const String likesLabel = 'Likes';
  static const String viewsLabel = 'Views';
  static const String commentsLabel = 'Comments';
  static const String bookmarkedNotice = 'Post bookmarked!';
  static const String sharingNotice = 'Sharing post link...';
  static const String authorPrefix = 'Author • User ID:';
  static const String minReadSuffix = 'min read';
  static const String hoursAgoSuffix = 'h ago';

  // Profile
  static const String profileTitle = 'Profile';
  static const String menuSettings = 'Settings';
  static const String menuMyFriends = 'My Friends';
  static const String menuMyFavourite = 'My Favourite';
  static const String menuLatestReviews = 'Latest Reviews';
  static const String menuFollowers = 'Followers';
  static const String menuLogOut = 'Log Out';
  static const String logoutDialogTitle = 'Log Out';
  static const String logoutDialogMessage =
      'Are you sure you want to log out from NewsBay?';
  static const String cancel = 'Cancel';
  static const String environmentPrefix = 'Environment:';
  static const String changeAvatarFeature = 'Change Avatar';

  // Errors & Fallbacks
  static const String noInternetConnection =
      'No internet connection. Please check your network.';
  static const String storageError =
      'An error occurred while accessing local secure storage.';
  static const String emptyCredentialsError =
      'Username and password cannot be empty.';
}
