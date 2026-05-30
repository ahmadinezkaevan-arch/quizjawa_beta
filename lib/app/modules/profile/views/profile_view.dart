import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../routes/app_pages.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    // Data histori quiz statis (belum diimplementasi per-akun)
    final List<Map<String, String>> historyList = [
      {
        'title':       'Rumah Joglo',
        'description': 'Uji pengetahuan mu mengenai rumah Joglo!',
        'image':       'assets/images/rumahjoglo.png',
      },
      {
        'title':       'Pakaian Adat',
        'description': 'Kenali jenis-jenis pakaian adat dari berbagai daerah di pulau Jawa.',
        'image':       'assets/images/pakaianadat.png',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Color(0xFF583410),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // ── Loading ──────────────────────────────────
        if (controller.isLoadingProfile.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF583410)),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ── Foto Profil + Tombol Edit ──────────
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/profil.png'),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF583410),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── Nama (dari Firestore) ──────────────
              Obx(() => Text(
                controller.username.value.isNotEmpty
                    ? controller.username.value
                    : 'Belum ada nama',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3728),
                ),
              )),

              const SizedBox(height: 4),

              // ── Email (dari Firebase Auth) ─────────
              Obx(() => Text(
                controller.email.value,
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF4A3728).withValues(alpha: 0.7),
                ),
              )),

              const SizedBox(height: 24),

              // ── Statistik ──────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Quiz Terselesaikan',
                      value: '2',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      label: 'Skor Rata-rata',
                      value: '80%',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ── Histori Quiz ───────────────────────
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Histori quiz',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3728),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              ...historyList.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _HistoryCard(
                  title:       item['title']!,
                  description: item['description']!,
                  image:       item['image']!,
                ),
              )),
            ],
          ),
        );
      }),
    );
  }
}

// ── Widget Stat Card ───────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF583410).withValues(alpha: 0.17),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF583410),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF583410),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget History Card ────────────────────────────────
class _HistoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const _HistoryCard({
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.13),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              image,
              width: 100,
              height: 122,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100,
                height: 122,
                color: const Color(0xFF583410),
                child: const Icon(Icons.home, color: Colors.white, size: 40),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF583410),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: const Color(0xFF583410).withValues(alpha: 0.7),
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12, right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF583410),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Mulai',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}