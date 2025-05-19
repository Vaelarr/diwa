/// A structured collection of Filipino words with their definitions,
/// examples, and grammatical information based on words.txt.
///
/// This file categorizes Filipino words according to their parts of speech
/// as defined in grammar_data.dart and structures them similarly to filipino_words_data.dart.

class FilipinoWordsStructured {
  /// A map of all Filipino words and their associated data
  static final Map<String, Map<String, dynamic>> words = {
      'bayanihan': {
    'pronunciation': 'ba·ya·ni·han',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Pagkakaisa ng komunidad; pagtutulungan para sa isang layunin.',
    ],
    'englishDefinitions': [
      'Communal unity; working together for a common cause.',
    ],
    'examples': [
      'Ang diwa ng bayanihan ay makikita sa pagtulong ng mga kapitbahay sa paglipat ng bahay ni Mang Jose.',
    ],
    'examplesTranslation': [
      'The spirit of bayanihan is seen when neighbors help in moving Mang Jose\'s house.',
    ],
    'synonyms': ['pagkakaisa', 'pagtutulungan', 'kooperasyon', 'damayan'],
    'translations': {'english': 'communal unity, community spirit, cooperation'},
    'category': ['filipino values', 'social concepts', 'community'],
    'difficulty': 'medium',
  },
  
  'utang na loob': {
    'pronunciation': 'u·tang na lo·ob',
    'partOfSpeech': 'parirala', // phrase
    'tagalogDefinitions': [
      'Katungkulang moral na maibalik ang kabutihan.',
    ],
    'englishDefinitions': [
      'Debt of gratitude; moral obligation to repay kindness.',
    ],
    'examples': [
      'Malaki ang utang na loob ko sa guro ko dahil sa kanyang paggabay sa akin.',
    ],
    'examplesTranslation': [
      'I have a great debt of gratitude to my teacher for guiding me.',
    ],
    'synonyms': ['pagkakautang', 'pagkakahutang', 'obligasyon'],
    'translations': {'english': 'debt of gratitude, moral obligation, indebtedness'},
    'category': ['filipino values', 'social concepts', 'moral obligations'],
    'difficulty': 'hard',
  },
  
  'pakikisama': {
    'pronunciation': 'pa·ki·ki·sa·ma',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Pakikibagay sa iba; pagpapanatili ng magandang relasyon.',
    ],
    'englishDefinitions': [
      'Getting along with others; maintaining smooth interpersonal relationships.',
    ],
    'examples': [
      'Kahit hindi siya sang-ayon, pumayag siya para sa pakikisama.',
    ],
    'examplesTranslation': [
      'Even though he disagreed, he agreed for the sake of harmony.',
    ],
    'synonyms': ['pagkakasundo', 'pakikibagay', 'pakikihalubilo'],
    'translations': {'english': 'camaraderie, getting along, social acceptance'},
    'category': ['filipino values', 'social interaction', 'relationships'],
    'difficulty': 'medium',
  },
  
  'hiya': {
    'pronunciation': 'hi·ya',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Kahihiyan; pagkamahiyain; kamalayan sa nararapat.',
    ],
    'englishDefinitions': [
      'Shame or embarrassment; sense of propriety.',
    ],
    'examples': [
      'Dahil sa hiya, hindi siya nakapagsalita sa harap ng maraming tao.',
    ],
    'examplesTranslation': [
      'Because of shame, he couldn\'t speak in front of many people.',
    ],
    'synonyms': ['kahihiyan', 'pagkamahiyain', 'kababaang-loob'],
    'translations': {'english': 'shame, embarrassment, shyness, propriety'},
    'category': ['emotions', 'filipino values', 'social feelings'],
    'difficulty': 'easy',
  },
  
  'dangal': {
    'pronunciation': 'da·ngal',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Karangalan; puri.',
    ],
    'englishDefinitions': [
      'Honor; dignity.',
    ],
    'examples': [
      'Pinaglaban niya ang kanyang dangal nang siya\'y pagbintangan.',
    ],
    'examplesTranslation': [
      'He fought for his honor when he was accused.',
    ],
    'synonyms': ['karangalan', 'puri', 'kaluwalhatian', 'karangalan'],
    'translations': {'english': 'honor, dignity, integrity'},
    'category': ['filipino values', 'ethical concepts', 'personal attributes'],
    'difficulty': 'medium',
  },
  
  'pananagutan': {
    'pronunciation': 'pa·na·na·gu·tan',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Responsibilidad; tungkulin.',
    ],
    'englishDefinitions': [
      'Responsibility; accountability.',
    ],
    'examples': [
      'Pananagutan ng bawat mamamayan ang pangangalaga sa kalikasan.',
    ],
    'examplesTranslation': [
      'It is every citizen\'s responsibility to care for nature.',
    ],
    'synonyms': ['responsibilidad', 'tungkulin', 'obligasyon', 'katungkulan'],
    'translations': {'english': 'responsibility, accountability, obligation'},
    'category': ['filipino values', 'ethical concepts', 'civic duties'],
    'difficulty': 'medium',
  },
  
  'malasakit': {
    'pronunciation': 'ma·la·sa·kit',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Pagmamalasakit; malalim na pakikiramay.',
    ],
    'englishDefinitions': [
      'Compassionate concern; deep empathy.',
    ],
    'examples': [
      'Ang tunay na malasakit ay makikita sa mga ginagawa, hindi sa mga sinasabi.',
    ],
    'examplesTranslation': [
      'True compassion is seen in actions, not in words.',
    ],
    'synonyms': ['pagmamalasakit', 'pakikiramay', 'pagkalinga', 'pag-aaruga'],
    'translations': {'english': 'compassion, concern, empathy, solicitude'},
    'category': ['filipino values', 'emotions', 'caring'],
    'difficulty': 'medium',
  },
  
  'mapagkumbaba': {
    'pronunciation': 'ma·pag·kum·ba·ba',
    'partOfSpeech': 'pang-uri', // adjective
    'tagalogDefinitions': [
      'Kababaang-loob; pagpapakumbaba.',
    ],
    'englishDefinitions': [
      'Humility; being humble.',
    ],
    'examples': [
      'Kahit mayaman siya, mapagkumbaba pa rin siya sa pakikitungo sa iba.',
    ],
    'examplesTranslation': [
      'Even though he\'s wealthy, he remains humble in dealing with others.',
    ],
    'synonyms': ['mababang-loob', 'mahinhin', 'hindi mapagmalaki'],
    'translations': {'english': 'humble, modest, unassuming'},
    'category': ['filipino values', 'personal attributes', 'character traits'],
    'difficulty': 'medium',
  },
  
  'pagtitiis': {
    'pronunciation': 'pag·ti·ti·is',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Pagtitiyaga; pagdurusa nang maluwag sa kalooban.',
    ],
    'englishDefinitions': [
      'Endurance; perseverance through hardship.',
    ],
    'examples': [
      'Ang pagtitiis ni Aling Maria ay nagdulot ng magandang kinabukasan para sa kanyang mga anak.',
    ],
    'examplesTranslation': [
      'Aling Maria\'s endurance brought a good future for her children.',
    ],
    'synonyms': ['pagtitiyaga', 'pagbabata', 'pasensya', 'pagtitiis'],
    'translations': {'english': 'endurance, perseverance, forbearance, patience'},
    'category': ['filipino values', 'personal attributes', 'resilience'],
    'difficulty': 'medium',
  },
  
  'kagandahang-loob': {
    'pronunciation': 'ka·gan·da·hang-lo·ob',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Kabutihan; pagkabukas-palad.',
    ],
    'englishDefinitions': [
      'Kindness; generosity of spirit.',
    ],
    'examples': [
      'Ang kanyang kagandahang-loob ang nagbigay ng pag-asa sa marami.',
    ],
    'examplesTranslation': [
      'Her kindness gave hope to many.',
    ],
    'synonyms': ['kabutihan', 'pagkabukas-palad', 'kabaitan', 'pagkamatulungin'],
    'translations': {'english': 'kindness, generosity, benevolence'},
    'category': ['filipino values', 'personal attributes', 'virtues'],
    'difficulty': 'medium',
  },
  
  'tibay ng loob': {
    'pronunciation': 'ti·bay ng lo·ob',
    'partOfSpeech': 'parirala', // phrase
    'tagalogDefinitions': [
      'Lakas ng kalooban; katatagan.',
    ],
    'englishDefinitions': [
      'Fortitude; strength of character.',
    ],
    'examples': [
      'Ang tibay ng loob niya ang nagpatatag sa kanya sa mga pagsubok.',
    ],
    'examplesTranslation': [
      'His fortitude strengthened him through trials.',
    ],
    'synonyms': ['katatagan', 'tapang', 'lakas ng kalooban', 'determinasyon'],
    'translations': {'english': 'fortitude, courage, strength of character, resilience'},
    'category': ['filipino values', 'personal attributes', 'mental strength'],
    'difficulty': 'medium',
  },
  
  'karangalan': {
    'pronunciation': 'ka·ra·nga·lan',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Dangal; papuri; kaluwalhatian.',
    ],
    'englishDefinitions': [
      'Honor; glory; dignity.',
    ],
    'examples': [
      'Dinala niya ang karangalan sa ating bansa nang manalo siya sa kompetisyon.',
    ],
    'examplesTranslation': [
      'He brought honor to our country when he won the competition.',
    ],
    'synonyms': ['dangal', 'papuri', 'kaluwalhatian', 'pagpapahalaga'],
    'translations': {'english': 'honor, glory, dignity, prestige'},
    'category': ['filipino values', 'achievements', 'social recognition'],
    'difficulty': 'medium',
  },
  
  'katapatan': {
    'pronunciation': 'ka·ta·pa·tan',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Pagiging tapat; katapatan sa pangako.',
    ],
    'englishDefinitions': [
      'Loyalty; faithfulness.',
    ],
    'examples': [
      'Ang katapatan niya sa kanyang prinsipyo ay hindi natinag.',
    ],
    'examplesTranslation': [
      'His loyalty to his principles did not waver.',
    ],
    'synonyms': ['pagiging tapat', 'pagkamatapat', 'debosyon', 'pagkamasunurin'],
    'translations': {'english': 'loyalty, faithfulness, fidelity, devotion'},
    'category': ['filipino values', 'personal attributes', 'relationships'],
    'difficulty': 'medium',
  },
  
  'matiisin': {
    'pronunciation': 'ma·ti·i·sin',
    'partOfSpeech': 'pang-uri', // adjective
    'tagalogDefinitions': [
      'Mapagtiis; matiyaga.',
    ],
    'englishDefinitions': [
      'Long-suffering; patient.',
    ],
    'examples': [
      'Matiisin si Lola sa pag-aalaga ng kanyang mga apo.',
    ],
    'examplesTranslation': [
      'Grandmother is patient in taking care of her grandchildren.',
    ],
    'synonyms': ['mapagtiis', 'matiyaga', 'mapagbata', 'pasensyoso'],
    'translations': {'english': 'patient, long-suffering, forbearing, enduring'},
    'category': ['filipino values', 'personal attributes', 'character traits'],
    'difficulty': 'easy',
  },
  
  'matiyaga': {
    'pronunciation': 'ma·ti·ya·ga',
    'partOfSpeech': 'pang-uri', // adjective
    'tagalogDefinitions': [
      'Masipag; hindi sumusuko.',
    ],
    'englishDefinitions': [
      'Persevering; persistent.',
    ],
    'examples': [
      'Matiyaga siyang nagtanim ng gulay sa kanyang bakuran.',
    ],
    'examplesTranslation': [
      'She persevered in planting vegetables in her yard.',
    ],
    'synonyms': ['masipag', 'pursigido', 'determinado', 'masinop'],
    'translations': {'english': 'persevering, persistent, diligent, industrious'},
    'category': ['filipino values', 'personal attributes', 'work ethics'],
    'difficulty': 'easy',
  },
  
  'mapagbigay': {
    'pronunciation': 'ma·pag·bi·gay',
    'partOfSpeech': 'pang-uri', // adjective
    'tagalogDefinitions': [
      'Bukas-palad; hindi maramot.',
    ],
    'englishDefinitions': [
      'Generous; giving.',
    ],
    'examples': [
      'Mapagbigay siya kahit may kakapusan din siya sa buhay.',
    ],
    'examplesTranslation': [
      'He is generous even though he also has scarcity in life.',
    ],
    'synonyms': ['bukas-palad', 'matulungin', 'hindi madamot', 'maalwan'],
    'translations': {'english': 'generous, giving, charitable, benevolent'},
    'category': ['filipino values', 'personal attributes', 'character traits'],
    'difficulty': 'easy',
  },
  
  'mapagmahal': {
    'pronunciation': 'ma·pag·ma·hal',
    'partOfSpeech': 'pang-uri', // adjective
    'tagalogDefinitions': [
      'Puno ng pagmamahal; malambing.',
    ],
    'englishDefinitions': [
      'Loving; affectionate.',
    ],
    'examples': [
      'Mapagmahal na ina si Maria sa kanyang mga anak.',
    ],
    'examplesTranslation': [
      'Maria is a loving mother to her children.',
    ],
    'synonyms': ['malambing', 'mapagkalinga', 'maalaga', 'mapagmalasakit'],
    'translations': {'english': 'loving, affectionate, caring, nurturing'},
    'category': ['emotions', 'relationships', 'personal attributes'],
    'difficulty': 'easy',
  },
  
  'disiplina': {
    'pronunciation': 'di·si·pli·na',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Pagpipigil sa sarili; pagsasanay.',
    ],
    'englishDefinitions': [
      'Discipline; self-control.',
    ],
    'examples': [
      'Ang disiplina ang susi para sa tagumpay.',
    ],
    'examplesTranslation': [
      'Discipline is the key to success.',
    ],
    'synonyms': ['pagpipigil-sarili', 'pagsasanay', 'pagkontrol', 'pagdidisiplina'],
    'translations': {'english': 'discipline, self-control, training, restraint'},
    'category': ['filipino values', 'personal development', 'character traits'],
    'difficulty': 'easy',
  },
  
  'paggalang': {
    'pronunciation': 'pag·ga·lang',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Respeto; pagkilala sa kahalagahan ng iba.',
    ],
    'englishDefinitions': [
      'Respect; reverence.',
    ],
    'examples': [
      'Ipinakita niya ang paggalang sa mga nakatatanda.',
    ],
    'examplesTranslation': [
      'He showed respect to elders.',
    ],
    'synonyms': ['respeto', 'pagpipitagan', 'paggalang', 'pag-uurong'],
    'translations': {'english': 'respect, reverence, deference, honor'},
    'category': ['filipino values', 'social interaction', 'etiquette'],
    'difficulty': 'easy',
  },
  
  'sigasig': {
    'pronunciation': 'si·ga·sig',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Kasigasigan; kasabikan.',
    ],
    'englishDefinitions': [
      'Enthusiasm; zeal.',
    ],
    'examples': [
      'Ang sigasig niya sa trabaho ay nakakahawa.',
    ],
    'examplesTranslation': [
      'His enthusiasm at work is contagious.',
    ],
    'synonyms': ['kasigasigan', 'kasabikan', 'sigla', 'kasipagan'],
    'translations': {'english': 'enthusiasm, zeal, eagerness, fervor'},
    'category': ['emotions', 'work ethics', 'personal attributes'],
    'difficulty': 'medium',
  },
  
  'kasipagan': {
    'pronunciation': 'ka·si·pa·gan',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Pagiging masipag; pagsusumikap.',
    ],
    'englishDefinitions': [
      'Industriousness; diligence.',
    ],
    'examples': [
      'Ang kanyang kasipagan ang nagdala sa kanya sa tagumpay.',
    ],
    'examplesTranslation': [
      'His industriousness brought him to success.',
    ],
    'synonyms': ['pagiging masipag', 'pagsusumikap', 'katiyagaan', 'kasisipagan'],
    'translations': {'english': 'industriousness, diligence, hard work, assiduity'},
    'category': ['filipino values', 'work ethics', 'personal attributes'],
    'difficulty': 'easy',
  },
  
  'katatagan': {
    'pronunciation': 'ka·ta·ta·gan',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Tibay; hindi pabagu-bago.',
    ],
    'englishDefinitions': [
      'Stability; steadfastness.',
    ],
    'examples': [
      'Ang katatagan ng pamilya ay nakakatulong sa mga anak.',
    ],
    'examplesTranslation': [
      'The stability of the family helps the children.',
    ],
    'synonyms': ['tibay', 'tatag', 'lakas', 'kahandaan'],
    'translations': {'english': 'stability, steadfastness, firmness, resilience'},
    'category': ['filipino values', 'personal attributes', 'resilience'],
    'difficulty': 'medium',
  },
  
  'pagkamatapat': {
    'pronunciation': 'pag·ka·ma·ta·pat',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Katapatan; integridad.',
    ],
    'englishDefinitions': [
      'Honesty; integrity.',
    ],
    'examples': [
      'Ang pagkamatapat niya ay pinahahalagahan ng lahat.',
    ],
    'examplesTranslation': [
      'His honesty is valued by everyone.',
    ],
    'synonyms': ['katapatan', 'integridad', 'kadalisayan', 'karangalan'],
    'translations': {'english': 'honesty, integrity, truthfulness, uprightness'},
    'category': ['filipino values', 'personal attributes', 'ethical concepts'],
    'difficulty': 'medium',
  },
  
  'pagkalinga': {
    'pronunciation': 'pag·ka·li·nga',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Pag-aaruga; pangangalaga.',
    ],
    'englishDefinitions': [
      'Nurturing care; looking after.',
    ],
    'examples': [
      'Ramdam ko ang pagkalinga ng aking ina sa tuwing ako\'y may sakit.',
    ],
    'examplesTranslation': [
      'I feel my mother\'s nurturing care whenever I\'m sick.',
    ],
    'synonyms': ['pag-aaruga', 'pangangalaga', 'pagmamalasakit', 'pag-aalaga'],
    'translations': {'english': 'nurturing care, looking after, tending, caring for'},
    'category': ['filipino values', 'caring', 'relationships'],
    'difficulty': 'medium',
  },
  
  'tapang': {
    'pronunciation': 'ta·pang',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Katapangan; lakas ng loob.',
    ],
    'englishDefinitions': [
      'Courage; bravery.',
    ],
    'examples': [
      'Ipinakita niya ang kanyang tapang nang harapin niya ang mga batikos.',
    ],
    'examplesTranslation': [
      'He showed his courage when he faced criticisms.',
    ],
    'synonyms': ['katapangan', 'lakas ng loob', 'kabayanihan', 'kagitingan'],
    'translations': {'english': 'courage, bravery, valor, boldness'},
    'category': ['filipino values', 'personal attributes', 'character traits'],
    'difficulty': 'easy',
  },
  
  'talino': {
    'pronunciation': 'ta·li·no',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Katalinuhan; karunungan.',
    ],
    'englishDefinitions': [
      'Intelligence; wisdom.',
    ],
    'examples': [
      'Ang talino niya ay nakita sa paraang siya ay nagsalita.',
    ],
    'examplesTranslation': [
      'His intelligence was seen in the way he spoke.',
    ],
    'synonyms': ['katalinuhan', 'karunungan', 'kaisipan', 'dunong'],
    'translations': {'english': 'intelligence, wisdom, intellect, brilliance'},
    'category': ['personal attributes', 'cognitive abilities', 'mental traits'],
    'difficulty': 'easy',
  },
  
  'kabutihang-loob': {
    'pronunciation': 'ka·bu·ti·hang-lo·ob',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Mabuting kalooban; kabaitan.',
    ],
    'englishDefinitions': [
      'Goodwill; benevolence.',
    ],
    'examples': [
      'Ang kabutihang-loob niya ay naramdaman ng komunidad.',
    ],
    'examplesTranslation': [
      'His goodwill was felt by the community.',
    ],
    'synonyms': ['mabuting kalooban', 'kabaitan', 'pagmamagandang-loob', 'kagandahang-loob'],
    'translations': {'english': 'goodwill, benevolence, kindness, good-heartedness'},
    'category': ['filipino values', 'personal attributes', 'virtues'],
    'difficulty': 'medium',
  },
  
  'pagkamalikhain': {
    'pronunciation': 'pag·ka·ma·lik·ha·in',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Pagkamabungang-isip; pagka-malikhain.',
    ],
    'englishDefinitions': [
      'Creativity; inventiveness.',
    ],
    'examples': [
      'Ang pagkamalikhain niya ay makikita sa kanyang mga obra.',
    ],
    'examplesTranslation': [
      'His creativity can be seen in his works.',
    ],
    'synonyms': ['pagkamabungang-isip', 'pagkamalikhain', 'inobasyon', 'pagkamaimbentor'],
    'translations': {'english': 'creativity, inventiveness, imagination, ingenuity'},
    'category': ['personal attributes', 'cognitive abilities', 'artistic traits'],
    'difficulty': 'medium',
  },
  
  'pagpupunyagi': {
    'pronunciation': 'pag·pu·pu·nya·gi',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Determinasyon; kasigasigan.',
    ],
    'englishDefinitions': [
      'Determination; striving.',
    ],
    'examples': [
      'Ang pagpupunyagi niya ang nagdala sa kanya sa tagumpay.',
    ],
    'examplesTranslation': [
      'His determination brought him to success.',
    ],
    'synonyms': ['determinasyon', 'kasigasigan', 'pagsisikap', 'pagtitiyaga'],
    'translations': {'english': 'determination, striving, perseverance, effort'},
    'category': ['filipino values', 'personal attributes', 'mental strength'],
    'difficulty': 'medium',
  },
  
  'dalamhati': {
    'pronunciation': 'da·lam·ha·ti',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Matinding kalungkutan; matinding pighati.',
    ],
    'englishDefinitions': [
      'Grief; deep sorrow.',
    ],
    'examples': [
      'Nabalot siya ng dalamhati nang mamatay ang kanyang ama.',
    ],
    'examplesTranslation': [
      'She was enveloped in grief when her father died.',
    ],
    'synonyms': ['kalungkutan', 'pighati', 'lumbay', 'hinagpis'],
    'translations': {'english': 'grief, deep sorrow, anguish, affliction'},
    'category': ['emotions', 'negative feelings', 'trauma responses'],
    'difficulty': 'medium',
  },
  
  'lungkot': {
    'pronunciation': 'lung·kot',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Kalungkutan; kapanglawan.',
    ],
    'englishDefinitions': [
      'Sadness; melancholy.',
    ],
    'examples': [
      'Naramdaman ko ang lungkot sa kanyang mga mata.',
    ],
    'examplesTranslation': [
      'I felt the sadness in his eyes.',
    ],
    'synonyms': ['kalungkutan', 'kapanglawan', 'pighati', 'dalamhati'],
    'translations': {'english': 'sadness, melancholy, sorrow, unhappiness'},
    'category': ['emotions', 'negative feelings', 'mood states'],
    'difficulty': 'easy',
  },
  
  'ligaya': {
    'pronunciation': 'li·ga·ya',
    'partOfSpeech': 'pangngalan', // noun
    'tagalogDefinitions': [
      'Kaligayahan; tuwa.',
    ],
    'englishDefinitions': [
      'Joy; happiness.',
    ],
    'examples': [
      'Ang ligaya ay makikita sa kanyang ngiti.',
    ],
    'examplesTranslation': [
      'Joy can be seen in his smile.',
    ],
    'synonyms': ['kaligayahan', 'tuwa', 'saya', 'kasiyahan'],
    'translations': {'english': 'joy, happiness, delight, bliss'},
    'category': ['emotions', 'positive feelings', 'mood states'],
    'difficulty': 'easy',
  },
    'pag-ibig': {
      'pronunciation': 'pag·i·big',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Pagmamahal; pagtingin.',
      ],
      'englishDefinitions': [
        'Love; affection.',
      ],
      'examples': [
        'Ang pag-ibig ay nagbibigay ng lakas sa ating buhay.',
      ],
      'examplesTranslation': [
        'Love gives strength to our lives.',
      ],
      'synonyms': ['pagmamahal', 'pagtingin', 'pagsinta'],
      'translations': {'english': 'love, affection, fondness'},
      'category': ['emotions', 'relationships', 'feelings'],
      'difficulty': 'easy',
    },
    'galit': {
      'pronunciation': 'ga·lit',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Poot; yamot.',
      ],
      'englishDefinitions': [
        'Anger; wrath.',
      ],
      'examples': [
        'Kailangan nating kontrolin ang ating galit.',
      ],
      'examplesTranslation': [
        'We need to control our anger.',
      ],
      'synonyms': ['poot', 'yamot', 'init ng ulo'],
      'translations': {'english': 'anger, wrath, rage'},
      'category': ['emotions', 'feelings', 'behavior'],
      'difficulty': 'easy',
    },
    'hinagpis': {
      'pronunciation': 'hi·nag·pis',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Matinding kalungkutan; labis na pighati.',
      ],
      'englishDefinitions': [
        'Intense grief; anguish.',
      ],
      'examples': [
        'Ang hinagpis niya ay matagal nawala pagkatapos ng trahedya.',
      ],
      'examplesTranslation': [
        'Her anguish took long to disappear after the tragedy.',
      ],
      'synonyms': ['matinding kalungkutan', 'labis na pighati', 'dalamhati'],
      'translations': {'english': 'intense grief, anguish, deep sorrow'},
      'category': ['emotions', 'experiences', 'loss'],
      'difficulty': 'hard',
    },
    'lumbay': {
      'pronunciation': 'lum·bay',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Malalim na kalungkutan; panglaw.',
      ],
      'englishDefinitions': [
        'Melancholy; deep sadness.',
      ],
      'examples': [
        'May lumbay sa kanyang mga mata nang siya\'y umalis.',
      ],
      'examplesTranslation': [
        'There was melancholy in his eyes when he left.',
      ],
      'synonyms': ['malalim na kalungkutan', 'panglaw', 'hinagpis'],
      'translations': {'english': 'melancholy, deep sadness, woe'},
      'category': ['emotions', 'feelings', 'experiences'],
      'difficulty': 'medium',
    },
    'tuwa': {
      'pronunciation': 'tu·wa',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Galak; kasiyahan.',
      ],
      'englishDefinitions': [
        'Gladness; delight.',
      ],
      'examples': [
        'Nakita ko ang tuwa sa kanyang mukha nang matanggap niya ang regalo.',
      ],
      'examplesTranslation': [
        'I saw the gladness on her face when she received the gift.',
      ],
      'synonyms': ['galak', 'kasiyahan', 'ligaya'],
      'translations': {'english': 'gladness, delight, joy'},
      'category': ['emotions', 'feelings', 'experiences'],
      'difficulty': 'easy',
    },
    'siphayo': {
      'pronunciation': 'si·pha·yo',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Pighati; malalim na kalungkutan.',
      ],
      'englishDefinitions': [
        'Grief; deep emotional pain.',
      ],
      'examples': [
        'Ang siphayo ng mga naulila ay ramdam ng buong komunidad.',
      ],
      'examplesTranslation': [
        'The grief of the orphaned is felt by the whole community.',
      ],
      'synonyms': ['pighati', 'malalim na kalungkutan', 'dalamhati'],
      'translations': {'english': 'grief, deep emotional pain, suffering'},
      'category': ['emotions', 'experiences', 'loss'],
      'difficulty': 'hard',
    },
    'pananabik': {
      'pronunciation': 'pa·na·na·bik',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Kasabikan; pag-aasam.',
      ],
      'englishDefinitions': [
        'Eagerness; anticipation.',
      ],
      'examples': [
        'May pananabik siyang naghintay sa pagdating ng kanyang kapatid.',
      ],
      'examplesTranslation': [
        'She waited with eagerness for her sibling\'s arrival.',
      ],
      'synonyms': ['kasabikan', 'pag-aasam', 'pagkasabik'],
      'translations': {'english': 'eagerness, anticipation, yearning'},
      'category': ['emotions', 'feelings', 'expectations'],
      'difficulty': 'medium',
    },
    'panibugho': {
      'pronunciation': 'pa·ni·bug·ho',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Inggit; pagseselos.',
      ],
      'englishDefinitions': [
        'Jealousy; envy.',
      ],
      'examples': [
        'Ang panibugho ay nakakasira ng relasyon.',
      ],
      'examplesTranslation': [
        'Jealousy destroys relationships.',
      ],
      'synonyms': ['inggit', 'pagseselos', 'selos'],
      'translations': {'english': 'jealousy, envy, possessiveness'},
      'category': ['emotions', 'feelings', 'relationships'],
      'difficulty': 'medium',
    },
    'pagkamuhi': {
      'pronunciation': 'pag·ka·mu·hi',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Poot; pagsusuka.',
      ],
      'englishDefinitions': [
        'Hatred; aversion.',
      ],
      'examples': [
        'Ang pagkamuhi ay nagdudulot ng sakit sa sarili.',
      ],
      'examplesTranslation': [
        'Hatred causes pain to oneself.',
      ],
      'synonyms': ['poot', 'pagsusuka', 'galit'],
      'translations': {'english': 'hatred, aversion, loathing'},
      'category': ['emotions', 'feelings', 'behavior'],
      'difficulty': 'medium',
    },
    'galak': {
      'pronunciation': 'ga·lak',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Lubos na kaligayahan; kasiyahan.',
      ],
      'englishDefinitions': [
        'Exultation; joy.',
      ],
      'examples': [
        'Napuno ng galak ang kanyang puso nang makita niya ang kanyang anak.',
      ],
      'examplesTranslation': [
        'Her heart was filled with joy when she saw her child.',
      ],
      'synonyms': ['lubos na kaligayahan', 'kasiyahan', 'tuwa'],
      'translations': {'english': 'exultation, joy, elation'},
      'category': ['emotions', 'feelings', 'experiences'],
      'difficulty': 'medium',
    },
    'pagkasabik': {
      'pronunciation': 'pag·ka·sa·bik',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Matinding pananabik; paghahangad.',
      ],
      'englishDefinitions': [
        'Yearning; longing.',
      ],
      'examples': [
        'May pagkasabik siyang hinihintay ang kanyang pagbabalik.',
      ],
      'examplesTranslation': [
        'He waited for her return with yearning.',
      ],
      'synonyms': ['matinding pananabik', 'paghahangad', 'sabik'],
      'translations': {'english': 'yearning, longing, craving'},
      'category': ['emotions', 'feelings', 'desires'],
      'difficulty': 'medium',
    },
    
    // Continuing with more words (adding the remaining words similarly)
    'pagkagulat': {
      'pronunciation': 'pag·ka·gu·lat',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Gulat; pagkamangha.',
      ],
      'englishDefinitions': [
        'Surprise; astonishment.',
      ],
      'examples': [
        'Hindi niya maitatago ang pagkagulat nang marinig ang balita.',
      ],
      'examplesTranslation': [
        'He couldn\'t hide his surprise when he heard the news.',
      ],
      'synonyms': ['gulat', 'pagkamangha', 'pagtataka'],
      'translations': {'english': 'surprise, astonishment, shock'},
      'category': ['emotions', 'reactions', 'experiences'],
      'difficulty': 'medium',
    },
    'pagkatakot': {
      'pronunciation': 'pag·ka·ta·kot',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Takot; pangamba.',
      ],
      'englishDefinitions': [
        'Fear; dread.',
      ],
      'examples': [
        'Ang pagkatakot niya sa dilim ay nagsimula noong siya ay bata pa.',
      ],
      'examplesTranslation': [
        'His fear of darkness started when he was still a child.',
      ],
      'synonyms': ['takot', 'pangamba', 'sindak'],
      'translations': {'english': 'fear, dread, fright'},
      'category': ['emotions', 'feelings', 'psychological states'],
      'difficulty': 'medium',
    },
    'pagsisisi': {
      'pronunciation': 'pag·si·si·si',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Panghihinayang; pagdaramdam.',
      ],
      'englishDefinitions': [
        'Regret; remorse.',
      ],
      'examples': [
        'Naramdaman niya ang pagsisisi nang huli na ang lahat.',
      ],
      'examplesTranslation': [
        'He felt regret when it was already too late.',
      ],
      'synonyms': ['panghihinayang', 'pagdaramdam', 'paghinagpis'],
      'translations': {'english': 'regret, remorse, repentance'},
      'category': ['emotions', 'feelings', 'moral experiences'],
      'difficulty': 'medium',
    },
    'pagkabahala': {
      'pronunciation': 'pag·ka·ba·ha·la',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Pag-aalala; pagkabagabag.',
      ],
      'englishDefinitions': [
        'Worry; concern.',
      ],
      'examples': [
        'Ang pagkabahala para sa kanyang kalusugan ay makatuwiran.',
      ],
      'examplesTranslation': [
        'The concern for his health is reasonable.',
      ],
      'synonyms': ['pag-aalala', 'pagkabagabag', 'pagkakaba'],
      'translations': {'english': 'worry, concern, anxiety'},
      'category': ['emotions', 'mental states', 'care'],
      'difficulty': 'medium',
    },
    'takot': {
      'pronunciation': 'ta·kot',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Pangamba; sindak.',
      ],
      'englishDefinitions': [
        'Fear; fright.',
      ],
      'examples': [
        'Ang takot ay natural na reaksyon sa panganib.',
      ],
      'examplesTranslation': [
        'Fear is a natural reaction to danger.',
      ],
      'synonyms': ['pangamba', 'sindak', 'pagkatakot'],
      'translations': {'english': 'fear, fright, dread'},
      'category': ['emotions', 'feelings', 'psychological responses'],
      'difficulty': 'easy',
    },
    'pagkabalisa': {
      'pronunciation': 'pag·ka·ba·li·sa',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Pagkaligalig; pagkakaba.',
      ],
      'englishDefinitions': [
        'Anxiety; nervousness.',
      ],
      'examples': [
        'Ang pagkabalisa niya ay nakita sa kanyang mga kilos.',
      ],
      'examplesTranslation': [
        'Her anxiety was seen in her actions.',
      ],
      'synonyms': ['pagkaligalig', 'pagkakaba', 'pagkabalisa'],
      'translations': {'english': 'anxiety, nervousness, restlessness'},
      'category': ['emotions', 'mental states', 'psychological states'],
      'difficulty': 'medium',
    },
    'kasiyahan': {
      'pronunciation': 'ka·si·ya·han',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Kaluguran; kasapatan.',
      ],
      'englishDefinitions': [
        'Satisfaction; contentment.',
      ],
      'examples': [
        'Natagpuan niya ang kasiyahan sa simpleng pamumuhay.',
      ],
      'examplesTranslation': [
        'He found contentment in simple living.',
      ],
      'synonyms': ['kaluguran', 'kasapatan', 'kontento'],
      'translations': {'english': 'satisfaction, contentment, fulfillment'},
      'category': ['emotions', 'mental states', 'well-being'],
      'difficulty': 'medium',
    },
    'pagkadismaya': {
      'pronunciation': 'pag·ka·dis·ma·ya',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Kabiguan; pagkasira ng pangarap.',
      ],
      'englishDefinitions': [
        'Disappointment; disillusionment.',
      ],
      'examples': [
        'Hindi niya maitatago ang pagkadismaya sa resulta.',
      ],
      'examplesTranslation': [
        'He couldn\'t hide his disappointment in the result.',
      ],
      'synonyms': ['kabiguan', 'pagkasira ng pangarap', 'pagkabigo'],
      'translations': {'english': 'disappointment, disillusionment, letdown'},
      'category': ['emotions', 'experiences', 'reactions'],
      'difficulty': 'medium',
    },
    'pagkainip': {
      'pronunciation': 'pag·ka·i·nip',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Kawalan ng pasensya; pagkabalisang-isip.',
      ],
      'englishDefinitions': [
        'Impatience; restlessness.',
      ],
      'examples': [
        'Ang pagkainip niya ay maliwanag na nakikita.',
      ],
      'examplesTranslation': [
        'His impatience was clearly visible.',
      ],
      'synonyms': ['kawalan ng pasensya', 'pagkabalisang-isip', 'kawalan ng tiyaga'],
      'translations': {'english': 'impatience, restlessness, fidgetiness'},
      'category': ['emotions', 'behaviors', 'attitudes'],
      'difficulty': 'medium',
    },
    'pagkagusto': {
      'pronunciation': 'pag·ka·gus·to',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Hilig; pagtangkilik.',
      ],
      'englishDefinitions': [
        'Liking; fondness.',
      ],
      'examples': [
        'Ang pagkagusto niya sa pagkain ay makikita sa kanyang ekspresyon.',
      ],
      'examplesTranslation': [
        'His liking for the food was visible in his expression.',
      ],
      'synonyms': ['hilig', 'pagtangkilik', 'pagkahilig'],
      'translations': {'english': 'liking, fondness, preference'},
      'category': ['emotions', 'preferences', 'tastes'],
      'difficulty': 'medium',
    },
    'pagkasuklam': {
      'pronunciation': 'pag·ka·suk·lam',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Pagkarimarim; pagkamuhi.',
      ],
      'englishDefinitions': [
        'Disgust; repugnance.',
      ],
      'examples': [
        'Hindi niya maitatago ang pagkasuklam sa nakita niya.',
      ],
      'examplesTranslation': [
        'He couldn\'t hide his disgust at what he saw.',
      ],
      'synonyms': ['pagkarimarim', 'pagkamuhi', 'pagkadiri'],
      'translations': {'english': 'disgust, repugnance, revulsion'},
      'category': ['emotions', 'reactions', 'feelings'],
      'difficulty': 'medium',
    },
    'pagkalungkot': {
      'pronunciation': 'pag·ka·lung·kot',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Kalungkutan; pighati.',
      ],
      'englishDefinitions': [
        'Sadness; sorrow.',
      ],
      'examples': [
        'Ang pagkalungkot niya ay unti-unting nawala.',
      ],
      'examplesTranslation': [
        'His sadness gradually disappeared.',
      ],
      'synonyms': ['kalungkutan', 'pighati', 'lungkot'],
      'translations': {'english': 'sadness, sorrow, grief'},
      'category': ['emotions', 'feelings', 'mental states'],
      'difficulty': 'medium',
    },
    'pagkagalit': {
      'pronunciation': 'pag·ka·ga·lit',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Poot; yamot.',
      ],
      'englishDefinitions': [
        'Anger; wrath.',
      ],
      'examples': [
        'Ang pagkagalit niya ay nakita sa kanyang mga mata.',
      ],
      'examplesTranslation': [
        'His anger was seen in his eyes.',
      ],
      'synonyms': ['poot', 'yamot', 'galit'],
      'translations': {'english': 'anger, wrath, fury'},
      'category': ['emotions', 'feelings', 'reactions'],
      'difficulty': 'medium',
    },
    'pagkahiya': {
      'pronunciation': 'pag·ka·hi·ya',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Kahihiyan; pagkapahiya.',
      ],
      'englishDefinitions': [
        'Shame; embarrassment.',
      ],
      'examples': [
        'Ang pagkahiya niya ay nakita sa pamumula ng kanyang mukha.',
      ],
      'examplesTranslation': [
        'His shame was seen in the reddening of his face.',
      ],
      'synonyms': ['kahihiyan', 'pagkapahiya', 'hiya'],
      'translations': {'english': 'shame, embarrassment, humiliation'},
      'category': ['emotions', 'social feelings', 'reactions'],
      'difficulty': 'medium',
    },
    'pagkapagod': {
      'pronunciation': 'pag·ka·pa·god',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Kapaguran; pagod.',
      ],
      'englishDefinitions': [
        'Tiredness; fatigue.',
      ],
      'examples': [
        'Ang pagkapagod niya ay maliwanag na nakikita.',
      ],
      'examplesTranslation': [
        'His tiredness was clearly visible.',
      ],
      'synonyms': ['kapaguran', 'pagod', 'kapagudan'],
      'translations': {'english': 'tiredness, fatigue, exhaustion'},
      'category': ['physical states', 'feelings', 'conditions'],
      'difficulty': 'easy',
    },
    'kalayaan': {
      'pronunciation': 'ka·la·ya·an',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Pagiging malaya; kasarinlan.',
      ],
      'englishDefinitions': [
        'Freedom; liberty.',
      ],
      'examples': [
        'Pinaglaban nila ang kalayaan ng bansa.',
      ],
      'examplesTranslation': [
        'They fought for the freedom of the country.',
      ],
      'synonyms': ['pagiging malaya', 'kasarinlan', 'independensya'],
      'translations': {'english': 'freedom, liberty, independence'},
      'category': ['abstract concepts', 'social values', 'politics'],
      'difficulty': 'medium',
    },
    'katotohanan': {
      'pronunciation': 'ka·to·to·ha·nan',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Katotohanan; katunayan.',
      ],
      'englishDefinitions': [
        'Truth; fact.',
      ],
      'examples': [
        'Ang katotohanan ay hindi maitatago.',
      ],
      'examplesTranslation': [
        'The truth cannot be hidden.',
      ],
      'synonyms': ['katotohanan', 'katunayan', 'totoo'],
      'translations': {'english': 'truth, fact, reality'},
      'category': ['abstract concepts', 'philosophy', 'knowledge'],
      'difficulty': 'medium',
    },
    'katarungan': {
      'pronunciation': 'ka·ta·run·gan',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Katarungan; katarungang panlipunan.',
      ],
      'englishDefinitions': [
        'Justice; fairness.',
      ],
      'examples': [
        'Ang katarungan ay dapat ipaglaban.',
      ],
      'examplesTranslation': [
        'Justice should be fought for.',
      ],
      'synonyms': ['katarungan', 'katarungang panlipunan', 'justisya'],
      'translations': {'english': 'justice, fairness, equity'},
      'category': ['abstract concepts', 'social values', 'ethics'],
      'difficulty': 'medium',
    },
    'alingawngaw': {
      'pronunciation': 'a·li·ngaw·ngaw',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Hugong; paglalakbay ng tunog.',
      ],
      'englishDefinitions': [
        'Echo; reverberation; resonance.',
      ],
      'examples': [
        'Narinig ko ang alingawngaw ng kanyang tinig sa kuweba.',
      ],
      'examplesTranslation': [
        'I heard the echo of his voice in the cave.',
      ],
      'synonyms': ['hugong', 'paglalakbay ng tunog', 'galoygoy'],
      'translations': {'english': 'echo, reverberation, resonance'},
      'category': ['sounds', 'physical phenomena', 'acoustics'],
      'difficulty': 'hard',
    },
    'aninag': {
      'pronunciation': 'a·ni·nag',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Mahinang liwanag; anino; bahid ng liwanag.',
      ],
      'englishDefinitions': [
        'Faint glimmer; silhouette; glimpse.',
      ],
      'examples': [
        'Aninag ko ang liwanag mula sa malayo.',
      ],
      'examplesTranslation': [
        'I glimpsed the light from afar.',
      ],
      'synonyms': ['mahinang liwanag', 'anino', 'bahid ng liwanag'],
      'translations': {'english': 'faint glimmer, silhouette, glimpse'},
      'category': ['perception', 'visual phenomena', 'light'],
      'difficulty': 'medium',
    },
    'dalisay': {
      'pronunciation': 'da·li·say',
      'partOfSpeech': 'pang-uri', // adjective
      'tagalogDefinitions': [
        'Malinis; walang bahid; wagas.',
      ],
      'englishDefinitions': [
        'Pure; pristine; unsullied.',
      ],
      'examples': [
        'Dalisay ang kanyang hangarin sa pagtulong.',
      ],
      'examplesTranslation': [
        'Pure is his intention to help.',
      ],
      'synonyms': ['malinis', 'walang bahid', 'wagas'],
      'translations': {'english': 'pure, pristine, unsullied'},
      'category': ['qualities', 'character traits', 'moral concepts'],
      'difficulty': 'medium',
    },
    'guniguni': {
      'pronunciation': 'gu·ni·gu·ni',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Imahinasyon; pantasya; kathang-isip.',
      ],
      'englishDefinitions': [
        'Imagination; illusion; fantasy.',
      ],
      'examples': [
        'Minsan, ang takot ay gawa lamang ng guniguni.',
      ],
      'examplesTranslation': [
        'Sometimes, fear is just made by imagination.',
      ],
      'synonyms': ['imahinasyon', 'pantasya', 'kathang-isip'],
      'translations': {'english': 'imagination, illusion, fantasy'},
      'category': ['mental faculties', 'cognition', 'creativity'],
      'difficulty': 'medium',
    },
    'kalinaw': {
      'pronunciation': 'ka·li·naw',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Kapayapaan; katahimikan; kapanatagan.',
      ],
      'englishDefinitions': [
        'Peace; tranquility; serenity.',
      ],
      'examples': [
        'Hinahanap niya ang kalinaw ng kanyang isipan.',
      ],
      'examplesTranslation': [
        'He seeks peace of mind.',
      ],
      'synonyms': ['kapayapaan', 'katahimikan', 'kapanatagan'],
      'translations': {'english': 'peace, tranquility, serenity'},
      'category': ['mental states', 'emotional states', 'well-being'],
      'difficulty': 'medium',
    },
    'lihim': {
      'pronunciation': 'li·him',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Sekreto; palihim; lingid sa kaalaman.',
      ],
      'englishDefinitions': [
        'Secret; mystery; confidential matter.',
      ],
      'examples': [
        'May lihim siyang tinatago.',
      ],
      'examplesTranslation': [
        'He is keeping a secret.',
      ],
      'synonyms': ['sekreto', 'palihim', 'lingid sa kaalaman'],
      'translations': {'english': 'secret, mystery, confidential matter'},
      'category': ['communication', 'privacy', 'information'],
      'difficulty': 'easy',
    },
    'pahimakas': {
      'pronunciation': 'pa·hi·ma·kas',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Huling paalam; pamamaalam; huling pagkikita.',
      ],
      'englishDefinitions': [
        'Last farewell; final goodbye.',
      ],
      'examples': [
        'Ang kanyang pahimakas ay puno ng luha.',
      ],
      'examplesTranslation': [
        'His farewell was filled with tears.',
      ],
      'synonyms': ['huling paalam', 'pamamaalam', 'huling pagkikita'],
      'translations': {'english': 'last farewell, final goodbye, parting words'},
      'category': ['rituals', 'partings', 'social customs'],
      'difficulty': 'hard',
    },
    'salinlahi': {
      'pronunciation': 'sa·lin·la·hi',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Henerasyon; lahi; angkan.',
      ],
      'englishDefinitions': [
        'Generation; lineage; descendants.',
      ],
      'examples': [
        'Ang salinlahi ngayon ay teknolohikal.',
      ],
      'examplesTranslation': [
        'The current generation is technological.',
      ],
      'synonyms': ['henerasyon', 'lahi', 'angkan'],
      'translations': {'english': 'generation, lineage, descendants'},
      'category': ['family', 'genealogy', 'time periods'],
      'difficulty': 'medium',
    },
    'kalikasan': {
      'pronunciation': 'ka·li·ka·san',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Ang natural na mundo o kapaligiran; ang mga bagay na hindi ginawa ng tao.',
      ],
      'englishDefinitions': [
        'Nature; environment; the natural world.',
      ],
      'examples': [
        'Dapat nating alagaan ang kalikasan para sa susunod na henerasyon.',
      ],
      'examplesTranslation': [
        'We should take care of nature for the next generation.',
      ],
      'synonyms': ['kapaligiran', 'mundo', 'natural na mundo'],
      'translations': {'english': 'nature, environment, natural world'},
      'category': ['environment', 'science', 'natural world'],
      'difficulty': 'medium',
    },
    
    'adobo': {
      'pronunciation': 'a·do·bo',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Tradisyonal na lutuing Filipino na niluluto sa toyo, suka, at pampalasa.',
      ],
      'englishDefinitions': [
        'Traditional Filipino dish cooked with soy sauce, vinegar, and spices.',
      ],
      'examples': [
        'Ang adobo ang pambansang ulam ng Pilipinas.',
      ],
      'examplesTranslation': [
        'Adobo is the national dish of the Philippines.',
      ],
      'synonyms': ['ulam', 'putahe', 'lutong Filipino'],
      'translations': {'english': 'adobo, traditional Filipino dish'},
      'category': ['food', 'cuisine', 'cultural heritage'],
      'difficulty': 'easy',
    },
    
    'kompyuter': {
      'pronunciation': 'kom·pyu·ter',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Elektronikong makina na gumagawa ng mabilisang kalkulasyon at nagpoproseso ng impormasyon.',
      ],
      'englishDefinitions': [
        'Electronic machine that performs rapid calculations and processes information.',
      ],
      'examples': [
        'Gumamit siya ng kompyuter para gumawa ng kanyang proyekto.',
      ],
      'examplesTranslation': [
        'He used a computer to create his project.',
      ],
      'synonyms': ['laptop', 'desktop', 'elektronikong kasangkapan'],
      'translations': {'english': 'computer'},
      'category': ['technology', 'gadgets', 'modern tools'],
      'difficulty': 'easy',
    },
    
    'kabundukan': {
      'pronunciation': 'ka·bun·du·kan',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Malawak na lugar na may maraming bundok; hanay ng mga bundok.',
      ],
      'englishDefinitions': [
        'Mountain range; mountainous area.',
      ],
      'examples': [
        'Ang kabundukan ng Sierra Madre ay nagsisilbing natural na hadlang sa bagyo.',
      ],
      'examplesTranslation': [
        'The Sierra Madre mountain range serves as a natural barrier against typhoons.',
      ],
      'synonyms': ['hanay ng bundok', 'bulubundukin', 'mga bundok'],
      'translations': {'english': 'mountain range, mountainous region'},
      'category': ['geography', 'landforms', 'natural features'],
      'difficulty': 'medium',
    },
    
    'magtanim': {
      'pronunciation': 'mag·ta·nim',
      'partOfSpeech': 'pandiwa', // verb
      'tagalogDefinitions': [
        'Ang gumawa ng paglalagay ng buto, halaman, o punla sa lupa para patubuhin.',
      ],
      'englishDefinitions': [
        'To plant; to sow seeds or seedlings.',
      ],
      'examples': [
        'Magtanim tayo ng gulay sa ating bakuran para may pagkain tayo.',
      ],
      'examplesTranslation': [
        'Let\'s plant vegetables in our yard so we have food.',
      ],
      'synonyms': ['magsabog', 'maglagay', 'maglapat'],
      'translations': {'english': 'to plant, to sow, to cultivate'},
      'category': ['agriculture', 'gardening', 'activities'],
      'difficulty': 'easy',
    },
    
    'maganda': {
      'pronunciation': 'ma·gan·da',
      'partOfSpeech': 'pang-uri', // adjective
      'tagalogDefinitions': [
        'May kaaya-ayang anyo o katangian; nakakabighani.',
      ],
      'englishDefinitions': [
        'Beautiful; pretty; attractive.',
      ],
      'examples': [
        'Maganda ang pagtanggap nila sa aming pagbisita.',
      ],
      'examplesTranslation': [
        'Their reception to our visit was beautiful.',
      ],
      'synonyms': ['marikit', 'makisig', 'makinis', 'kaaya-aya'],
      'translations': {'english': 'beautiful, pretty, attractive'},
      'category': ['descriptions', 'appearances', 'qualities'],
      'difficulty': 'easy',
    },
    
    'sa ilalim ng': {
      'pronunciation': 'sa i·la·lim ng',
      'partOfSpeech': 'parirala', // phrase
      'tagalogDefinitions': [
        'Nasa ibabang bahagi ng isang bagay; nasa posisyong mas mababa kaysa sa iba.',
      ],
      'englishDefinitions': [
        'Under; beneath; below something.',
      ],
      'examples': [
        'Nagtago siya sa ilalim ng mesa noong may lindol.',
      ],
      'examplesTranslation': [
        'He hid under the table during the earthquake.',
      ],
      'synonyms': ['nasa ibaba ng', 'sa silong ng', 'sa salirlir ng'],
      'translations': {'english': 'under, beneath, below'},
      'category': ['spatial relationships', 'positions', 'directions'],
      'difficulty': 'easy',
    },
    
    'kagamitan': {
      'pronunciation': 'ka·ga·mi·tan',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Mga kasangkapan o bagay na ginagamit para sa partikular na gawain o layunin.',
      ],
      'englishDefinitions': [
        'Tools; equipment; things used for a particular task or purpose.',
      ],
      'examples': [
        'Kailangan nating bumili ng bagong kagamitan para sa kusina.',
      ],
      'examplesTranslation': [
        'We need to buy new equipment for the kitchen.',
      ],
      'synonyms': ['kasangkapan', 'kasangkapan', 'gamit', 'tool'],
      'translations': {'english': 'equipment, tools, implements'},
      'category': ['household items', 'tools', 'practical objects'],
      'difficulty': 'medium',
    },
    
    'umaga': {
      'pronunciation': 'u·ma·ga',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Panahon ng araw mula pagsikat ng araw hanggang tanghali.',
      ],
      'englishDefinitions': [
        'Morning; time of day from sunrise until noon.',
      ],
      'examples': [
        'Maganda ang simula ng aking umaga dahil nakita kita.',
      ],
      'examplesTranslation': [
        'My morning started beautifully because I saw you.',
      ],
      'synonyms': ['bukang-liwayway', 'maagang bahagi ng araw'],
      'translations': {'english': 'morning, early part of the day'},
      'category': ['time', 'parts of day', 'greetings'],
      'difficulty': 'easy',
    },
    
    'magtrabaho': {
      'pronunciation': 'mag·tra·ba·ho',
      'partOfSpeech': 'pandiwa', // verb
      'tagalogDefinitions': [
        'Gumawa ng gawain para kumita o makapagbigay ng serbisyo.',
      ],
      'englishDefinitions': [
        'To work; to labor; to do tasks for income or service.',
      ],
      'examples': [
        'Kailangan kong magtrabaho para masuportahan ang aking pamilya.',
      ],
      'examplesTranslation': [
        'I need to work to support my family.',
      ],
      'synonyms': ['maghanapbuhay', 'magpagal', 'magsumikap'],
      'translations': {'english': 'to work, to labor, to toil'},
      'category': ['employment', 'activities', 'daily life'],
      'difficulty': 'easy',
    },
    
    'kasal': {
      'pronunciation': 'ka·sal',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Seremonya o ritwal ng pag-iisang dibdib ng dalawang tao; pagkakaisa sa batas.',
      ],
      'englishDefinitions': [
        'Wedding; marriage; matrimony.',
      ],
      'examples': [
        'Gaganapin ang kasal nila sa susunod na buwan.',
      ],
      'examplesTranslation': [
        'Their wedding will take place next month.',
      ],
      'synonyms': ['pag-iisang dibdib', 'kasalan', 'pagpapakasal'],
      'translations': {'english': 'wedding, marriage, matrimony'},
      'category': ['life events', 'celebrations', 'family'],
      'difficulty': 'easy',
    },
    
    'nakakagulat': {
      'pronunciation': 'na·ka·ka·gu·lat',
      'partOfSpeech': 'pang-uri', // adjective
      'tagalogDefinitions': [
        'Nakapagdudulot ng gulat o pagkamangha; hindi inaasahan.',
      ],
      'englishDefinitions': [
        'Surprising; astonishing; unexpected.',
      ],
      'examples': [
        'Nakakagulat ang resulta ng eksamen niya.',
      ],
      'examplesTranslation': [
        'His exam result was surprising.',
      ],
      'synonyms': ['nakakamangha', 'nakakasorpresa', 'nakakabilib'],
      'translations': {'english': 'surprising, shocking, astonishing'},
      'category': ['reactions', 'descriptions', 'experiences'],
      'difficulty': 'medium',
    },
    
    'paaralan': {
      'pronunciation': 'pa·a·ra·lan',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Institusyon o gusali kung saan nagtuturo at nag-aaral ang mga tao.',
      ],
      'englishDefinitions': [
        'School; educational institution; place of learning.',
      ],
      'examples': [
        'Ang paaralan ay nagsara dahil sa baha.',
      ],
      'examplesTranslation': [
        'The school closed due to flooding.',
      ],
      'synonyms': ['eskwelahan', 'institusyon ng edukasyon', 'pamantasan'],
      'translations': {'english': 'school, educational institution'},
      'category': ['education', 'places', 'institutions'],
      'difficulty': 'easy',
    },
    
    'paalam': {
      'pronunciation': 'pa·a·lam',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Pagbibigay-alam ng pag-alis; pagbabati bago umalis.',
      ],
      'englishDefinitions': [
        'Farewell; goodbye; permission to leave.',
      ],
      'examples': [
        'Nagpaalam siya bago umalis ng bahay.',
      ],
      'examplesTranslation': [
        'He said goodbye before leaving the house.',
      ],
      'synonyms': ['adios', 'babay', 'hanggang sa muli'],
      'translations': {'english': 'farewell, goodbye, permission'},
      'category': ['greetings', 'social expressions', 'departures'],
      'difficulty': 'easy',
    },
    
    'barya': {
      'pronunciation': 'bar·ya',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Maliliit na halaga ng pera; salaping metal.',
      ],
      'englishDefinitions': [
        'Coins; small denominations of money; loose change.',
      ],
      'examples': [
        'Nagipon siya ng barya sa kanyang alkansiya.',
      ],
      'examplesTranslation': [
        'He saved coins in his piggy bank.',
      ],
      'synonyms': ['sinsilyo', 'sentimo', 'metal na pera'],
      'translations': {'english': 'coins, loose change, small money'},
      'category': ['finances', 'everyday objects', 'currency'],
      'difficulty': 'easy',
    },
    
    'salamin': {
      'pronunciation': 'sa·la·min',
      'partOfSpeech': 'pangngalan', // noun
      'tagalogDefinitions': [
        'Patag at makinis na bagay na nakapagpapakita ng anino o repleksyon.',
      ],
      'englishDefinitions': [
        'Mirror; glass; eyeglasses.',
      ],
      'examples': [
        'Tumingin siya sa salamin para ayusin ang kanyang buhok.',
      ],
      'examplesTranslation': [
        'She looked in the mirror to fix her hair.',
      ],
      'synonyms': ['ispejo', 'repleksyon', 'antipara'],
      'translations': {'english': 'mirror, glass, eyeglasses'},
      'category': ['household items', 'everyday objects', 'vision aids'],
      'difficulty': 'easy',
    },
    
    'magluto': {
      'pronunciation': 'mag·lu·to',
      'partOfSpeech': 'pandiwa', // verb
      'tagalogDefinitions': [
        'Maghanda ng pagkain sa pamamagitan ng init, pagsasama-sama ng mga sangkap, atbp.',
      ],
      'englishDefinitions': [
        'To cook; to prepare food using heat, mixing ingredients, etc.',
      ],
      'examples': [
        'Magluto ka ng pancit para sa handaan.',
      ],
      'examplesTranslation': [
        'Cook pancit for the party.',
      ],
      'synonyms': ['magsaing', 'maglaga', 'maghanda ng pagkain'],
      'translations': {'english': 'to cook, to prepare food'},
      'category': ['cooking', 'household activities', 'food preparation'],
      'difficulty': 'easy',
    },
    
    'malungkot': {
      'pronunciation': 'ma·lung·kot',
      'partOfSpeech': 'pang-uri', // adjective
      'tagalogDefinitions': [
        'May damdamin ng kalungkutan; hindi masaya; nalulumbay.',
      ],
      'englishDefinitions': [
        'Sad; melancholy; unhappy.',
      ],
      'examples': [
        'Malungkot siya nang malaman niyang umalis na ang kanyang kaibigan.',
      ],
      'examplesTranslation': [
        'He was sad when he learned that his friend had already left.',
      ],
      'synonyms': ['nalulumbay', 'mapanglaw', 'mahapis'],
      'translations': {'english': 'sad, melancholy, unhappy'},
      'category': ['emotions', 'mental states', 'descriptions'],
      'difficulty': 'easy',
    },
  };

  /// Get a list of words filtered by part of speech
  static List<String> getWordsByPartOfSpeech(String partOfSpeech) {
    return words.keys.where((word) {
      return words[word]!['partOfSpeech'] == partOfSpeech;
    }).toList();
  }

  /// Get a list of words filtered by difficulty
  static List<String> getWordsByDifficulty(String difficulty) {
    return words.keys.where((word) {
      return words[word]!['difficulty'] == difficulty;
    }).toList();
  }

  /// Get all available parts of speech
  static List<String> getAllPartsOfSpeech() {
    Set<String> parts = {};
    for (var word in words.keys) {
      if (words[word]!.containsKey('partOfSpeech')) {
        parts.add(words[word]!['partOfSpeech']);
      }
    }
    return parts.toList()..sort();
  }

  /// Map of Filipino grammar parts of speech to their descriptions
  static final Map<String, String> partsOfSpeechDescriptions = {
    'pangngalan': 'Noun - a word that identifies a person, place, thing, or idea',
    'panghalip': 'Pronoun - a word that substitutes for a noun or noun phrase',
    'pandiwa': 'Verb - a word used to describe an action, state, or occurrence',
    'pang-uri': 'Adjective - a word that describes a noun or pronoun',
    'pang-abay': 'Adverb - a word that modifies a verb, adjective, or other adverb',
    'pang-ukol': 'Preposition - a word that shows the relationship between a noun and another word',
    'pangatnig': 'Conjunction - a word that connects words, phrases, or clauses',
    'pandamdam': 'Interjection - a word that expresses sudden emotion',
    'parirala': 'Phrase - a group of words that function as a unit in a sentence'
  };

    /// Get a list of words filtered by category
  static List<String> getWordsByCategory(String category) {
    return words.keys.where((word) {
      final categories = words[word]!['category'] as List;
      return categories.contains(category);
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
      if (words[word]!.containsKey('partOfSpeech')) {
        parts.add(words[word]!['partOfSpeech'] as String);
      }
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
