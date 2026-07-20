import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/rag_service.dart';

class ManualView extends StatefulWidget {
  final int initialPage;
  const ManualView({super.key, this.initialPage = 9});

  @override
  State<ManualView> createState() => _ManualViewState();
}

class _ManualViewState extends State<ManualView> {
  late int _currentPage;
  final _jumpController = TextEditingController();
  final _filterController = TextEditingController();
  String _filterText = "";

  final List<Map<String, dynamic>> _chapters = [
    {"badge": "SOM", "title": "Administration", "page": 9, "desc": "Distribution Control"},
    {"badge": "CH 1", "title": "Qualification & Legal", "page": 12, "desc": "Crew Complement"},
    {"badge": "CH 2", "title": "Standard Operating Proc", "page": 268, "desc": "Door Arming & Secure"},
    {"badge": "CH 3", "title": "Emergency Equipment", "page": 481, "desc": "Oxygen & Extinguishers"},
    {"badge": "CH 4", "title": "Emergency Procedures", "page": 493, "desc": "Planned Evacuations"},
    {"badge": "CH 5", "title": "Drills", "page": 580, "desc": "Fire Fighting & Smoke"},
    {"badge": "CH 6", "title": "Survival", "page": 601, "desc": "Ditching & Sea Survival"},
    {"badge": "CH 7", "title": "Medical & First Aid", "page": 635, "desc": "CPR & AED principles"},
    {"badge": "CH 9", "title": "A321NEO Systems", "page": 951, "desc": "ACF Configuration"},
    {"badge": "CH 10", "title": "Dangerous Goods", "page": 1125, "desc": "Cabin Spill Drills"},
    {"badge": "CH 11", "title": "Security", "page": 1134, "desc": "Unruly Passenger threats"},
    {"badge": "CH 12", "title": "Appendices", "page": 1181, "desc": "Flight Logs & CDLs"},
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _jumpController.text = "$_currentPage";
  }

  @override
  void didUpdateWidget(covariant ManualView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPage != oldWidget.initialPage) {
      setState(() {
        _currentPage = widget.initialPage;
        _jumpController.text = "$_currentPage";
      });
    }
  }

  @override
  void dispose() {
    _jumpController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  void _loadPage(int pageNum) {
    if (pageNum < 1) pageNum = 1;
    if (pageNum > 1226) pageNum = 1226;
    setState(() {
      _currentPage = pageNum;
      _jumpController.text = "$pageNum";
    });
  }

  Map<String, String> _getPageContent(int pageNum) {
    // 1. Check if we have a parsed RAG manual chunk
    for (var doc in RAGService.database) {
      if (doc.page == pageNum) {
        return {
          'title': doc.section,
          'chapter': doc.chapter,
          'body': doc.text,
        };
      }
    }

    // 2. Fallbacks mirroring PWA e-reader
    if (pageNum >= 1 && pageNum <= 11) {
      return {
        'title': "0.4 Distribution and Control of Safety Manuals",
        'chapter': "Chapter 0: Administration",
        'body': "This manual is published by Air Arabia flight operations safety division. All cabin crew are required to carry a copy of this manual on duty. The manual contents are intellectual property of Air Arabia. Updates are distributed as revision sheets.\n\n"
            "Revision Procedures:\n"
            "1. Revisions must be updated in the electronic flight bag (EFB) prior to starting any duty.\n"
            "2. CS must verify that all crew members have successfully synced the latest revision (Active Rev 18)."
      };
    } else if (pageNum >= 12 && pageNum <= 251) {
      return {
        'title': "1.9 Crew Complement and Safety Duties",
        'chapter': "Chapter 1: Qualification & Regulations",
        'body': "Each crew position on the Airbus A320 and A321 is assigned specific safety and emergency duties.\n\n"
            "Minimum Cabin Crew Complement:\n"
            "- Airbus A320: Minimum of 3 Cabin Crew members (L1, R1, L4).\n"
            "- Airbus A321: Minimum of 4 Cabin Crew members (L1, R1, L4, R4C).\n\n"
            "Chain of Command:\n"
            "1. Commander (Captain)\n"
            "2. Co-pilot (First Officer)\n"
            "3. Cabin Supervisor (CS - seated at L1)\n"
            "4. Cabin Crew positions."
      };
    } else if (pageNum >= 252 && pageNum <= 480) {
      return {
        'title': "2.25 Galley Security and Pre-flight Inspection",
        'chapter': "Chapter 2: Standard Operating Procedures",
        'body': "All galleys must be checked prior to passenger boarding to ensure all containers, ovens, and cart brackets are secured.\n\n"
            "Standard Inspection Checklist:\n"
            "- Galley carts must have brakes applied and secondary locks engaged.\n"
            "- Galley ovens must be clean and free of loose debris.\n"
            "- Boiler switches and hot beverage makers must be checked for correct operation.\n"
            "- Curtains must be clipped back and secured open for taxi, takeoff, and landing."
      };
    } else if (pageNum >= 481 && pageNum <= 492) {
      return {
        'title': "3.10 Location of Portable Oxygen and Extinguishers",
        'chapter': "Chapter 3: Safety & Emergency Equipment",
        'body': "Airbus A320/A321 aircraft carry portable oxygen cylinders and Halon 1211 fire extinguishers distributed throughout the cabin.\n\n"
            "Pre-flight Checks for Portable Oxygen:\n"
            "1. Cylinder pressure is at least 1500 PSI.\n"
            "2. Mask is plugged into the High flow outlet.\n"
            "3. Carrying strap is securely attached.\n\n"
            "Pre-flight Checks for Halon Extinguishers:\n"
            "1. Pressure gauge indicates within the green band.\n"
            "2. Safety pin is in place and secured with a plastic seal.\n"
            "3. Extinguisher is securely bracketed."
      };
    } else if (pageNum >= 493 && pageNum <= 579) {
      return {
        'title': "4.2 Planned Emergency Evacuation on Land",
        'chapter': "Chapter 4: Emergency Procedures",
        'body': "In the event of a planned emergency landing, the CS will receive a NITS briefing from the Captain.\n\n"
            "NITS Briefing Elements:\n"
            "- Nature of the Emergency.\n"
            "- Intentions of the Captain.\n"
            "- Time remaining before landing.\n"
            "- Special instructions.\n\n"
            "Evacuation Commands:\n"
            "- \"HEADS DOWN, BRACE, BRACE!\"\n"
            "- \"UNFASTEN SEATBELTS, LEAVE EVERYTHING, COME THIS WAY!\"\n"
            "- \"JUMP AND SLIDE!\""
      };
    } else if (pageNum >= 580 && pageNum <= 600) {
      return {
        'title': "5.3 Cabin Depressurization Drill",
        'chapter': "Chapter 5: Drills",
        'body': "In case of sudden cabin decompression (loss of cabin pressure):\n\n"
            "Immediate Crew Actions:\n"
            "1. Grab the nearest oxygen mask immediately. Secure yourself on a seat or hold onto structure.\n"
            "2. Wait until the aircraft reaches safe altitude (10,000 feet) and Captain makes PA: \"Cabin crew, safe altitude.\"\n"
            "3. Obtain portable oxygen bottle and check the cabin for passenger injuries, structural damage, or fires.\n"
            "4. Administer first aid and report status to the Commander."
      };
    } else if (pageNum >= 601 && pageNum <= 634) {
      return {
        'title': "6.1 Basic Principles of Survival",
        'chapter': "Chapter 6: Survival",
        'body': "Survival depends on four main factors: Protection, Location, Water, and Food (in order of priority).\n\n"
            "Survival Actions after Landing in Remote Areas:\n"
            "- Protection: Build shelter using slide rafts or aircraft parts to protect from sun, wind, or cold.\n"
            "- Location: Set up signaling equipment (beacons, signaling mirror, sea dye markers, flares).\n"
            "- Water: Purify water and ration intake. Do NOT drink sea water.\n"
            "- Food: Ration available meals and avoid eating unknown plants."
      };
    } else if (pageNum >= 635 && pageNum <= 881) {
      return {
        'title': "7.15 CPR and Automated External Defibrillator (AED)",
        'chapter': "Chapter 7: Medical & First Aid",
        'body': "If a passenger displays signs of cardiac arrest (unconscious, not breathing):\n\n"
            "CPR Procedure:\n"
            "1. Lay the passenger flat in the aisle.\n"
            "2. Deliver chest compressions (30 compressions at a rate of 100-120 per minute).\n"
            "3. Provide rescue breaths (2 breaths) if protective barrier is available.\n"
            "4. Retrieve AED (Defibrillator) and apply pads to the chest. Follow the AED voice instructions.\n\n"
            "Warning: AED must only be used on unresponsive passengers who are not breathing."
      };
    } else if (pageNum >= 882 && pageNum <= 950) {
      return {
        'title': "8.15 Interphone and Attendant Indication Panel (AIP)",
        'chapter': "Chapter 8: A320/A321 Systems",
        'body': "The interphone system allows communication between all cabin stations and the flight deck.\n\n"
            "AIP Indicators:\n"
            "- Steady Red light: Normal call from another cabin crew.\n"
            "- Flashing Red light: Emergency call from the flight deck.\n"
            "- Amber light: Lavatory smoke detector call.\n\n"
            "In case of cabin interphone failure: visual hand signals must be established."
      };
    } else if (pageNum >= 951 && pageNum <= 1124) {
      return {
        'title': "9.1 A321 NEO ACF (Cabin Flex) Door Configuration",
        'chapter': "Chapter 9: A321NEO/CEO Systems",
        'body': "The A321 NEO features Cabin Flex modifications that change the door exits layout:\n"
            "- Doors 2 and 3 are replaced with overwing emergency exits.\n"
            "- Design increases cabin capacity while maintaining evacuation standards.\n"
            "- Crew briefing must designate who cross-checks mid-cabin exits.\n"
            "- Crew must ensure overwing exit rows are occupied by Able-Bodied Passengers (ABPs)."
      };
    } else if (pageNum >= 1125 && pageNum <= 1133) {
      return {
        'title': "10.4 Dangerous Goods Spills in the Cabin",
        'chapter': "Chapter 10: Dangerous Goods",
        'body': "In case of liquid spill from passenger baggage suspected of being dangerous goods:\n\n"
            "Emergency Actions:\n"
            "1. Move all passengers away from the spill area.\n"
            "2. Don PBE (Protective Breathing Equipment) and heavy rubber fire gloves.\n"
            "3. Retrieve the Dangerous Goods Kit (containing bags and absorbing pads).\n"
            "4. Isolate the spill and place contaminated items in a polyethylene bag.\n"
            "5. Inform the Flight Deck immediately of the substance details."
      };
    } else if (pageNum >= 1134 && pageNum <= 1180) {
      return {
        'title': "11.12 Unruly Passenger Procedures",
        'chapter': "Chapter 11: Security",
        'body': "Unruly passengers are classified into four levels of threat:\n"
            "- Level 1: Disruptive behavior (verbal arguments, seatbelt refusal).\n"
            "- Level 2: Physical disruptive behavior (pushing, damaging cabin interior).\n"
            "- Level 3: Life-threatening behavior (armed weapon, physical assault).\n"
            "- Level 4: Attempted breach of flight deck (sabotage, hijacking attempt).\n\n"
            "CS must inform the Captain of all security threats. Levels 2, 3, and 4 require restraint."
      };
    } else {
      return {
        'title': "12.2 Cabin Safety Reporting Form (IQSMS)",
        'chapter': "Chapter 12: Appendices",
        'body': "IQSMS reporting procedures require the CS to file reports within 24 hours of landing:\n\n"
            "Mandatory Report Events:\n"
            "- Any in-flight medical emergency or CPR/First Aid administration.\n"
            "- Disruptive passenger incidents.\n"
            "- Safety hazards (such as smoke, fire, turbulence).\n"
            "- Seals discrepancy or lost property."
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageContent = _getPageContent(_currentPage);
    
    final filteredChapters = _chapters.where((ch) {
      final text = (ch['badge'] + ch['title'] + ch['desc']).toLowerCase();
      return text.contains(_filterText.toLowerCase());
    }).toList();

    return Row(
      children: [
        // Left Sidebar Chapter Navigation (Tablets/Desktops)
        Container(
          width: 300,
          decoration: const BoxDecoration(
            border: Border(right: BorderSide(color: SajnaTheme.borderDark, width: 1)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _filterController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, size: 18),
                    hintText: "Filter Chapters...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    isDense: true,
                  ),
                  onChanged: (val) {
                    setState(() {
                      _filterText = val;
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredChapters.length,
                  itemBuilder: (context, index) {
                    final ch = filteredChapters[index];
                    final isActive = _currentPage >= ch['page'] && 
                        (index == filteredChapters.length - 1 || _currentPage < filteredChapters[index+1]['page']);
                    
                    return ListTile(
                      dense: true,
                      selected: isActive,
                      selectedTileColor: SajnaTheme.primaryRed.withOpacity(0.08),
                      title: Text(ch['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(ch['desc'], style: const TextStyle(fontSize: 10)),
                      leading: Container(
                        width: 50,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isActive ? SajnaTheme.primaryRed : SajnaTheme.surfaceDarkVar,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          ch['badge'],
                          style: TextStyle(
                            fontSize: 9, 
                            fontWeight: FontWeight.bold,
                            color: isActive ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                      onTap: () => _loadPage(ch['page']),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Right Main E-Reader Panel
        Expanded(
          child: Column(
            children: [
              // Page reader controls header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Theme.of(context).cardColor,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => _loadPage(_currentPage - 1),
                    ),
                    Text(
                      "Page $_currentPage of 1226",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () => _loadPage(_currentPage + 1),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 70,
                      height: 36,
                      child: TextField(
                        controller: _jumpController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        onSubmitted: (val) {
                          final page = int.tryParse(val) ?? _currentPage;
                          _loadPage(page);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: SajnaTheme.surfaceDarkVar),
                      onPressed: () {
                        final page = int.tryParse(_jumpController.text) ?? _currentPage;
                        _loadPage(page);
                      },
                      child: const Text("Jump"),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: SajnaTheme.borderDark),

              // Page Content Display body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pageContent['title']!,
                        style: const TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold, 
                          color: SajnaTheme.primaryRed,
                          fontFamily: 'Outfit',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${pageContent['chapter']} — Page $_currentPage of 1226",
                        style: const TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        pageContent['body']!,
                        style: const TextStyle(fontSize: 14.5, height: 1.6, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
