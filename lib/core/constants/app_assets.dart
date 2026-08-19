/// Application asset paths singleton.
class AppAssets {
  AppAssets._();

  static final AppAssets _instance = AppAssets._();
  static AppAssets get instance => _instance;
  factory AppAssets() => _instance;

  final String messenger = 'assets/images/messenger.png';
}
