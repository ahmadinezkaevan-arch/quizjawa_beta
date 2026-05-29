import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class KategoriView extends StatelessWidget {
  const KategoriView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF583410)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Kategori Budaya',
          style: TextStyle(
            color: Color(0xFF583410),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _CategoryItem(
              icon: Icons.home_outlined,
              title: 'Rumah Adat',
              description:
                  'Uji pengetahuanmu tentang rumah adat tradisional di Pulau Jawa.',
              onTap: () => Get.toNamed(Routes.RUMAH_ADAT),
            ),
            const SizedBox(height: 16),
            _CategoryItem(
              icon: Icons.music_note_outlined,
              title: 'Tarian Adat',
              description:
                  'Jelajahi ragam tarian tradisional yang berkembang di Pulau Jawa.',
              onTap: () => Get.toNamed(Routes.TARI_ADAT),
            ),
            const SizedBox(height: 16),
            _CategoryItem(
              icon: Icons.checkroom_outlined,
              title: 'Baju Adat',
              description:
                  'Telusuri ciri khas busana tradisional masyarakat Pulau Jawa.',
              onTap: () => Get.toNamed(Routes.BAJU_ADAT),
            ),
            const SizedBox(height: 16),
            _CategoryItem(
              icon: Icons.translate,
              title: 'Bahasa Daerah',
              description:
                  'Kenali berbagai bahasa daerah yang digunakan di Pulau Jawa.',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _CategoryItem(
              icon: Icons.groups_outlined,
              title: 'Tradisi',
              description:
                  'Pahami kebiasaan dan adat istiadat masyarakat di Pulau Jawa.',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widget Category Item ───────────────────────────────
class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF583410).withValues(alpha: 0.64),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.13),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}