import 'package:flutter/material.dart';

class ImeceMapScreen extends StatefulWidget {
  const ImeceMapScreen({super.key});

  @override
  State<ImeceMapScreen> createState() => _ImeceMapScreenState();
}

class _ImeceMapScreenState extends State<ImeceMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İmece - Topluluk Yardımı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              _showHistorySheet();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map would go here (Mapbox integration)
          Container(
            color: Colors.grey[300],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 64, color: Colors.grey[500]),
                  const SizedBox(height: 16),
                  Text(
                    'Harita entegrasyonu (Mapbox)',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          
          // Request cards at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildRequestsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateRequestSheet();
        },
        icon: const Icon(Icons.add),
        label: const Text('Yardım İste'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildRequestsList() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Yakındaki Yardım Talepleri',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '3 aktif',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildRequestCard(
                  type: 'Lastik Patladı',
                  distance: '2.5 km',
                  reward: '150 EC',
                  time: '10 dk önce',
                  icon: Icons.tire_repair,
                ),
                _buildRequestCard(
                  type: 'Yakıt Bitti',
                  distance: '5.8 km',
                  reward: '100 EC',
                  time: '25 dk önce',
                  icon: Icons.local_gas_station,
                ),
                _buildRequestCard(
                  type: 'Şarj Bitti',
                  distance: '8.2 km',
                  reward: '100 EC',
                  time: '35 dk önce',
                  icon: Icons.battery_alert,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard({
    required String type,
    required String distance,
    required String reward,
    required String time,
    required IconData icon,
  }) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  distance,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
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
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showAcceptDialog(type);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text('Yardım Et'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateRequestSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Yardım Talebi Oluştur',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const Text('Ne tür bir yardıma ihtiyacın var?'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTypeChip('Lastik Patladı', Icons.tire_repair),
                  _buildTypeChip('Yakıt Bitti', Icons.local_gas_station),
                  _buildTypeChip('Şarj Bitti', Icons.battery_alert),
                  _buildTypeChip('Mekanik Arıza', Icons.build),
                  _buildTypeChip('Diğer', Icons.help_outline),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Açıklama (opsiyonel)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showRequestCreatedDialog();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange,
                ),
                child: const Text('Talep Gönder'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, IconData icon) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
      onSelected: (selected) {},
    );
  }

  void _showAcceptDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yardım Talebi'),
        content: Text('$type yardım talebini kabul etmek istiyor musun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showNavigationDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Kabul Et'),
          ),
        ],
      ),
    );
  }

  void _showNavigationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tebrikler! 🎉'),
        content: const Text(
          'Yardım talebini kabul ettin. '
          'Navigasyon başlatılıyor...\n\n'
          'Bu yardımdan 150 EcoCoin kazanacaksın!',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Başla'),
          ),
        ],
      ),
    );
  }

  void _showRequestCreatedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Talep Gönderildi! 📢'),
        content: const Text(
          'Yardım talebin yakındaki kullanıcılara bildirildi. '
          'Birisi kabul ettiğinde seni bilgilendireceğiz.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showHistorySheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Yardım Geçmişin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn('Toplam', '12'),
                  _buildStatColumn('Bu Ay', '3'),
                  _buildStatColumn('Kazanç', '1,500 EC'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Son Yardımlar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _buildHistoryItem(
                    'Lastik Patladı',
                    '3 gün önce',
                    '150 EC',
                    Icons.tire_repair,
                  ),
                  _buildHistoryItem(
                    'Yakıt Bitti',
                    '1 hafta önce',
                    '100 EC',
                    Icons.local_gas_station,
                  ),
                  _buildHistoryItem(
                    'Mekanik Arıza',
                    '2 hafta önce',
                    '200 EC',
                    Icons.build,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
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

  Widget _buildHistoryItem(
    String type,
    String time,
    String reward,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.orange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            reward,
            style: TextStyle(
              color: Colors.amber[800],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
