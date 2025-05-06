import 'package:flutter/material.dart';
import '../data/grammar_data.dart';

class GrammarDetailPage extends StatelessWidget {
  final String language;
  final Map<String, dynamic> category;

  const GrammarDetailPage({
    Key? key,
    required this.language,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rules = GrammarData.getRulesByCategory(category['id']);
    final String title = language == 'Filipino' 
        ? category['titleFil'] 
        : category['title'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
        backgroundColor: const Color(0xFFF8F4E1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      body: Container(
        color: const Color(0xFFF8F4E1),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: rules.length,
          itemBuilder: (context, index) {
            final rule = rules[index];
            return _buildRuleCard(rule);
          },
        ),
      ),
    );
  }

  Widget _buildRuleCard(Map<String, dynamic> rule) {
    final String title = language == 'Filipino' 
        ? rule['titleFil'] 
        : rule['title'];
    
    final String explanation = language == 'Filipino'
        ? rule['explanationFil']
        : rule['explanation'];
        
    final List<Map<String, String>> examples = rule['examples'];

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              explanation,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.brown.shade700,
              ),
            ),
            if (examples.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              const Text(
                'Examples:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 8.0),
              ...examples.map((example) => _buildExampleItem(example)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExampleItem(Map<String, String> example) {
    final String filipino = example['filipino'] ?? '';
    final String english = example['english'] ?? '';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.brown.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              filipino,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              english,
              style: TextStyle(
                color: Colors.brown.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
