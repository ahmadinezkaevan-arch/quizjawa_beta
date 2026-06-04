import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/leaderboard_controller.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final LeaderboardController controller = Get.find<LeaderboardController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Papan Peringkat',
          style: TextStyle(
            color: Color(0xFF6B3E11),
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
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

        final entries = controller.entries;
        final myUid = controller.currentUid.value;

        return Column(
          children: [
            const Text(
              'Top pengguna dengan skor tertinggi',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF9E7B5A),
              ),
            ),
            const SizedBox(height: 16),

            if (entries.length >= 3)
              _Podium(entries: entries, myUid: myUid)
            else
              _PodiumSmall(entries: entries, myUid: myUid),

            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(26, 0, 26, 16),
                child: Column(
                  children: List.generate(
                    entries.length > 3 ? entries.length - 3 : 0,
                    (index) {
                      final item = entries[index + 3];
                      final rank = index + 4;
                      final isMe = item['uid'] == myUid;
                      return _RankCard(
                        rank: rank,
                        name: item['username'] ?? '',
                        score: item['score'] ?? 0,
                        photoUrl: item['photoUrl'] ?? '',
                        isMe: isMe,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _Podium extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final String myUid;

  const _Podium({required this.entries, required this.myUid});

  @override
  Widget build(BuildContext context) {
    final first = entries[0];
    final second = entries[1];
    final third = entries[2];

    final screenW = MediaQuery.of(context).size.width - 32;
    const double gap = 6.0;
    final barW = (screenW - gap * 2) / 3;

    const double h1 = 106.0;
    const double h2 = 74.0;
    const double h3 = 74.0;

    const double av1 = 86.0;
    const double av2 = 70.0;
    const double av3 = 70.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: barW,
                child: _AvatarColumn(
                  name: second['username'] ?? '',
                  score: second['score'] ?? 0,
                  photoUrl: second['photoUrl'] ?? '',
                  size: av2,
                  rank: 2,
                  isMe: second['uid'] == myUid,
                  extraBottom: 0,
                ),
              ),
              const SizedBox(width: gap),
              SizedBox(
                width: barW,
                child: _AvatarColumn(
                  name: first['username'] ?? '',
                  score: first['score'] ?? 0,
                  photoUrl: first['photoUrl'] ?? '',
                  size: av1,
                  rank: 1,
                  isMe: first['uid'] == myUid,
                  extraBottom: 10,
                  showCrown: true,
                ),
              ),
              const SizedBox(width: gap),
              SizedBox(
                width: barW,
                child: _AvatarColumn(
                  name: third['username'] ?? '',
                  score: third['score'] ?? 0,
                  photoUrl: third['photoUrl'] ?? '',
                  size: av3,
                  rank: 3,
                  isMe: third['uid'] == myUid,
                  extraBottom: 0,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PodiumBar(
                width: barW,
                height: h2,
                color: const Color(0xFFAA7C52),
                textColor: Colors.white,
                rank: 2,
                isFirst: false,
              ),
              const SizedBox(width: gap),
              _PodiumBar(
                width: barW,
                height: h1,
                color: const Color(0xFF8B5E3C),
                textColor: Colors.white,
                rank: 1,
                isFirst: true,
              ),
              const SizedBox(width: gap),
              _PodiumBar(
                width: barW,
                height: h3,
                color: const Color(0xFFAA7C52),
                textColor: Colors.white,
                rank: 3,
                isFirst: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PodiumBar extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Color textColor;
  final int rank;
  final bool isFirst;

  const _PodiumBar({
    required this.width,
    required this.height,
    required this.color,
    required this.textColor,
    required this.rank,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isFirst ? 12 : 8),
          topRight: Radius.circular(isFirst ? 12 : 8),
        ),
      ),
      child: Center(
        child: Text(
          '$rank',
          style: TextStyle(
            fontSize: isFirst ? 62 : 54,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _AvatarColumn extends StatelessWidget {
  final String name;
  final int score;
  final String photoUrl;
  final double size;
  final int rank;
  final bool isMe;
  final double extraBottom;
  final bool showCrown;

  const _AvatarColumn({
    required this.name,
    required this.score,
    required this.photoUrl,
    required this.size,
    required this.rank,
    required this.isMe,
    required this.extraBottom,
    this.showCrown = false,
  });

  @override
  Widget build(BuildContext context) {
    Color medalColor() {
      if (rank == 1) return const Color(0xFFFFB800);
      if (rank == 2) return const Color(0xFFAAAAAA);
      return const Color(0xFFCD7F32);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showCrown)
          const Text('👑', style: TextStyle(fontSize: 42))
        else
          const SizedBox(height: 26),
        const SizedBox(height: 2),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEED9BB),
                border: Border.all(
                  color: isMe
                      ? const Color(0xFF583410)
                      : const Color(0xFFD4B896),
                  width: isMe ? 2.5 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: photoUrl.isNotEmpty
                    ? Image.network(
                        photoUrl,
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _InitialAvatar(name: name, size: size),
                      )
                    : _InitialAvatar(name: name, size: size),
              ),
            ),
            Positioned(
              top: -10,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: medalColor(),
                  boxShadow: [
                    BoxShadow(
                      color: medalColor().withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: size + 16,
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isMe
                  ? const Color(0xFF8B5E3C)
                  : const Color(0xFF4A2E0E),
            ),
          ),
        ),
        Text(
          '$score',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF8B5E3C),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: extraBottom),
      ],
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  final String name;
  final double size;

  const _InitialAvatar({required this.name, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: const Color(0xFFEED9BB),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: size * 0.38,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF583410),
        ),
      ),
    );
  }
}

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
          final item = e.value;
          final idx = e.key;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _AvatarColumn(
              name: item['username'] ?? '',
              score: item['score'] ?? 0,
              photoUrl: item['photoUrl'] ?? '',
              size: 60,
              rank: idx + 1,
              isMe: item['uid'] == myUid,
              extraBottom: 0,
              showCrown: idx == 0,
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// RANK CARD (peringkat 4+)
// ════════════════════════════════════════════════════
class _RankCard extends StatelessWidget {
  final int rank;
  final String name;
  final int score;
  final String photoUrl;
  final bool isMe;

  const _RankCard({
    required this.rank,
    required this.name,
    required this.score,
    required this.photoUrl,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFFFFF3E8) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMe
              ? const Color(0xFFD4A045)
              : const Color.fromARGB(255, 241, 240, 240),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Text(
              '$rank',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: isMe
                    ? const Color(0xFF8B5E3C)
                    : const Color(0xFF9E9E9E),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEED9BB),
              border: Border.all(
                color: isMe
                    ? const Color(0xFF8B5E3C)
                    : const Color(0xFFD4B896),
                width: isMe ? 2 : 1.5,
              ),
            ),
            child: ClipOval(
              child: photoUrl.isNotEmpty
                  ? Image.network(
                      photoUrl,
                      width: 38,
                      height: 38,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _InitialAvatar(name: name, size: 38),
                    )
                  : _InitialAvatar(name: name, size: 38),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isMe ? 'Kamu' : name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                color: isMe
                    ? const Color(0xFF8B5E3C)
                    : const Color(0xFF4A2E0E),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$score',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: isMe
                  ? const Color(0xFF8B5E3C)
                  : const Color(0xFFC07C3A),
            ),
          ),
        ],
      ),
    );
  }
}