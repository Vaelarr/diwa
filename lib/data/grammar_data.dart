class GrammarData {
  // Grammar categories data
  static List<Map<String, dynamic>> getCategories() {
    return [
      {
        'id': 'pronouns',
        'title': 'Pronouns',
        'titleFil': 'Panghalip',
        'description': 'Personal, demonstrative, and possessive pronouns in Filipino',
        'descriptionFil': 'Mga panghalip panao, pamatlig, at pananaklaw sa Filipino',
      },
      {
        'id': 'verbs',
        'title': 'Verbs',
        'titleFil': 'Pandiwa',
        'description': 'Verb conjugation and focus system in Filipino',
        'descriptionFil': 'Pagbabanghay ng pandiwa at sistema ng pokus sa Filipino',
      },
      {
        'id': 'tenses',
        'title': 'Tenses',
        'titleFil': 'Aspekto ng Pandiwa',
        'description': 'Past, present, and future tense in Filipino',
        'descriptionFil': 'Aspekto ng pangnagdaan, pangkasalukuyan, at panghinaharap',
      },
      {
        'id': 'sentences',
        'title': 'Sentence Structure',
        'titleFil': 'Balangkas ng Pangungusap',
        'description': 'Basic sentence patterns and word order in Filipino',
        'descriptionFil': 'Mga pangunahing balangkas at ayos ng pangungusap sa Filipino',
      },
      {
        'id': 'questions',
        'title': 'Question Formation',
        'titleFil': 'Pagtatanong',
        'description': 'How to form different types of questions in Filipino',
        'descriptionFil': 'Kung paano bumuo ng iba\'t ibang uri ng tanong sa Filipino',
      },
    ];
  }

  // Grammar rules data organized by category
  static List<Map<String, dynamic>> getRulesByCategory(String categoryId) {
    final allRules = {
      'pronouns': [
        {
          'title': 'Personal Pronouns',
          'titleFil': 'Panghalip Panao',
          'explanation': 'Filipino personal pronouns have three cases: Ang (nominative), Ng (genitive), and Sa (oblique).',
          'explanationFil': 'Ang panghalip panao sa Filipino ay may tatlong kaso: Ang (palagyo), Ng (paari), at Sa (palagyong may pang-ukol).',
          'examples': [
            {
              'filipino': 'Ako - Ang form, 1st person singular',
              'english': 'I - Ang form, 1st person singular'
            },
            {
              'filipino': 'Ko - Ng form, 1st person singular',
              'english': 'My/Mine - Ng form, 1st person singular'
            },
            {
              'filipino': 'Akin - Sa form, 1st person singular',
              'english': 'To/For me - Sa form, 1st person singular'
            }
          ]
        },
        {
          'title': 'Demonstrative Pronouns',
          'titleFil': 'Panghalip Pamatlig',
          'explanation': 'Filipino has three demonstrative pronouns based on distance: ito (this), iyan (that), and iyon (that over there).',
          'explanationFil': 'Ang Filipino ay may tatlong panghalip pamatlig batay sa layo: ito (malapit sa nagsasalita), iyan (malapit sa kausap), at iyon (malayo sa dalawa).',
          'examples': [
            {
              'filipino': 'Ito ang libro ko.',
              'english': 'This is my book.'
            },
            {
              'filipino': 'Iyan ba ang bahay mo?',
              'english': 'Is that your house?'
            },
            {
              'filipino': 'Iyon ang paaralan namin.',
              'english': 'That over there is our school.'
            }
          ]
        }
      ],
      'verbs': [
        {
          'title': 'Verb Focus System',
          'titleFil': 'Sistema ng Pokus ng Pandiwa',
          'explanation': 'Filipino verbs use affixes to indicate which element in the sentence is in focus: actor (actor focus), object (object focus), location, beneficiary, or instrument.',
          'explanationFil': 'Ang mga pandiwa sa Filipino ay gumagamit ng mga panlapi upang ipakita kung anong elemento sa pangungusap ang nakapokus: tagaganap, layon, lugar, tagatanggap, o kagamitan.',
          'examples': [
            {
              'filipino': 'Bumili ako ng mangga. (Actor focus)',
              'english': 'I bought a mango. (Actor focus)'
            },
            {
              'filipino': 'Binili ko ang mangga. (Object focus)',
              'english': 'I bought the mango. (Object focus)'
            }
          ]
        },
        {
          'title': 'Verb Affixes',
          'titleFil': 'Mga Panlapi ng Pandiwa',
          'explanation': 'Different affixes change the meaning or focus of Filipino verbs. Common affixes include mag-, -um-, i-, -in, and -an.',
          'explanationFil': 'Ang iba\'t ibang panlapi ay nagpapabago ng kahulugan o pokus ng mga pandiwa sa Filipino. Kasama sa mga karaniwang panlapi ang mag-, -um-, i-, -in, at -an.',
          'examples': [
            {
              'filipino': 'Kumain - to eat (actor focus)',
              'english': 'Kumain - to eat (actor focus)'
            },
            {
              'filipino': 'Kainin - to eat (object focus)',
              'english': 'Kainin - to eat (object focus)'
            }
          ]
        }
      ],
      'tenses': [
        {
          'title': 'Past Tense',
          'titleFil': 'Aspektong Naganap',
          'explanation': 'Past tense in Filipino is formed by changing the first syllable of the verb to "in" for -in verbs, adding "in-" for i- verbs, and changing "um" to "um-" + first syllable repetition for -um verbs.',
          'explanationFil': 'Ang aspektong naganap sa Filipino ay nabubuo sa pamamagitan ng pagbabago ng unang pantig ng pandiwa sa "in" para sa -in na mga pandiwa, pagdagdag ng "in-" para sa i- na mga pandiwa, at pagpapalit ng "um" sa "um-" + pag-uulit ng unang pantig para sa -um na mga pandiwa.',
          'examples': [
            {
              'filipino': 'Kinain ko ang tinapay. (-in verb)',
              'english': 'I ate the bread. (-in verb)'
            },
            {
              'filipino': 'Inihagis niya ang bola. (i- verb)',
              'english': 'He threw the ball. (i- verb)'
            },
            {
              'filipino': 'Pumunta siya sa palengke. (-um verb)',
              'english': 'She went to the market. (-um verb)'
            }
          ]
        },
        {
          'title': 'Present Tense',
          'titleFil': 'Aspektong Kasalukuyan',
          'explanation': 'Present tense in Filipino typically involves repeating the first syllable of the verb root.',
          'explanationFil': 'Ang aspektong kasalukuyan sa Filipino ay karaniwang kinabibilangan ng pag-uulit ng unang pantig ng ugat ng pandiwa.',
          'examples': [
            {
              'filipino': 'Kumakain ako ng tinapay.',
              'english': 'I am eating bread.'
            },
            {
              'filipino': 'Nagluluto siya ng hapunan.',
              'english': 'She is cooking dinner.'
            }
          ]
        },
        {
          'title': 'Future Tense',
          'titleFil': 'Aspektong Magaganap',
          'explanation': 'Future tense in Filipino uses the prefix "mag-" or the aspect marker "ay" with a base form.',
          'explanationFil': 'Ang aspektong magaganap sa Filipino ay gumagamit ng unlaping "mag-" o ng pantukoy na "ay" kasama ang anyong-batayan.',
          'examples': [
            {
              'filipino': 'Kakain ako bukas.',
              'english': 'I will eat tomorrow.'
            },
            {
              'filipino': 'Magluluto siya ng hapunan mamayang gabi.',
              'english': 'She will cook dinner later tonight.'
            }
          ]
        }
      ],
      'sentences': [
        {
          'title': 'Basic Sentence Structure',
          'titleFil': 'Pangunahing Balangkas ng Pangungusap',
          'explanation': 'Filipino sentences follow either Predicate-Subject (Panaguri-Paksa) or Subject-Predicate (Paksa-Panaguri) order.',
          'explanationFil': 'Ang mga pangungusap sa Filipino ay sumusunod sa alinman sa ayos na Panaguri-Paksa o Paksa-Panaguri.',
          'examples': [
            {
              'filipino': 'Kumakain ang bata. (Predicate-Subject)',
              'english': 'The child is eating. (Predicate-Subject)'
            },
            {
              'filipino': 'Ang bata ay kumakain. (Subject-Predicate)',
              'english': 'The child is eating. (Subject-Predicate)'
            }
          ]
        },
        {
          'title': 'Markers',
          'titleFil': 'Mga Pantukoy',
          'explanation': 'Filipino uses markers like "ang" (definite subject), "ng" (object/possessive), and "sa" (location/direction) to indicate the role of nouns in a sentence.',
          'explanationFil': 'Ang Filipino ay gumagamit ng mga pantukoy tulad ng "ang" (tiyak na paksa), "ng" (layon/pagmamay-ari), at "sa" (lugar/direksyon) upang ipahiwatig ang tungkulin ng mga pangngalan sa pangungusap.',
          'examples': [
            {
              'filipino': 'Binili ng lalaki ang libro sa tindahan.',
              'english': 'The man bought the book at the store.'
            },
            {
              'filipino': 'Ang libro ng lalaki ay nasa mesa.',
              'english': 'The man\'s book is on the table.'
            }
          ]
        }
      ],
      'questions': [
        {
          'title': 'Question Words',
          'titleFil': 'Mga Salitang Pananong',
          'explanation': 'Filipino uses question words like "ano" (what), "sino" (who), "kailan" (when), "saan" (where), "bakit" (why), and "paano" (how).',
          'explanationFil': 'Ang Filipino ay gumagamit ng mga salitang pananong tulad ng "ano", "sino", "kailan", "saan", "bakit", at "paano".',
          'examples': [
            {
              'filipino': 'Ano ang pangalan mo?',
              'english': 'What is your name?'
            },
            {
              'filipino': 'Sino ang gumawa nito?',
              'english': 'Who did this?'
            },
            {
              'filipino': 'Kailan ka darating?',
              'english': 'When will you arrive?'
            }
          ]
        },
        {
          'title': 'Yes/No Questions',
          'titleFil': 'Mga Tanong na Oo/Hindi',
          'explanation': 'Yes/no questions in Filipino are often formed by adding the particle "ba" after the first element of the predicate.',
          'explanationFil': 'Ang mga tanong na oo/hindi sa Filipino ay madalas na binubuo sa pamamagitan ng pagdaragdag ng katagang "ba" pagkatapos ng unang elemento ng panaguri.',
          'examples': [
            {
              'filipino': 'Kumain ka na ba?',
              'english': 'Have you eaten already?'
            },
            {
              'filipino': 'Masarap ba ang pagkain?',
              'english': 'Is the food delicious?'
            }
          ]
        }
      ],
    };

    return allRules[categoryId] ?? [];
  }
}
