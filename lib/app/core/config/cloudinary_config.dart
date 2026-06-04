class CloudinaryConfig {
  CloudinaryConfig._();

  static const String cloudName = 'datexsivh';

  static const String uploadPreset = 'quiz_jawa_image';

  static String get uploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
}