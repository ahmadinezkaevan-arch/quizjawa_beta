import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/leaderboard_controller.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final LeaderboardController controller = Get.find<LeaderboardController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF6B3E11)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Papan Peringkat',
          style: TextStyle(
            color: Color(0xFF6B3E11),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF583410)),
            );
          }

          if (controller.entries.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data leaderboard.',
                style: TextStyle(color: Color(0xFF583410)),
              ),
            );
          }

          final entries   = controller.entries;
          final myUid     = controller.currentUid.value;

          return Column(
            children: [
              // ── Podium ──────────────────────────────
              if (entries.length >= 3)
                _Podium(entries: entries, myUid: myUid)
              else
                _PodiumSmall(entries: entries, myUid: myUid),

              const SizedBox(height: 12),

              // ── List semua peringkat ─────────────────
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final item  = entries[index];
                    final rank  = index + 1;
                    final isMe  = item['uid'] == myUid;
                    return _RankTile(
                      rank:  rank,
                      name:  item['username'] ?? '',
                      score: item['score']    ?? 0,
                      isMe:  isMe,
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// PODIUM (≥3 peserta)
// ════════════════════════════════════════════════════
class _Podium extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final String myUid;

  const _Podium({required this.entries, required this.myUid});

  @override
  Widget build(BuildContext context) {
    final first  = entries[0];
    final second = entries[1];
    final third  = entries[2];

    // Warna podium coklat seperti referensi
    const Color podiumColor      = Color(0xFF8B5E3C);
    const Color podiumColorLight = Color(0xFFAA7C52);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SizedBox(
        height: 230,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // ── Podium Bars ──────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Peringkat 2
                _PodiumBar(height: 110, color: podiumColorLight, rank: 2),
                const SizedBox(width: 4),
                // Peringkat 1
                _PodiumBar(height: 145, color: podiumColor, rank: 1),
                const SizedBox(width: 4),
                // Peringkat 3
                _PodiumBar(height: 85, color: podiumColorLight, rank: 3),
              ],
            ),

            // ── Avatar di atas podium ────────────────
            Positioned(
              bottom: 110,   // di atas bar peringkat 2
              left: 16,
              child: _PodiumAvatar(
                name:  second['username'] ?? '',
                score: second['score']    ?? 0,
                size:  64,
                isMe:  second['uid'] == myUid,
              ),
            ),
            Positioned(
              bottom: 145,   // di atas bar peringkat 1
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    // Crown
                    const Text('👑', style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 2),
                    _PodiumAvatar(
                      name:  first['username'] ?? '',
                      score: first['score']    ?? 0,
                      size:  76,
                      isMe:  first['uid'] == myUid,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 85,    // di atas bar peringkat 3
              right: 16,
              child: _PodiumAvatar(
                name:  third['username'] ?? '',
                score: third['score']    ?? 0,
                size:  60,
                isMe:  third['uid'] == myUid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Podium kecil jika peserta < 3 ─────────────────────
class _PodiumSmall extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final String myUid;
  const _PodiumSmall({required this.entries, required this.myUid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: entries.take(3).toList().asMap().entries.map((e) {
          final idx  = e.key;
          final item = e.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                _PodiumAvatar(
                  name:  item['username'] ?? '',
                  score: item['score']    ?? 0,
                  size:  56,
                  isMe:  item['uid'] == myUid,
                ),
                const SizedBox(height: 4),
                Text(
                  '${idx + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF583410),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Bar podium ─────────────────────────────────────────
class _PodiumBar extends StatelessWidget {
  final double height;
  final Color  color;
  final int    rank;

  const _PodiumBar({
    required this.height,
    required this.color,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 32 - 8) / 3,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft:  Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            '$rank',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Avatar di atas podium ──────────────────────────────
class _PodiumAvatar extends StatelessWidget {
  final String name;
  final int    score;
  final double size;
  final bool   isMe;

  const _PodiumAvatar({
    required this.name,
    required this.score,
    required this.size,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar circle
        Container(
          width:  size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFD4A96A).withValues(alpha: 0.3),
            border: Border.all(
              color: isMe
                  ? const Color(0xFF583410)
                  : Colors.white,
              width: isMe ? 2.5 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipOval(
            child: Container(
              color: const Color(0xFFE8D5B7),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: size * 0.38,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF583410),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Nama
        SizedBox(
          width: size + 12,
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF583410),
            ),
          ),
        ),
        // Skor
        Text(
          '$score',
          style: TextStyle(
            fontSize: 11,
            color: const Color(0xFF583410).withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════
// RANK TILE — semua peringkat ditampilkan di list
// ════════════════════════════════════════════════════
class _RankTile extends StatelessWidget {
  final int    rank;
  final String name;
  final int    score;
  final bool   isMe;

  const _RankTile({
    required this.rank,
    required this.name,
    required this.score,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    // Warna nomor peringkat 1-3 seperti referensi
    Color rankColor() {
      if (rank == 1) return const Color(0xFFFFD700);
      if (rank == 2) return const Color(0xFFC0C0C0);
      if (rank == 3) return const Color(0xFFCD7F32);
      return const Color(0xFF583410).withValues(alpha: 0.5);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isMe
            ? const Color(0xFF583410).withValues(alpha: 0.10)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isMe
            ? Border.all(color: const Color(0xFF583410).withValues(alpha: 0.4), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Nomor peringkat
          SizedBox(
            width: 32,
            child: Text(
              '$rank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: rankColor(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Avatar kecil
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE8D5B7),
              border: Border.all(
                color: isMe
                    ? const Color(0xFF583410)
                    : Colors.white,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF583410),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Nama
          Expanded(
            child: Text(
              isMe ? '$name (Kamu)' : name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isMe ? FontWeight.bold : FontWeight.w500,
                color: const Color(0xFF4A2E0E),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Skor
          Text(
            '$score',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isMe
                  ? const Color(0xFF583410)
                  : const Color(0xFF4A2E0E),
            ),
          ),
        ],
      ),
    );
  }
}