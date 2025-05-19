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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 22 : 18,
          ),
        ),
        backgroundColor: Colors.indigo,
        elevation: 2,
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
          itemCount: rules.length,
          itemBuilder: (context, index) {
            final rule = rules[index];
            return _buildRuleCard(rule, isTablet);
          },
        ),
      ),
    );
  }

  Widget _buildRuleCard(Map<String, dynamic> rule, bool isTablet) {
    final String title = language == 'Filipino' 
        ? rule['titleFil'] 
        : rule['title'];
    
    final String explanation = language == 'Filipino'
        ? rule['explanationFil']
        : rule['explanation'];
        
    final List<Map<String, String>> examples = rule['examples'];

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: isTablet ? 18.0 : 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[700],
              ),
            ),
            SizedBox(height: isTablet ? 12.0 : 8.0),
            Text(
              explanation,
              style: TextStyle(
                fontSize: isTablet ? 14.0 : 13.0,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
            if (examples.isNotEmpty) ...[
              SizedBox(height: isTablet ? 16.0 : 12.0),
              Text(
                language == 'Filipino' ? 'Mga Halimbawa:' : 'Examples:',
                style: TextStyle(
                  fontSize: isTablet ? 16.0 : 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[700],
                ),
              ),
              SizedBox(height: isTablet ? 8.0 : 6.0),
              ...examples.map((example) => _buildExampleItem(example, isTablet)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExampleItem(Map<String, String> example, bool isTablet) {
    final String filipino = example['filipino'] ?? '';
    final String english = example['english'] ?? '';
    
    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 8.0 : 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.indigo.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.all(isTablet ? 12.0 : 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              filipino,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo[700],
                fontSize: isTablet ? 14.0 : 13.0,
              ),
            ),
            SizedBox(height: isTablet ? 4.0 : 2.0),
            Text(
              english,
              style: TextStyle(
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
                fontSize: isTablet ? 13.0 : 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
