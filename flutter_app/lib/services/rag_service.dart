class ManualSection {
  final String category;
  final String chapter;
  final String section;
  final int page;
  final List<String> tags;
  final String text;

  ManualSection({
    required this.category,
    required this.chapter,
    required this.section,
    required this.page,
    required this.tags,
    required this.text,
  });
}

class RAGService {
  static final Set<String> _stopWords = {
    "how", "what", "where", "why", "who", "when", "the", "a", "an", "and", "or", "to", "of", "in", 
    "on", "at", "for", "with", "by", "about", "against", "between", "into", "through", "during", 
    "before", "after", "above", "below", "from", "up", "down", "is", "are", "was", "were", "be", 
    "been", "being", "have", "has", "had", "do", "does", "did", "but", "so", "if", "then", "we", 
    "you", "he", "she", "it", "they", "i", "me", "my", "our", "your", "his", "her", "their", "them", 
    "pax", "cabin", "flight", "procedure", "procedures", "manual", "air", "arabia", "does", "happen", 
    "tell", "rules", "rule", "should", "must", "can"
  };

  // Synonyms and Abbreviations Mapping for Crew terms
  static final Map<String, List<String>> _synonyms = {
    "prm": ["mobility", "disability", "wheelchair", "frail", "special category"],
    "abp": ["fit", "strong", "assist", "evacuation", "able bodied"],
    "medif": ["medical form", "fit to fly", "sick passenger", "doctor approval"],
    "dgr": ["dangerous goods", "spill", "hazard", "chemical", "lithium"],
    "fire": ["smoke", "extinguisher", "halon", "burning", "pbe"],
    "exit": ["door", "overwing", "row 17", "row 27", "slide"],
    "arm": ["arming", "girt bar", "slide armed", "cross check"],
    "disarm": ["disarming", "girt bar", "slide disarmed", "cross check"],
    "secure": ["fasten", "locked", "latched", "stowed", "carts", "seatbelt"],
  };

  static final List<ManualSection> _database = [
    ManualSection(
      category: "door_arming",
      chapter: "Chapter 2: Standard Operating Procedures",
      section: "2.11 Cabin Door Arming/Disarming Procedures (SOP)",
      page: 268,
      tags: ["arm", "arming", "cross check", "command", "l1", "r1", "l4", "r4c", "girt bar", "slide"],
      text: "2.11 — Cabin Door Arming/Disarming Procedures\n"
          "The Cabin Supervisor (CS) is responsible to order the Arming/Disarming of the cabin doors.\n\n"
          "2.11.1 — Definition of Cross-check:\n"
          "A cross-check is a visual and a physical check of the opposite door to verify/confirm whether the door is armed or disarmed as appropriate. It must be actioned by the crew members responsible for arming and disarming doors.\n\n"
          "2.11.2 — Procedure for Door Arming:\n"
          "1. Upon receiving the command “CABIN CREW ARM DOORS AND CROSS CHECK”, Crew shall first Arm LHS door then the RHS door.\n"
          "2. Before starting to Arm the door, the door operator shall state the following: \"Arming my door.\"\n"
          "3. Crew member in charge of the door will action the command and start the Arming action.\n"
          "4. The Door operator shall request from the witness to check that the door is Armed by stating: \"Confirm Armed.\"\n"
          "5. The witness crew shall physically cross check and respond: “Armed Confirmed”.\n"
          "6. Once the Arming action is completed, both crew will go to the second door and repeat the actions.\n"
          "7. Note: On departure, once all the cabin doors are closed, and without waiting for the ground equipment to be removed, the CS will immediately make the following PA announcement: “CABIN CREW ARM DOORS AND CROSS-CHECK”."
    ),
    ManualSection(
      category: "door_disarming",
      chapter: "Chapter 2: Standard Operating Procedures",
      section: "2.11.2 (2) Door Disarming Procedures (SOP)",
      page: 269,
      tags: ["disarm", "disarming", "cross check", "command", "l1", "r1", "l4", "r4c", "slide", "unlocked", "open door"],
      text: "2.11.2 (2) — Procedure for Door Disarming:\n"
          "a. Upon receiving the command “CABIN CREW DISARM DOORS AND CROSS CHECK”, Crew shall first Disarm LHS door then the RHS door.\n"
          "b. Before starting to Disarm the door, the door operator shall state the following: \"Disarming my door.\"\n"
          "c. Crew member in charge of the door will action the command and start the Disarming actions.\n"
          "d. The Door operator shall request from the witness to check that the door is Disarmed by stating: \"Confirm Disarmed.\"\n"
          "e. The witness crew shall physically cross check and respond: “Disarmed Confirmed”.\n"
          "f. Once the Disarming action is completed, both crew will go to the second door and repeat the actions.\n"
          "g. Crew members shall then pass the door Disarming confirmation to the Cabin Supervisor (CS).\n"
          "h. CS will then ask for confirmation from the Commander via the interphone: “CAPTAIN, ALL DOORS DISARMED AND CROSS-CHECKED. IS IT CLEAR TO OPEN DOORS”.\n"
          "i. The Captain will check the relevant page on the ECAM and confirm: \"Doors disarmed, clear to open.\""
    ),
    ManualSection(
      category: "cabin_secure",
      chapter: "Chapter 2: Standard Operating Procedures",
      section: "2.12 Cabin Secure for Take-off and Landing (SOP)",
      page: 270,
      tags: ["secure", "take-off", "landing", "carts", "curtains", "seatbelts", "upright", "window shades", "tray tables", "lavatory", "refuses", "refuse", "seat belt refusal", "fasten"],
      text: "2.12 — Cabin Secure for Take-off and Landing\n"
          "Before take-off and landing, the cabin secure check should be given to the Captain when the checks are completed.\n\n"
          "2.12.1 — Cabin Secure Check Areas:\n"
          "- All passengers including infants are seated with seat belts fastened.\n"
          "- Seatbacks are fully upright, window shades are open (at least 50% open, exit rows fully open).\n"
          "- Tray tables are closed, locked, and footrests are stowed.\n"
          "- Carts are latched, brakes applied and secured in galleys.\n"
          "- All galley container doors are locked and latched.\n"
          "- All loose articles are stowed and secured.\n"
          "- Lavatories are vacant, locked and secured.\n"
          "- Cabin secure checks are passed to the CS by crew positions (L1, R1, L4, R4C).\n\n"
          "Note on Seat Belt Refusal:\n"
          "If a passenger refuses to fasten his seat belt, crew must speak to the passenger and explain the safety requirements. If he still refuses, the Cabin Supervisor (CS) must be informed immediately who will then speak to the passenger. If the passenger still refuses, the CS will liaise with the Commander who will authorise the removal of the person from the aircraft unless the safety instructions are complied with."
    ),
    ManualSection(
      category: "infant_procedures",
      chapter: "Chapter 2: Standard Operating Procedures",
      section: "2.7.2 & 2.7.3 Infant Seating Rules and Certified Chairs",
      page: 253,
      tags: ["infant", "child", "certified chair", "car seat", "lap belt", "loop belt", "oxygen mask", "row triple block"],
      text: "- Infants can be carried in certified chairs whenever they are vacant and secured to the aircraft seat.\n"
          "- Certified infant chairs must not obstruct other passengers' way to the aisle.\n"
          "- Adults accompanied by an infant are responsible for securing the infant's chair to the aircraft seat and for securing the infant to the chair with the seat belt for takeoff, landing, and during flight.\n\n"
          "- Multiple occupancy of a seat by one adult and one infant is permitted only if the infant is properly secured by a loop belt (infant lap belt) attached to the adult's safety belt.\n"
          "- An oxygen dispensing unit must be available for both adult and infant (4 oxygen masks per row block). A maximum of one infant is allowed per seat row triple block."
    ),
    ManualSection(
      category: "wheelchair_passengers",
      chapter: "Chapter 2: Standard Operating Procedures",
      section: "2.7.1 Special Category Passengers (SCPs) Seating Policy",
      page: 252,
      tags: ["wheelchair", "special category", "scp", "disability", "frail", "blind", "deaf", "exit row", "obese", "deportees"],
      text: "The following categories of passengers are among those who shall NOT be allocated to, or directed to seats which permit direct access to emergency exits:\n"
          "- PRMs (Persons with Reduced Mobility) and wheelchair passengers.\n"
          "- Passengers who because of age or sickness are so frail that they have difficulty in moving quickly.\n"
          "- Passengers who are so obese that they would have difficulty in moving quickly or reaching and passing through exits.\n"
          "- Substantially blind or substantially deaf passengers.\n"
          "- Children younger than 16 years of age and infants.\n"
          "- Pregnant women.\n"
          "- Note: Walking aids, crutches or walking sticks must be stowed in overhead compartments for takeoff and landing."
    ),
    ManualSection(
      category: "exit_row_seating",
      chapter: "Chapter 2: Standard Operating Procedures",
      section: "2.7.4 Exit Row Seating Assignments (ABPs)",
      page: 255,
      tags: ["exit row", "emergency exit", "abp", "able bodied", "restrictions", "pax", "seating"],
      text: "Seats which permit direct access to emergency exits shall be assigned only to passengers who appear to be reasonably fit, strong and able to assist the rapid evacuation of the aircraft in an emergency after an appropriate briefing by the crew (e.g. Able Bodied Passengers).\n\n"
          "Exit row seats shall NOT be assigned to:\n"
          "- Special Category Passengers (SCPs) like PRMs, pregnant women, infants, or frail passengers.\n"
          "- Passengers lacking the ability to understand instructions given by the crew or safety card.\n"
          "- Passengers who have the responsibility of caring for small children.\n"
          "- Overwing exit rows should not be left vacant. Cabin crew should move qualified ABPs to these seats during taxi, takeoff, and landing."
    ),
    ManualSection(
      category: "medical_emergency",
      chapter: "Chapter 7: Medical and First Aid",
      section: "7.0.3 Principles of Patient Care",
      page: 635,
      tags: ["medical", "doctor", "first aid", "cpr", "breathing", "responsiveness", "emk", "fak", "oxygen", "volunteer"],
      text: "First-aid is the immediate care given to the victim of an accident or sudden illness until professional medical care is available.\n\n"
          "Principles of Patient Care:\n"
          "1. ASSESS the situation and passenger responsiveness (Check ABC: Airway, Breathing, Circulation).\n"
          "2. SUMMON assistance from other crew and page for medical volunteers:\n"
          "   \"Ladies and Gentlemen, if there is a Doctor of Medicine, a Registered Nurse or Paramedic on-board, please contact a Cabin Crew. Please also have your identification available.\"\n"
          "3. DON gloves. Retrieve Emergency Medical Kit (EMK) or First Aid Kit (FAK).\n"
          "4. ADMINISTER oxygen if passenger has breathing difficulties.\n"
          "5. COMMUNICATE details immediately to the Captain."
    ),
    ManualSection(
      category: "fire_procedure",
      chapter: "Chapter 5: Drills",
      section: "5.4.1 Basic Fire Fighting Drill",
      page: 580,
      tags: ["fire", "smoke", "halon", "extinguisher", "pbe", "gloves", "captain", "drill"],
      text: "5.4.1 — Basic Fire Fighting Drill:\n"
          "1. SUMMON Assistance (Back-up crew).\n"
          "2. DON PBE (Protective Breathing Equipment) and wear fire gloves immediately.\n"
          "3. OBTAIN nearest Halon fire extinguisher and test it.\n"
          "4. FIGHT the fire using the extinguisher (aim at the base of the fire, sweep side-to-side).\n"
          "5. ORDER assistant to inform the Captain:\n"
          "   - Where is the fire?\n"
          "   - What is burning?\n"
          "   - How much smoke is there and its colour?\n"
          "   - Actions being taken & whether successful?\n"
          "   - Number of Halon extinguishers used?\n"
          "6. MOVE passengers and portable oxygen bottles away from the area.\n"
          "7. WATCH the fire area continuously until landing to prevent re-ignition."
    ),
    ManualSection(
      category: "survival_ditching",
      chapter: "Chapter 6: Survival",
      section: "6.3 Sea Survival & Ditching Procedures",
      page: 601,
      tags: ["survival", "ditching", "sea", "raft", "flares", "water", "hypothermia", "slide raft", "girt bar"],
      text: "6.3 — Sea Survival / Ditching Procedures:\n"
          "Upon ditching in water:\n"
          "1. Slide rafts must be detached from the girt bar and launched.\n"
          "2. Board passengers quickly, prioritizing injured, infants and elderly.\n"
          "3. Distribute survival equipment (sea anchor, water maker, signaling mirror, flares).\n"
          "4. Retain shelter and prevent hypothermia by huddling together.\n"
          "5. Do NOT deploy slide inflation handles inside the cabin."
    ),
    ManualSection(
      category: "neo_systems",
      chapter: "Chapter 9: A321NEO/CEO Systems",
      section: "9.2 Airbus A321 NEO Cabin Door Configuration (ACF)",
      page: 951,
      tags: ["neo", "acf", "a321", "exits", "doors", "cabin flex", "type iii", "row 17", "row 27", "slide rafts"],
      text: "9.2 — Airbus A321 NEO Cabin Door Configuration:\n"
          "- A321 CEO features 4 main entry doors and 4 overwing emergency exits.\n"
          "- A321 NEO ACF (Cabin Flex) configuration replaces doors 2 and 3 with overwing Type III exit doors.\n"
          "- Crew positions shift: CS L1 remains responsible for front cabin. Mid-cabin exits (L2/R2, L3/R3) must be checked by L4 and R4C respectively.\n"
          "- Exit rows: Row 17 and Row 27 are emergency exit rows on ACF configuration. PRMs and infants must not be seated in these rows."
    ),
    ManualSection(
      category: "reporting_appendices",
      chapter: "Chapter 12: Appendices",
      section: "12.3 Cabin Safety Reports & Log Sheets",
      page: 1181,
      tags: ["appendices", "report", "iqsms", "flight log", "cdl", "appendix", "seals", "safety report"],
      text: "12.3 — Appendices and Cabin Safety Reports:\n"
          "- Cabin Flight Log Sheet is a legal log of the flight. CS must fill and sign for outbound/inbound segments.\n"
          "- IQSMS Cabin Safety Report must be completed online or offline within 24 hours of landing.\n"
          "- Cabin Defect Log (CDL) must document all broken interior cabin equipment for the Ground Engineer."
    ),
    ManualSection(
      category: "refusal_of_embarkation",
      chapter: "Chapter 2: Standard Operating Procedures",
      section: "2.9 Right of Refusal & Sick Passengers (MEDIF)",
      page: 259,
      tags: ["refusal", "sick", "fit to fly", "medif", "heart attack", "pregnant weeks", "pacemaker", "alcohol", "drugs"],
      text: "2.9.2 — Restricted Passengers for Transportation:\n"
          "Under no circumstances will transportation be provided to a person who:\n"
          "- Has NOT completed the Medical Form (MEDIF) for sick passengers requiring oxygen, stretchers, or medical escort.\n"
          "- Has an airborne communicable disease.\n"
          "- Is a pregnant woman after 36 weeks (or after 32 weeks in multiple pregnancy).\n"
          "- Has suffered a heart attack, stroke or heart surgery within the last 3 weeks unless written Doctor’s approval has been obtained.\n"
          "- Appears to be under the influence of alcohol or drugs to the extent that safety of the flight is endangered."
    )
  ];

  static List<ManualSection> get database => _database;

  static Map<String, dynamic> query(String queryText, {bool forceOnline = false}) {
    final cleanQuery = queryText.toLowerCase().trim();
    
    // 1. Synonym / Abbreviation Expansion
    final expandedTerms = <String>[cleanQuery];
    _synonyms.forEach((abbrev, synonymsList) {
      if (cleanQuery.contains(abbrev)) {
        expandedTerms.addAll(synonymsList);
      }
    });

    ManualSection? bestMatch;
    double maxScore = 0;

    final words = cleanQuery
        .split(RegExp(r'[^a-zA-Z0-9]+'))
        .where((w) => w.length > 2 && !_stopWords.contains(w))
        .toList();

    // 2. Score calculations based on custom weightings
    for (var doc in _database) {
      double score = 0;
      final docTextUpper = doc.text.toUpperCase();
      final docSectionUpper = doc.section.toUpperCase();

      // Check category match
      for (var term in expandedTerms) {
        if (doc.category == term.replaceAll(" ", "_") || 
            (term.contains("refusal") && doc.category == "refusal_of_embarkation")) {
          score += 15.0;
        }
      }

      // Check tags matches
      for (var tag in doc.tags) {
        if (cleanQuery.contains(tag.toLowerCase())) {
          score += 8.0;
        }
        for (var term in expandedTerms) {
          if (term.contains(tag.toLowerCase())) {
            score += 4.0;
          }
        }
      }

      // TF-IDF Term match density
      for (var word in words) {
        final regex = RegExp(r'\b' + RegExp.escape(word) + r'\b', caseSensitive: false);
        final matches = regex.allMatches(doc.text);
        score += matches.length * 2.0;

        if (docSectionUpper.contains(word.toUpperCase())) {
          score += 6.0;
        }
      }

      if (score > maxScore) {
        maxScore = score;
        bestMatch = doc;
      }
    }

    // 3. Confidence assessment thresholds
    const highThreshold = 18.0;
    const medThreshold = 8.0;
    const lowThreshold = 3.5;
    
    String confidence = 'None';
    if (maxScore >= highThreshold) {
      confidence = 'High';
    } else if (maxScore >= medThreshold) {
      confidence = 'Medium';
    } else if (maxScore >= lowThreshold) {
      confidence = 'Low';
    }

    if (confidence != 'None' && bestMatch != null) {
      String answerPrefix = "";
      if (forceOnline) {
        // Mocking Cloud LLM Grounded answer format
        answerPrefix = "[Grounded Cloud AI] Based on Air Arabia Cabin Safety Manual, ";
      } else {
        answerPrefix = "According to Air Arabia CSPM ${bestMatch.chapter}, Section ${bestMatch.section} (Page ${bestMatch.page}):\n\n";
      }

      return {
        'answer': "$answerPrefix${bestMatch.text}",
        'page': bestMatch.page,
        'section': bestMatch.section,
        'chapter': bestMatch.chapter,
        'excerpt': bestMatch.text,
        'confidence': confidence,
        'score': maxScore,
        'found': true,
      };
    } else {
      return {
        'answer': "This information was not found in the available manuals.\n\n*Please broaden your query. You can ask about door arming, emergency checklists, passenger seatbelt refusal, PRM seating, child chairs, or fire drills.*",
        'page': null,
        'section': null,
        'chapter': null,
        'excerpt': null,
        'confidence': 'None',
        'score': maxScore,
        'found': false,
      };
    }
  }
}
