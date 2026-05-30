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
          // ── Loading ────────────────────────────────
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF583410)),
            );
          }

          // ── Kosong ─────────────────────────────────
          if (controller.entries.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data leaderboard.',
                style: TextStyle(color: Color(0xFF583410)),
              ),
            );
          }

          final entries = controller.entries;

          return Column(
            children: [
              const SizedBox(height: 20),

              // ── Podium Top 3 ────────────────────────
              if (entries.length >= 3)
                _buildPodium(entries)
              else
                const SizedBox(height: 12),

              const SizedBox(height: 20),

              // ── List peringkat 4 ke bawah ───────────
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: entries.length > 3 ? entries.length - 3 : 0,
                  itemBuilder: (context, index) {
                    final item = entries[index + 3];
                    final rank = index + 4;
                    final isMe = item['uid'] == controller.currentUid.value;
                    return _RankTile(
                      rank:  rank,
                      name:  item['username'],
                      score: item['score'],
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

  // ── Podium Top 3 ──────────────────────────────────────
  Widget _buildPodium(List<Map<String, dynamic>> entries) {
    final first  = entries[0];
    final second = entries[1];
    final third  = entries[2];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Peringkat 2 ──────────────────────────
          Expanded(
            child: _PodiumItem(
              rank:       2,
              name:       second['username'],
              score:      second['score'],
              height:     110,
              color:      const Color(0xFFC0C0C0),
              avatarSize: 44,
            ),
          ),
          const SizedBox(width: 8),
          // ── Peringkat 1 ──────────────────────────
          Expanded(
            child: _PodiumItem(
              rank:       1,
              name:       first['username'],
              score:      first['score'],
              height:     140,
              color:      const Color(0xFFFFD700),
              avatarSize: 52,
              showCrown:  true,
            ),
          ),
          const SizedBox(width: 8),
          // ── Peringkat 3 ──────────────────────────
          Expanded(
            child: _PodiumItem(
              rank:       3,
              name:       third['username'],
              score:      third['score'],
              height:     90,
              color:      const Color(0xFFCD7F32),
              avatarSize: 40,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget Podium Item ─────────────────────────────────
class _PodiumItem extends StatelessWidget {
  final int    rank;
  final String name;
  final int    score;
  final double height;
  final Color  color;
  final double avatarSize;
  final bool   showCrown;

  const _PodiumItem({
    required this.rank,
    required this.name,
    required this.score,
    required this.height,
    required this.color,
    required this.avatarSize,
    this.showCrown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Crown
        if (showCrown)
          const Text('👑', style: TextStyle(fontSize: 22)),

        // Avatar
        CircleAvatar(
          radius: avatarSize / 2,
          backgroundColor: color.withValues(alpha: 0.3),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: TextStyle(
              fontSize: avatarSize * 0.4,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF583410),
            ),
          ),
        ),
        const SizedBox(height: 4),

        // Nama (truncate kalau panjang)
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF583410),
          ),
          textAlign: TextAlign.center,
        ),

        // Skor
        Text(
          '$score',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF583410).withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),

        // Podium bar
        Container(
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft:  Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              '$rank',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Widget Rank Tile (peringkat 4+) ───────────────────
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isMe
            ? const Color(0xFF583410).withValues(alpha: 0.12)
            : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isMe
            ? Border.all(color: const Color(0xFF583410), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$rank',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.brown,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Avatar kecil
          CircleAvatar(
            radius: 18,
            backgroundColor:
                const Color(0xFF583410).withValues(alpha: 0.15),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF583410),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isMe ? '$name (Kamu)' : name,
              style: TextStyle(
                fontSize: 15,
                color: Colors.brown,
                fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            '$score',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.brown,
            ),
          ),
        ],
      ),
    );
  }
}