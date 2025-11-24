import 'package:flutter/material.dart';

class LeaguesScreen extends StatelessWidget {
  const LeaguesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sürüş Ligleri'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCurrentLeagueCard(),
          const SizedBox(height: 24),
          _buildLeaderboard(),
          const SizedBox(height: 24),
          _buildAchievements(),
        ],
      ),
    );
  }

  Widget _buildCurrentLeagueCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bronz Lig',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[400],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sıralaman: #15',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.brown[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    size: 32,
                    color: Colors.brown[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Puan', '750', Colors.brown[400]!),
                _buildStatColumn('Haftalık', '50 EC', Colors.amber),
                _buildStatColumn('Hedef', '1000', Colors.grey[600]!),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.75,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[400]!),
            ),
            const SizedBox(height: 8),
            Text(
              '250 puan daha Gümüş Lig\'e yükseliyorsun! 🚀',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lider Tablosu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildLeaderboardItem(
          rank: 1,
          name: 'Ahmet Y.',
          points: 950,
          reward: '100 EC',
          isTopThree: true,
        ),
        _buildLeaderboardItem(
          rank: 2,
          name: 'Zeynep K.',
          points: 920,
          reward: '80 EC',
          isTopThree: true,
        ),
        _buildLeaderboardItem(
          rank: 3,
          name: 'Mehmet A.',
          points: 895,
          reward: '60 EC',
          isTopThree: true,
        ),
        const Divider(height: 24),
        _buildLeaderboardItem(
          rank: 15,
          name: 'Sen',
          points: 750,
          reward: '50 EC',
          isCurrentUser: true,
        ),
      ],
    );
  }

  Widget _buildLeaderboardItem({
    required int rank,
    required String name,
    required int points,
    required String reward,
    bool isTopThree = false,
    bool isCurrentUser = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.blue[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser
            ? Border.all(color: Colors.blue, width: 2)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isTopThree ? Colors.amber[100] : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isTopThree ? Colors.amber[800] : Colors.grey[700],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$points puan',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              reward,
              style: TextStyle(
                color: Colors.amber[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Başarılarım',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Tümü'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildAchievementCard(
                icon: Icons.eco,
                title: 'Eko Sürücü',
                progress: 1.0,
                isUnlocked: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAchievementCard(
                icon: Icons.route,
                title: 'Mesafe Ustası',
                progress: 0.65,
                isUnlocked: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildAchievementCard(
                icon: Icons.handshake,
                title: 'Topluluk Kahramanı',
                progress: 0.4,
                isUnlocked: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAchievementCard(
                icon: Icons.calendar_today,
                title: 'Mükemmel Hafta',
                progress: 0.2,
                isUnlocked: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievementCard({
    required IconData icon,
    required String title,
    required double progress,
    required bool isUnlocked,
  }) {
    return Card(
      color: isUnlocked ? Colors.amber[50] : Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isUnlocked ? Colors.amber[700] : Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? Colors.amber[700] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                isUnlocked ? Colors.amber : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isUnlocked ? 'Kazanıldı!' : '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
