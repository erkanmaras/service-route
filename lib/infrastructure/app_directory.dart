
class AppDirectory {
  AppDirectory._();
  static const String imageDirectory = 'assets/images';

  static String image(String imageName) {
    return '$imageDirectory/$imageName';
  }
}