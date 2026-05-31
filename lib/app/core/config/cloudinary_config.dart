
// 1. CLOUD_NAME:
//    Buka https://console.cloudinary.com → klik "Dashboard"
//    Lihat bagian "Product Environment" → Cloud Name (contoh: "dxxxxxxxxx")
//    Bukan URL app ID, tapi nama pendek seperti "datexsivh" atau "dab1234"
//
// 2. UPLOAD_PRESET:
//    Sudah kelihatan dari screenshot kamu → "quiz_jawa_image" (Unsigned)
// ══════════════════════════════════════════════════════

class CloudinaryConfig {
  CloudinaryConfig._();

  static const String cloudName = 'datexsivh';

  static const String uploadPreset = 'quiz_jawa_image';

  static String get uploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
}