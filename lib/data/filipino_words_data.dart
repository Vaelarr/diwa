/// A centralized collection of Filipino words with their definitions,
/// examples, and other related data.
///
/// This class provides access to a comprehensive dictionary of complex Filipino words
/// that can be used throughout the app for Filipinos who want to learn uncommon 
/// and deep Tagalog vocabulary.

class FilipinoWordsData {
  /// A map of all Filipino words and their associated data
  static final Map<String, Map<String, dynamic>> words = {
    'bayanihan': {
      'pronunciation': 'ba·ya·ni·han',
      'partOfSpeech': 'pangngalan',
      'tagalogDefinitions': [
        'Tradisyon ng sama-samang pagtutulungan ng mga Filipino para sa kabutihan ng komunidad.',
        'Diwa ng pagkakaisa at kolektibong pagkilos upang makamit ang isang layunin.'
      ],
      'englishDefinitions': [
        'Communal unity or cooperation within a community.',
        'Working together for a common cause or goal.',
      ],
      'examples': [
        'Ang diwa ng bayanihan ay makikita sa pagtulong ng mga kapitbahay sa paglipat ng bahay ni Mang Jose.',
      ],
      'examplesTranslation': [
        'The spirit of bayanihan is seen when neighbors help in moving Mang Jose\'s house.',
      ],
      'synonyms': ['kooperasyon', 'pagkakaisa', 'damayan', 'pakikipagkapwa'],
      'translations': {'english': 'communal unity, working together for a common cause'},
      'category': ['character traits', 'culture', 'values'],
      'difficulty': 'medium',
    },
    'utang na loob': {
      'pronunciation': 'u·tang na lo·ob',
      'partOfSpeech': 'pangngalan',
      'tagalogDefinitions': [
        'Moral na obligasyon o pagkilala sa utang na kagandahang-loob.',
        'Pakiramdam ng obligasyon na suklian ang kabutihan ng iba.',
      ],
      'englishDefinitions': [
        'Debt of gratitude; moral obligation to repay kindness.',
        'Feeling of obligation to reciprocate the goodness of others.',
      ],
      'examples': [
        'Malaki ang utang na loob ko sa guro ko dahil sa kanyang paggabay sa akin.',
      ],
      'examplesTranslation': [
        'I have a great debt of gratitude to my teacher for guiding me.',
      ],
      'synonyms': ['pasasalamat', 'pagkilala', 'pagkakautang'],
      'translations': {'english': 'debt of gratitude, moral obligation'},
      'category': ['character traits', 'values', 'relationships'],
      'difficulty': 'hard',
    },
    'pakikisama': {
      'pronunciation': 'pa·ki·ki·sa·ma',
      'partOfSpeech': 'pangngalan',
      'tagalogDefinitions': [
        'Kakayahang makisalamuha at makitungo nang maayos sa ibang tao.',
        'Pagsunod sa kaugalian ng grupo para sa kabutihan ng samahan.',
      ],
      'englishDefinitions': [
        'Getting along with others; maintaining smooth interpersonal relationships.',
        'Going along with group norms for the sake of harmony.',
      ],
      'examples': [
        'Kahit hindi siya sang-ayon, pumayag siya para sa pakikisama.',
      ],
      'examplesTranslation': [
        'Even though he disagreed, he agreed for the sake of harmony.',
      ],
      'synonyms': ['pagkakasundo', 'pakikibagay', 'pakikiayon'],
      'translations': {'english': 'getting along with others, social acceptance'},
      'category': ['character traits', 'social values', 'relationships'],
      'difficulty': 'medium',
    },
    'hiya': {
      'pronunciation': 'hi·ya',
      'partOfSpeech': 'pangngalan',
      'tagalogDefinitions': [
        'Pakiramdam ng pagkapahiya o pagkawalang-mukha.',
        'Likas na katangiang nagpipigil sa paggawa ng hindi magandang asal.',
      ],
      'englishDefinitions': [
        'Shame or embarrassment; sense of propriety.',
        'Natural trait that restrains one from doing improper behavior.',
      ],
      'examples': [
        'Dahil sa hiya, hindi siya nakapagsalita sa harap ng maraming tao.',
      ],
      'examplesTranslation': [
        'Because of shame, he couldn\'t speak in front of many people.',
      ],
      'synonyms': ['kahihiyan', 'pagkapahiya', 'kahiya-hiya'],
      'translations': {'english': 'shame, embarrassment, propriety'},
      'category': ['character traits', 'emotions', 'social values'],
      'difficulty': 'medium',
    },
    'dangal': {
      'pronunciation': 'da·ngal',
      'partOfSpeech': 'pangngalan',
      'tagalogDefinitions': [
        'Katangiang moral na nagpapakita ng integridad at pagpapahalaga sa sarili.',
        'Personal na pagpapahalaga sa karangalan at magandang pangalan.',
      ],
      'englishDefinitions': [
        'Honor; dignity; moral quality showing integrity and self-worth.',
        'Personal value placed on honor and good name.',
      ],
      'examples': [
        'Pinaglaban niya ang kanyang dangal nang siya\'y pagbintangan.',
      ],
      'examplesTranslation': [
        'He fought for his honor when he was accused.',
      ],
      'synonyms': ['karangalan', 'kaluwalhatian', 'puri'],
      'translations': {'english': 'honor, dignity, integrity'},
      'category': ['character traits', 'values', 'ethics'],
      'difficulty': 'hard',
    },
    'pananagutan': {
      'pronunciation': 'pa·na·na·gu·tan',
      'partOfSpeech': 'pangngalan',
      'tagalogDefinitions': [
        'Obligasyon o tungkulin na harapin ang mga kilos at desisyon ng isang tao.',
        'Kakayahang tanggapin ang resulta ng isang pagkilos, maging positibo man o negatibo ito.',
      ],
      'englishDefinitions': [
        'Responsibility; accountability for one\'s actions and decisions.',
        'Ability to accept the consequences of one\'s actions, whether positive or negative.',
      ],
      'examples': [
        'Pananagutan ng bawat mamamayan ang pangangalaga sa kalikasan.',
      ],
      'examplesTranslation': [
        'It is every citizen\'s responsibility to care for nature.',
      ],
      'synonyms': ['responsibilidad', 'obligasyon', 'tungkulin'],
      'translations': {'english': 'responsibility, accountability, liability'},
      'category': ['character traits', 'ethics', 'personal development'],
      'difficulty': 'hard',
    },
    'malasakit': {
      'pronunciation': 'ma·la·sa·kit',
      'partOfSpeech': 'pangngalan',
      'tagalogDefinitions': [
        'Malalim na pagmamalasakit at pag-aalala para sa kapakanan ng iba.',
        'Pagkakaroon ng tunay na interes sa kagalingan ng kapwa.',
      ],
      'englishDefinitions': [
        'Compassionate concern; deep empathy for others.',
        'Having genuine interest in the welfare of others.',
      ],
      'examples': [
        'Ang tunay na malasakit ay makikita sa mga ginagawa, hindi sa mga sinasabi.',
      ],
      'examplesTranslation': [
        'True compassion is seen in actions, not in words.',
      ],
      'synonyms': ['pagmamalasakit', 'pag-aalala', 'pagkalinga'],
      'translations': {'english': 'compassionate concern, deep empathy'},
      'category': ['character traits', 'values', 'emotions'],
      'difficulty': 'medium',
    },
    'mapagkumbaba': {
      'pronunciation': 'ma·pag·kum·ba·ba',
      'partOfSpeech': 'pang-uri',
      'tagalogDefinitions': [
        'Taong hindi mayabang o mapagmalaki sa sarili.',
        'Pagkakaroon ng katangiang mahinahon at walang pagmamataas.',
      ],
      'englishDefinitions': [
        'Humility; being humble despite achievements or status.',
        'Having the quality of being modest and not arrogant.',
      ],
      'examples': [
        'Kahit mayaman siya, mapagkumbaba pa rin siya sa pakikitungo sa iba.',
      ],
      'examplesTranslation': [
        'Even though he\'s wealthy, he remains humble in dealing with others.',
      ],
      'synonyms': ['mapagpakumbaba', 'simple', 'hindi mayabang'],
      'translations': {'english': 'humble, modest, unassuming'},
      'category': ['character traits', 'values', 'personal qualities'],
      'difficulty': 'medium',
    },
    'pagtitiis': {
      'pronunciation': 'pag·ti·ti·is',
      'partOfSpeech': 'pangngalan',
      'tagalogDefinitions': [
        'Kakayahang magtiis o magbata ng kahirapan o paghihirap.',
        'Lakas ng loob na harapin ang mga pagsubok nang hindi sumusuko.',
      ],
      'englishDefinitions': [
        'Endurance; perseverance through hardship or suffering.',
        'Inner strength to face trials without giving up.',
      ],
      'examples': [
        'Ang pagtitiis ni Aling Maria ay nagdulot ng magandang kinabukasan para sa kanyang mga anak.',
      ],
      'examplesTranslation': [
        'Aling Maria\'s endurance brought a good future for her children.',
      ],
      'synonyms': ['pagtitiyaga', 'pagbabata', 'pagtitimpi'],
      'translations': {'english': 'endurance, perseverance, fortitude'},
      'category': ['character traits', 'values', 'personal strength'],
      'difficulty': 'hard',
    },
    'kagandahang-loob': {
      'pronunciation': 'ka·gan·da·hang-lo·ob',
      'partOfSpeech': 'pangngalan',
      'tagalogDefinitions': [
        'Likas na kabaitan at pagkamagandang-loob sa kapwa.',
        'Katangiang nagpapakita ng busilak na kalooban at pagtulong sa iba.',
      ],
      'englishDefinitions': [
        'Kindness; generosity of spirit toward others.',
        'Quality showing pure-heartedness and helpfulness to others.',
      ],
      'examples': [
        'Ang kanyang kagandahang-loob ang nagbigay ng pag-asa sa marami.',
      ],
      'examplesTranslation': [
        'Her kindness gave hope to many.',
      ],
      'synonyms': ['kabutihan', 'kabaitan', 'pagkamagandang-loob'],
      'translations': {'english': 'kindness, generosity of spirit, benevolence'},
      'category': ['character traits', 'values', 'virtues'],
      'difficulty': 'hard',
    },
    'tibay ng loob': {
      'pronunciation': 'ti·bay ng lo·ob',
      'partOfSpeech': 'pangngalan',
      'tagalogDefinitions': [
        'Lakas ng kalooban at determinasyon na harapin ang mga hamon.',
        'Katatagan ng damdamin laban sa mga pagsubok.',
      ],
      'englishDefinitions': [
        'Fortitude; strength of character when facing challenges.',
        'Emotional resilience against trials.',
      ],
      'examples': [
        'Ang tibay ng loob niya ang nagpatatag sa kanya sa mga pagsubok.',
      ],
      'examplesTranslation': [
        'His fortitude strengthened him through trials.',
      ],
      'synonyms': ['katatagan', 'lakas ng loob', 'tapang'],
      'translations': {'english': 'fortitude, strength of character, resilience'},
      'category': ['character traits', 'values', 'personal strength'],
      'difficulty': 'hard',
    },
    'dalamhati': {
      'pronunciation': 'da·lam·ha·ti',
      'partOfSpeech': 'pangngalan',
      'tagalogDefinitions': [
        'Matinding kalungkutan o pighati dahil sa pagkawala o trahedya.',
        'Malalim na emosyon ng pagdurusa o pagdalamdam sa isang malungkot na pangyayari.',
      ],
      'englishDefinitions': [
        'Grief; deep sorrow due to loss or tragedy.',
        'Deep emotion of suffering or mourning over a sorrowful event.',
      ],
      'examples': [
        'Nabalot siya ng dalamhati nang mamatay ang kanyang ama.',
      ],
      'examplesTranslation': [
        'She was enveloped in grief when her father died.',
      ],
      'synonyms': ['pighati', 'lumbay', 'hinagpis'],
      'translations': {'english': 'grief, deep sorrow, affliction'},
      'category': ['emotions', 'feelings', 'psychological states'],
      'difficulty': 'hard',
    },
    'kalayaan': {
      'pronunciation': 'ka·la·ya·an',
      'partOfSpeech': 'pangngalan',
      'tagalogDefinitions': [
        'Karapatan at kakayahang kumilos ayon sa sariling kagustuhan nang walang hadlang.',
        'Pagiging malaya mula sa pagkakontrol o dominasyon ng iba.',
      ],
      'englishDefinitions': [
        'Freedom; liberty to act according to one\'s own will without obstruction.',
        'Being free from control or domination of others.',
      ],
      'examples': [
        'Pinaglaban nila ang kalayaan ng bansa.',
      ],
      'examplesTranslation': [
        'They fought for the freedom of the country.',
      ],
      'synonyms': ['kasarinlan', 'independensya', 'kamalayan'],
      'translations': {'english': 'freedom, liberty, independence'},
      'category': ['abstract concepts', 'political values', 'national ideals'],
      'difficulty': 'medium',
    },
    'kapwa': {
      'pronunciation': 'kap·wa',
      'partOfSpeech': 'pangngalan',
      'tagalogDefinitions': [
        'Ibang tao na kinikilala bilang katulad o kabahagi ng sarili.',
        'Konsepto ng pagkilala sa pagkakaisa ng sarili sa iba.',
      ],
      'englishDefinitions': [
        'Fellow human being; shared identity with others.',
        'Concept of recognizing unity of self with others.',
      ],
      'examples': [
        'Ang pagmamalasakit sa kapwa ay isang mahalagang katangian.',
      ],
      'examplesTranslation': [
        'Caring for fellow humans is an important trait.',
      ],
      'synonyms': ['kapareho', 'kapantay', 'kauri'],
      'translations': {'english': 'fellow human being, shared identity, others'},
      'category': ['social terms', 'relational concepts', 'Filipino values'],
      'difficulty': 'medium',
    },
    // Additional entries would continue here with the same structure
  };

  /// Get a list of words filtered by category
  static List<String> getWordsByCategory(String category) {
    return words.keys.where((word) {
      final categories = words[word]!['category'] as List;
      return categories.contains(category);
    }).toList();
  }

  /// Get a list of words filtered by difficulty
  static List<String> getWordsByDifficulty(String difficulty) {
    return words.keys.where((word) {
      return words[word]!['difficulty'] == difficulty;
    }).toList();
  }

  /// Get words for games based on difficulty
  static List<Map<String, dynamic>> getWordsForGames(String difficulty) {
    List<String> wordsList = getWordsByDifficulty(difficulty);
    return wordsList.map((word) {
      return {
        'word': word,
        'translation': words[word]!['translations']['english'],
        'definition': words[word]!['tagalogDefinitions'][0],
      };
    }).toList();
  }

  /// Get all available categories
  static List<String> getAllCategories() {
    Set<String> categories = {};
    for (var word in words.keys) {
      final wordCategories = words[word]!['category'] as List;
      categories.addAll(wordCategories.cast<String>());
    }
    return categories.toList()..sort();
  }

  /// Get all available part of speech
  static List<String> getAllPartOfSpeech() {
    Set<String> parts = {};
    for (var word in words.keys) {
      parts.add(words[word]!['partOfSpeech'] as String);
    }
    return parts.toList()..sort();
  }
  
  /// Get Baybayin equivalents for selected common words
  static final Map<String, String> baybayinWords = {
    'bahay': 'ᜊᜑᜌ᜔',
    'araw': 'ᜀᜍᜏ᜔',
    'tubig': 'ᜆᜓᜊᜁᜄ᜔',
    'pamilya': 'ᜉᜋᜁᜎᜌ',
    'pagkain': 'ᜉᜄ᜔ᜃᜁᜈ᜔',
    'buhay': 'ᜊᜓᜑᜌ᜔',
    'salita': 'ᜐᜎᜁᜆ',
    'pag-ibig': 'ᜉᜄ᜔ᜁᜊᜁᜄ᜔',
    'dagat': 'ᜇᜄᜆ᜔',
    'langit': 'ᜎᜅᜁᜆ᜔',
  };
  
  /// Get basic Baybayin characters
  static final Map<String, String> baybayinCharacters = {
    'a': 'ᜀ',
    'e/i': 'ᜁ',
    'o/u': 'ᜂ',
    'ka': 'ᜃ',
    'ga': 'ᜄ',
    'nga': 'ᜅ',
    'ta': 'ᜆ',
    'da': 'ᜇ',
    'na': 'ᜈ',
    'pa': 'ᜉ',
    'ba': 'ᜊ',
    'ma': 'ᜋ',
    'ya': 'ᜌ',
    'la': 'ᜎ',
    'wa': 'ᜏ',
    'sa': 'ᜐ',
    'ha': 'ᜑ',
  };

  /// Get a structured format for word games with explicit correct answers
  /// This ensures there's no ambiguity about what constitutes a correct answer
  static List<Map<String, dynamic>> getWordGameData(String difficulty) {
    List<String> wordsList = getWordsByDifficulty(difficulty);
    return wordsList.map((word) {
      return {
        'word': word,
        'correctAnswer': word,  // The word itself is the correct answer
        'translation': words[word]!['translations']['english'],
        'definition': words[word]!['tagalogDefinitions'][0],
        'alternatives': [], // Empty by default, can be populated for questions with multiple correct answers
        'caseSensitive': false, // Whether matching should be case-sensitive
      };
    }).toList();
  }
  
  /// Match a user's answer with the correct answer
  /// Returns true if the answer is correct, false otherwise
  static bool validateGameAnswer(String userAnswer, String correctAnswer, {bool caseSensitive = false}) {
    if (!caseSensitive) {
      userAnswer = userAnswer.toLowerCase().trim();
      correctAnswer = correctAnswer.toLowerCase().trim();
    } else {
      userAnswer = userAnswer.trim();
      correctAnswer = correctAnswer.trim();
    }
    
    return userAnswer == correctAnswer;
  }
  
  /// Get structured uncommon Filipino words for advanced learners
  static List<Map<String, dynamic>> getUncommonWords() {
    final uncommonWords = [
      'dalumat', 'himutok', 'talinghaga', 'kababalaghan', 'panunumpa', 
      'pahiwatig', 'gunita', 'dalamhati', 'pananagutan', 'diwa'
    ];
    
    return uncommonWords.map((word) {
      if (words.containsKey(word)) {
        return {
          'word': word,
          'english': words[word]!['translations']['english'],
          'definition': words[word]!['tagalogDefinitions'][0],
          'examples': words[word]!['examples'],
          'difficulty': words[word]!['difficulty'],
        };
      } else {
        // Fallback for any words not in the database
        return {
          'word': word,
          'english': 'Translation not available',
          'definition': 'Definition not available',
          'examples': [],
          'difficulty': 'hard',
        };
      }
    }).toList();
  }
  
  /// Get categories of complex Filipino words
  static List<Map<String, dynamic>> getComplexWordCategories(String language) {
    return [
      {
        'title': language == 'Filipino' ? 'Malalim na Damdamin' : 'Deep Emotions',
        'items': ['dalamhati', 'himutok', 'gunita', 'kasiyahan']
      },
      {
        'title': language == 'Filipino' ? 'Matalinhagang Kaisipan' : 'Abstract Concepts',
        'items': ['dalumat', 'diwa', 'pananagutan', 'talinghaga']
      },
      {
        'title': language == 'Filipino' ? 'Kahiwagaan' : 'Mysticism',
        'items': ['kababalaghan', 'diwata', 'kariktan', 'pahiwatig']
      }
    ];
  }
  
  /// Get tips for learning deep Filipino words
  static List<String> getComplexWordTips(String language) {
    return [
      language == 'Filipino'
          ? 'Subukang gamitin ang mga malalim na salita sa iyong mga pang-araw-araw na pag-uusap'
          : 'Try to use these deep words in your everyday conversations',
      language == 'Filipino'
          ? 'Pansinin ang konteksto kung saan ginagamit ang mga salitang ito sa literatura'
          : 'Notice the context in which these words are used in literature',
      language == 'Filipino'
          ? 'Gumawa ng mga pangungusap gamit ang malalim na salita upang maging pamilyar sa kanila'
          : 'Create sentences using the deep words to become familiar with them'
    ];
  }
}
