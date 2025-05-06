import 'package:flutter/material.dart';
import '../data/grammar_data.dart';
import 'grammar_detail_page.dart';

class GrammarPage extends StatefulWidget {
  final String language;

  const GrammarPage({
    Key? key,
    required this.language,
  }) : super(key: key);

  @override
  State<GrammarPage> createState() => _GrammarPageState();
}

class _GrammarPageState extends State<GrammarPage> {
  late List<Map<String, dynamic>> grammarCategories;

  @override
  void initState() {
    super.initState();
    grammarCategories = GrammarData.getCategories();
  }

  String get _pageTitle => widget.language == 'Filipino' ? 'Gramatika' : 'Grammar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitle,
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
          itemCount: grammarCategories.length,
          itemBuilder: (context, index) {
            final category = grammarCategories[index];
            return _buildCategoryCard(category);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    final String title = widget.language == 'Filipino' 
        ? category['titleFil'] 
        : category['title'];
    
    final String description = widget.language == 'Filipino'
        ? category['descriptionFil']
        : category['description'];

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GrammarDetailPage(
                language: widget.language,
                category: category,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getCategoryIcon(category['id']),
                    color: Colors.brown,
                    size: 32.0,
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.brown.shade600,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.language == 'Filipino' ? 'Matuto nang higit pa' : 'Learn more',
                    style: TextStyle(
                      color: Colors.brown.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.brown,
                    size: 14.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'pronouns':
        return Icons.person;
      case 'verbs':
        return Icons.change_circle;
      case 'tenses':
        return Icons.access_time;
      case 'sentences':
        return Icons.text_fields;
      case 'questions':
        return Icons.help;
      default:
        return Icons.menu_book;
    }
  }
}
