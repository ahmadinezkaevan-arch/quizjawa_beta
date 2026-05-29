import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Data ranking statis
    final List<Map<String, dynamic>> rankings = [
      {'rank': 1,  'name': 'Ralph Edwards',      'score': 100},
      {'rank': 2,  'name': 'Cameron Williamson',  'score': 90},
      {'rank': 3,  'name': 'Darlene R...(Anda)',  'score': 80},
      {'rank': 4,  'name': 'Robert Fox',          'score': 70},
      {'rank': 5,  'name': 'Guy Hawkins',         'score': 60},
      {'rank': 6,  'name': 'Kristin Watson',      'score': 50},
      {'rank': 7,  'name': 'Annika Connor',       'score': 40},
      {'rank': 8,  'name': 'Russel Benet',        'score': 30},
      {'rank': 9,  'name': 'Lottie West',         'score': 20},
      {'rank': 10, 'name': 'Guy Shah',            'score': 10},
    ];

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
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ── Podium Image ─────────────────────────
            Image.asset(
              'assets/images/peringkat.png',
              width: 376,
              height: 298,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 376,
                height: 298,
                color: const Color(0xFF583410).withValues(alpha: 0.1),
                child: const Icon(
                  Icons.emoji_events,
                  size: 80,
                  color: Color(0xFF583410),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── List Ranking ──────────────────────────
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: rankings.length,
                itemBuilder: (context, index) {
                  final item = rankings[index];
                  return _RankTile(
                    rank:  item['rank'],
                    name:  item['name'],
                    score: item['score'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widget Rank Tile ───────────────────────────────────
class _RankTile extends StatelessWidget {
  final int rank;
  final String name;
  final int score;

  const _RankTile({
    required this.rank,
    required this.name,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
          Text(
            '$rank',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.brown,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.brown,
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