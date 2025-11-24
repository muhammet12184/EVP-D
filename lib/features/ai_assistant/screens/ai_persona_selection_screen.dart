import 'package:flutter/material.dart';
import '../../../core/models/ai_persona_model.dart';

class AIPersonaSelectionScreen extends StatefulWidget {
  const AIPersonaSelectionScreen({super.key});

  @override
  State<AIPersonaSelectionScreen> createState() =>
      _AIPersonaSelectionScreenState();
}

class _AIPersonaSelectionScreenState extends State<AIPersonaSelectionScreen> {
  AIPersona? _selectedPersona;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Asistanını Seç'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Senin için en uygun asistan kim?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'AI asistanınız size özel bir kişiliğe bürünecek. '
            'İstediğiniz zaman değiştirebilirsiniz.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),
          _buildPersonaCard(AIPersona.kahya),
          const SizedBox(height: 16),
          _buildPersonaCard(AIPersona.kanka),
          const SizedBox(height: 16),
          _buildPersonaCard(AIPersona.koc),
          const SizedBox(height: 24),
          if (_selectedPersona != null) _buildExampleDialog(),
        ],
      ),
      bottomNavigationBar: _selectedPersona != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    // Save selection
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Asistanı Seç'),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildPersonaCard(AIPersona persona) {
    final isSelected = _selectedPersona?.id == persona.id;

    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPersona = persona;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _getPersonaColor(persona).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      _getPersonaIcon(persona),
                      size: 32,
                      color: _getPersonaColor(persona),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          persona.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          persona.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                      size: 32,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💬 Örnek konuşma:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"${persona.greetings.first}"',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExampleDialog() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'Örnek Durumlar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildExampleItem(
              'Sen: "Üşüdüm"',
              _selectedPersona!.getContextualResponse('cold') ?? '',
            ),
            const Divider(height: 16),
            _buildExampleItem(
              'Sen: "Klimayı aç"',
              _selectedPersona!.getRandomAcknowledgment(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleItem(String userInput, String response) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userInput,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          response,
          style: TextStyle(
            color: Colors.grey[700],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Color _getPersonaColor(AIPersona persona) {
    switch (persona.type) {
      case AIPersonaType.kahya:
        return Colors.blue;
      case AIPersonaType.kanka:
        return Colors.orange;
      case AIPersonaType.koc:
        return Colors.red;
    }
  }

  IconData _getPersonaIcon(AIPersona persona) {
    switch (persona.type) {
      case AIPersonaType.kahya:
        return Icons.supervisor_account;
      case AIPersonaType.kanka:
        return Icons.emoji_emotions;
      case AIPersonaType.koc:
        return Icons.sports_martial_arts;
    }
  }
}
