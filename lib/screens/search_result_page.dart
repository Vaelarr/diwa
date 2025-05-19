import 'package:flutter/material.dart';
import 'dictionary_page.dart';
import '../data/filipino_words_structured.dart';
import 'word_details_page.dart';

class SearchResultPage extends StatelessWidget {
  final String word;
  final String language;
  
  const SearchResultPage({
    Key? key,
    required this.word,
    required this.language,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final wordData = FilipinoWordsStructured.words[word];
    
    if (wordData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            language == 'Filipino' ? 'Hindi Nahanap' : 'Not Found',
          ),
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Text(
            language == 'Filipino'
                ? 'Hindi nahanap ang salitang "$word"'
                : 'The word "$word" was not found',
          ),
        ),
      );
    }
    
    final translation = wordData['translations']['english'] as String;
    final definition = (wordData['tagalogDefinitions'] as List).first;
    final examples = (wordData['examples'] as List);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(word),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    language == 'Filipino'
                        ? 'Pagbigkas ng salitang "$word"'
                        : 'Pronunciation of "$word"'
                  ),
                  backgroundColor: Colors.brown,
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F4E1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Word with pronunciation
            Text(
              word,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              wordData['pronunciation'] as String,
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick overview card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language == 'Filipino' ? 'Kahulugan sa Ingles:' : 'English Meaning:',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      translation,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const Divider(height: 24),
                    Text(
                      language == 'Filipino' ? 'Depinisyon:' : 'Definition:',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      definition as String,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    if (examples.isNotEmpty) ...[
                      const Divider(height: 24),
                      Text(
                        language == 'Filipino' ? 'Halimbawa:' : 'Example:',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        examples.first as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.book),
                    label: Text(
                      language == 'Filipino'
                          ? 'Tingnan sa Diksyunaryo'
                          : 'View in Dictionary'
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close this page
                      
                      // Navigate to dictionary
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DictionaryPage(language: language),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.info_outline),
                    label: Text(
                      language == 'Filipino'
                          ? 'Detalyadong Impormasyon'
                          : 'Detailed Information'
                    ),
                    onPressed: () {
                      // Navigate to detailed word page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WordDetailsPage(
                            word: word,
                            language: language,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Additional related words section
            Text(
              language == 'Filipino' ? 'Mga Kaugnay na Salita:' : 'Related Words:',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),
            
            _buildRelatedWords(word, language, context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRelatedWords(String word, String language, BuildContext context) {
    // Find words in the same category
    final wordData = FilipinoWordsStructured.words[word];
    if (wordData == null) return const SizedBox.shrink();
    
    final categories = wordData['category'] as List;
    final allWords = FilipinoWordsStructured.words;
    
    // Find related words (words in the same category, excluding the current word)
    final relatedWords = allWords.keys
        .where((w) => w != word && 
          (allWords[w]!['category'] as List).any((c) => categories.contains(c)))
        .take(5) // Limit to 5 related words
        .toList();
    
    if (relatedWords.isEmpty) {
      return Text(
        language == 'Filipino'
            ? 'Walang nahanap na kaugnay na salita.'
            : 'No related words found.',
        style: const TextStyle(fontStyle: FontStyle.italic),
      );
    }
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: relatedWords.map((relatedWord) {
        return ActionChip(
          label: Text(relatedWord),
          backgroundColor: Colors.brown[100],
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchResultPage(
                  word: relatedWord,
                  language: language,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
