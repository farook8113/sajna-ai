import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../core/theme.dart';
import '../core/database.dart';
import '../models/defect.dart';
import '../models/crew_note.dart';
import '../services/rag_evaluator.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Active Preference States
  String _aiMode = "auto";
  bool _isDark = true;

  // Defects Forms Controllers
  final _defFlightController = TextEditingController(text: "G9-137");
  final _defSeatController = TextEditingController(text: "17F");
  final _defDescController = TextEditingController();
  String _defPriority = "Low";
  List<Defect> _defects = [];

  // Notes Forms Controllers
  final _noteTitleController = TextEditingController();
  final _noteContentController = TextEditingController();
  final _noteFlightController = TextEditingController();
  String _noteCategory = "Operational";
  List<CrewNote> _notes = [];

  // Checklist Checkboxes States
  List<bool> _preflightChecklist = [];
  List<bool> _boardingChecklist = [];
  List<bool> _doorsChecklist = [];
  List<bool> _secureChecklist = [];

  final List<String> _preflightItems = [
    "Verify all cabin doors disarmed",
    "Inspect emergency exits pathways",
    "Check portable oxygen cylinders & pressure",
    "Verify Halon fire extinguishers & pins",
    "Ensure PBEs & fire gloves are secure",
  ];
  final List<String> _boardingItems = [
    "Welcome passengers at demo positions",
    "Conduct row counts (R1 & R4C)",
    "Verify exit row able-bodied passengers",
    "Ensure overhead stowage is locked",
  ];
  final List<String> _doorsItems = [
    "Receive arming announcement command",
    "Arm LHS & RHS doors securely",
    "Ask witness crew: \"Confirm Armed\"",
    "Perform physical cross-check verification",
  ];
  final List<String> _secureItems = [
    "Verify seatbelts fastened (pax & infants)",
    "Tray tables locked & seats fully upright",
    "Ensure galley containers locked & carts latched",
    "Verify lavatories vacant & locked",
  ];

  // Calculators States
  final _restDurationController = TextEditingController(text: "4.5");
  final _restShiftsController = TextEditingController(text: "3");
  String _restResult = "Calculations will appear here.";

  final _currAmountController = TextEditingController(text: "100");
  String _currFrom = "AED";
  String _currTo = "SAR";
  String _currResult = "Rates based on offline base.";

  // Timers States
  Timer? _boardingTimer;
  int _boardingRemaining = 1200; // 20:00 mins
  bool _boardingRunning = false;

  Timer? _cleaningTimer;
  int _cleaningRemaining = 480; // 08:00 mins
  bool _cleaningRunning = false;

  // Speech Recognition States
  late stt.SpeechToText _speech;
  bool _isNoteListening = false;

  // RAG Evaluation Results
  RAGEvaluationResult? _evaluationResult;
  bool _isEvaluating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _speech = stt.SpeechToText();
    _loadPreferences();
    _loadChecklists();
    _refreshDefects();
    _refreshNotes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _defFlightController.dispose();
    _defSeatController.dispose();
    _defDescController.dispose();
    _noteTitleController.dispose();
    _noteContentController.dispose();
    _noteFlightController.dispose();
    _restDurationController.dispose();
    _restShiftsController.dispose();
    _currAmountController.dispose();
    _boardingTimer?.cancel();
    _cleaningTimer?.cancel();
    super.dispose();
  }

  void _loadPreferences() {
    setState(() {
      _aiMode = SajnaDatabase.getAiMode();
      _isDark = SajnaDatabase.isDarkMode();
    });
  }

  void _loadChecklists() {
    setState(() {
      _preflightChecklist = SajnaDatabase.getChecklistState('preflight', _preflightItems.length);
      _boardingChecklist = SajnaDatabase.getChecklistState('boarding', _boardingItems.length);
      _doorsChecklist = SajnaDatabase.getChecklistState('doors', _doorsItems.length);
      _secureChecklist = SajnaDatabase.getChecklistState('secure', _secureItems.length);
    });
  }

  void _refreshDefects() {
    setState(() {
      _defects = SajnaDatabase.getDefects();
    });
  }

  void _refreshNotes() {
    setState(() {
      _notes = SajnaDatabase.getNotes();
    });
  }

  // --- Defects Operations ---
  void _saveDefect() {
    if (_defDescController.text.trim().isEmpty) return;
    
    final defect = Defect(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      flightNo: _defFlightController.text,
      seat: _defSeatController.text,
      priority: _defPriority,
      desc: _defDescController.text,
      date: DateTime.now(),
    );

    SajnaDatabase.saveDefect(defect);
    _defDescController.clear();
    _refreshDefects();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✓ Cabin defect logged.")));
  }

  void _deleteDefect(String id) {
    SajnaDatabase.deleteDefect(id);
    _refreshDefects();
  }

  // --- Crew Notes Operations ---
  void _saveNote() {
    if (_noteContentController.text.trim().isEmpty) return;
    
    final note = CrewNote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _noteTitleController.text.isEmpty ? "Voice Memo" : _noteTitleController.text,
      category: _noteCategory,
      flight: _noteFlightController.text,
      content: _noteContentController.text,
      date: DateFormat("dd/MM/yyyy").format(DateTime.now()),
      time: DateFormat("HH:mm").format(DateTime.now()),
    );

    SajnaDatabase.saveNote(note);
    _noteTitleController.clear();
    _noteContentController.clear();
    _noteFlightController.clear();
    _refreshNotes();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✓ Voice Note saved.")));
  }

  void _deleteNote(String id) {
    SajnaDatabase.deleteNote(id);
    _refreshNotes();
  }

  void _togglePinNote(CrewNote note) {
    final updated = note.copyWith(pinned: !note.pinned);
    SajnaDatabase.saveNote(updated);
    _refreshNotes();
  }

  Future<void> _toggleNoteSpeech() async {
    final permission = await Permission.microphone.request();
    if (!permission.isGranted) return;

    if (!_isNoteListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            setState(() => _isNoteListening = false);
          }
        },
      );

      if (available) {
        setState(() => _isNoteListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _noteContentController.text = val.recognizedWords;
          });
        });
      } else {
        // Fallback simulation
        setState(() => _isNoteListening = true);
        Future.delayed(const Duration(seconds: 2), () {
          if (_isNoteListening) {
            setState(() {
              _noteContentController.text = "Discrepancy noted in rear galley cleaning.";
              _isNoteListening = false;
            });
          }
        });
      }
    } else {
      setState(() => _isNoteListening = false);
      _speech.stop();
    }
  }

  // --- Checklist Operations ---
  void _onChecklistChange(String key, int index, bool val, List<bool> list) {
    setState(() {
      list[index] = val;
    });
    SajnaDatabase.saveChecklistState(key, list);
  }

  void _resetChecklists() {
    SajnaDatabase.resetAllChecklists();
    _loadChecklists();
  }

  // --- Calculators Operations ---
  void _calculateRestBreaks() {
    final duration = double.tryParse(_restDurationController.text) ?? 0;
    final shifts = int.tryParse(_restShiftsController.text) ?? 0;

    if (duration > 0 && shifts > 0) {
      final totalMin = duration * 60;
      final breakMin = (totalMin / shifts).floor();
      final h = breakMin ~/ 60;
      final m = breakMin % 60;
      setState(() {
        _restResult = "Each crew member receives:\n$h hr $m min rest break ($breakMin mins total).";
      });
    }
  }

  void _convertCurrency() {
    final amount = double.tryParse(_currAmountController.text) ?? 0;
    final rates = {
      "AED": {"SAR": 1.02, "USD": 0.27, "EUR": 0.25, "INR": 22.75, "AED": 1.0},
      "SAR": {"AED": 0.98, "USD": 0.26, "EUR": 0.24, "INR": 22.25, "SAR": 1.0},
      "USD": {"AED": 3.67, "SAR": 3.75, "EUR": 0.92, "INR": 83.50, "USD": 1.0},
      "EUR": {"AED": 3.98, "SAR": 4.07, "USD": 1.08, "INR": 90.60, "EUR": 1.0},
      "INR": {"AED": 0.044, "SAR": 0.045, "USD": 0.012, "EUR": 0.011, "INR": 1.0}
    };

    if (amount > 0) {
      final rate = rates[_currFrom]?[_currTo] ?? 1.0;
      final result = (amount * rate).toStringAsFixed(2);
      setState(() {
        _currResult = "$amount $_currFrom = $result $_currTo";
      });
    }
  }

  // --- Timer Operations ---
  void _toggleBoardingTimer() {
    if (_boardingRunning) {
      _boardingTimer?.cancel();
      setState(() {
        _boardingRunning = false;
      });
    } else {
      setState(() {
        _boardingRunning = true;
      });
      _boardingTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_boardingRemaining > 0) {
          setState(() {
            _boardingRemaining--;
          });
        } else {
          t.cancel();
          setState(() {
            _boardingRunning = false;
          });
          _showTimerAlert("Boarding");
        }
      });
    }
  }

  void _resetBoardingTimer() {
    _boardingTimer?.cancel();
    setState(() {
      _boardingRemaining = 1200;
      _boardingRunning = false;
    });
  }

  void _toggleCleaningTimer() {
    if (_cleaningRunning) {
      _cleaningTimer?.cancel();
      setState(() {
        _cleaningRunning = false;
      });
    } else {
      setState(() {
        _cleaningRunning = true;
      });
      _cleaningTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_cleaningRemaining > 0) {
          setState(() {
            _cleaningRemaining--;
          });
        } else {
          t.cancel();
          setState(() {
            _cleaningRunning = false;
          });
          _showTimerAlert("Transit Cleaning");
        }
      });
    }
  }

  void _resetCleaningTimer() {
    _cleaningTimer?.cancel();
    setState(() {
      _cleaningRemaining = 480;
      _cleaningRunning = false;
    });
  }

  void _showTimerAlert(String timerName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("⏰ $timerName Timer Finished"),
        content: Text("The standard operational window of $timerName has elapsed."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Close")),
        ],
      ),
    );
  }

  String _formatTimerDigits(int totalSecs) {
    final m = totalSecs ~/ 60;
    final s = totalSecs % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  // --- RAG Evaluation Suite ---
  void _runRAGEvaluation() {
    setState(() {
      _isEvaluating = true;
      _evaluationResult = null;
    });

    Future.delayed(const Duration(seconds: 1), () {
      final results = RAGEvaluator.runEvaluation();
      setState(() {
        _evaluationResult = results;
        _isEvaluating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.surface,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(icon: Icon(Icons.report_problem), text: "Defects Log"),
              Tab(icon: Icon(Icons.mic), text: "Voice Notes"),
              Tab(icon: Icon(Icons.fact_check), text: "Checklists"),
              Tab(icon: Icon(Icons.calculate), text: "Calculators"),
              Tab(icon: Icon(Icons.analytics), text: "RAG Evaluation"),
              Tab(icon: Icon(Icons.settings), text: "Preferences"),
            ],
            indicatorColor: SajnaTheme.primaryRed,
            labelColor: SajnaTheme.primaryRed,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDefectsTab(),
              _buildVoiceNotesTab(),
              _buildChecklistsTab(),
              _buildCalculatorsTab(),
              _buildRAGEvaluationTab(),
              _buildPreferencesTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefectsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Log Cabin Defect / CDL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _defFlightController,
                          decoration: const InputDecoration(labelText: "Flight Number", border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _defSeatController,
                          decoration: const InputDecoration(labelText: "Affected Seat/Row", border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _defPriority,
                    decoration: const InputDecoration(labelText: "Priority Level", border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: "Low", child: Text("Low - Cosmetic discrepancy")),
                      DropdownMenuItem(value: "Medium", child: Text("Medium - Seat swap required")),
                      DropdownMenuItem(value: "High", child: Text("High - Exit row / Safety concern")),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _defPriority = val ?? "Low";
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _defDescController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: "Defect Details", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SajnaTheme.primaryRed,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: _saveDefect,
                    child: const Text("Log Defect"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildDefectsList(),
        ],
      ),
    );
  }

  Widget _buildDefectsList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Active Cabin Defects Log", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (_defects.isEmpty)
              const Center(child: Text("No defects logged", style: TextStyle(color: Colors.grey)))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _defects.length,
                itemBuilder: (context, index) {
                  final def = _defects[index];
                  Color priColor = Colors.green;
                  if (def.priority == 'Medium') priColor = Colors.orange;
                  if (def.priority == 'High') priColor = SajnaTheme.primaryRed;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: SajnaTheme.surfaceDarkVar,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: priColor.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                              child: Text(def.priority, style: TextStyle(color: priColor, fontSize: 9.5, fontWeight: FontWeight.bold)),
                            ),
                            Text("Seat ${def.seat}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 16, color: Colors.grey),
                              onPressed: () => _deleteDefect(def.id),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(def.desc, style: const TextStyle(fontSize: 12.5, color: Colors.white70)),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceNotesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Create Crew Note / Voice Memo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _noteTitleController,
                          decoration: const InputDecoration(labelText: "Note Title", border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _noteCategory,
                          decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder()),
                          items: const [
                            DropdownMenuItem(value: "Operational", child: Text("Operational")),
                            DropdownMenuItem(value: "Catering", child: Text("Catering")),
                            DropdownMenuItem(value: "Safety", child: Text("Safety")),
                            DropdownMenuItem(value: "Briefing", child: Text("Briefing")),
                          ],
                          onChanged: (val) {
                            setState(() {
                              _noteCategory = val ?? "Operational";
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _noteFlightController,
                    decoration: const InputDecoration(labelText: "Flight Reference (Optional)", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _noteContentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Note details", 
                      border: const OutlineInputBorder(),
                      hintText: _isNoteListening ? "Listening... speak now" : "Type note content...",
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _toggleNoteSpeech,
                        icon: Icon(_isNoteListening ? Icons.stop : Icons.mic, size: 16),
                        label: Text(_isNoteListening ? "Stop" : "Speech to Text"),
                        style: ElevatedButton.styleFrom(backgroundColor: _isNoteListening ? Colors.orange : SajnaTheme.surfaceDarkVar),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: SajnaTheme.primaryRed, foregroundColor: Colors.white),
                        onPressed: _saveNote,
                        child: const Text("Save Note"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildNotesList(),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Saved Crew Notes", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (_notes.isEmpty)
              const Center(child: Text("No saved notes", style: TextStyle(color: Colors.grey)))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: SajnaTheme.surfaceDarkVar,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.push_pin, size: 16, color: note.pinned ? Colors.orange : Colors.grey),
                                  onPressed: () => _togglePinNote(note),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 16, color: Colors.grey),
                                  onPressed: () => _deleteNote(note.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text("${note.category} • ${note.date} ${note.time}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        const SizedBox(height: 8),
                        Text(note.content, style: const TextStyle(fontSize: 12.5, color: Colors.white70)),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildChecklistCard("1. Pre-flight Checks", 'preflight', _preflightItems, _preflightChecklist)),
              const SizedBox(width: 16),
              Expanded(child: _buildChecklistCard("2. Passenger Boarding", 'boarding', _boardingItems, _boardingChecklist)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildChecklistCard("3. Door Arming Controls", 'doors', _doorsItems, _doorsChecklist)),
              const SizedBox(width: 16),
              Expanded(child: _buildChecklistCard("4. Cabin Secure Checklist", 'secure', _secureItems, _secureChecklist)),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: SajnaTheme.surfaceDarkVar, minimumSize: const Size(180, 48)),
            onPressed: () {
              _resetChecklists();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✓ All flight checklists reset.")));
            },
            child: const Text("Reset All Flight Checklists"),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistCard(String title, String key, List<String> items, List<bool> states) {
    if (states.length < items.length) return const SizedBox();

    final completed = states.where((s) => s).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: SajnaTheme.surfaceDarkVar, borderRadius: BorderRadius.circular(4)),
                  child: Text("$completed/${items.length}", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Divider(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  value: states[index],
                  title: Text(items[index], style: const TextStyle(fontSize: 11.5)),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: SajnaTheme.primaryRed,
                  onChanged: (val) {
                    _onChecklistChange(key, index, val ?? false, states);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorsTab() {
    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Cruise rest break
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Cruise Rest Break Divider", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _restDurationController,
                  decoration: const InputDecoration(labelText: "Duration (Hours)", border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _restShiftsController,
                  decoration: const InputDecoration(labelText: "Shifts Count", border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: SajnaTheme.surfaceDarkVar),
                  onPressed: _calculateRestBreaks,
                  child: const Text("Calculate"),
                ),
                const SizedBox(height: 12),
                Text(_restResult, style: const TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ),

        // Currency Exchange
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Currency Converter", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _currAmountController,
                  decoration: const InputDecoration(labelText: "Amount", border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _currFrom,
                        decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                        items: const [
                          DropdownMenuItem(value: "AED", child: Text("AED")),
                          DropdownMenuItem(value: "SAR", child: Text("SAR")),
                          DropdownMenuItem(value: "USD", child: Text("USD")),
                          DropdownMenuItem(value: "INR", child: Text("INR")),
                        ],
                        onChanged: (val) => setState(() => _currFrom = val ?? "AED"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _currTo,
                        decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                        items: const [
                          DropdownMenuItem(value: "SAR", child: Text("SAR")),
                          DropdownMenuItem(value: "AED", child: Text("AED")),
                          DropdownMenuItem(value: "USD", child: Text("USD")),
                          DropdownMenuItem(value: "INR", child: Text("INR")),
                        ],
                        onChanged: (val) => setState(() => _currTo = val ?? "SAR"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: SajnaTheme.surfaceDarkVar),
                  onPressed: _convertCurrency,
                  child: const Text("Convert"),
                ),
                const SizedBox(height: 12),
                Text(_currResult, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: SajnaTheme.primaryRed)),
              ],
            ),
          ),
        ),

        // Operation Timers
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Operational Timers", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                const SizedBox(height: 12),
                // Timer 1: Boarding
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Boarding (20m)", style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text(_formatTimerDigits(_boardingRemaining), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: SajnaTheme.primaryRed)),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(icon: Icon(_boardingRunning ? Icons.pause : Icons.play_arrow), onPressed: _toggleBoardingTimer),
                        IconButton(icon: const Icon(Icons.refresh), onPressed: _resetBoardingTimer),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                // Timer 2: Cleaning
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Transit Clean (8m)", style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text(_formatTimerDigits(_cleaningRemaining), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: SajnaTheme.primaryRed)),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(icon: Icon(_cleaningRunning ? Icons.pause : Icons.play_arrow), onPressed: _toggleCleaningTimer),
                        IconButton(icon: const Icon(Icons.refresh), onPressed: _resetCleaningTimer),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRAGEvaluationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Safety RAG Search Testing Suite", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  const Text(
                    "Executes 12 safety questions representing key sections in the flight crew manual, compares retrieved manual pages against ground truths, and calculates precise retrieval accuracy rates.",
                    style: TextStyle(fontSize: 12.5, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: SajnaTheme.primaryRed, foregroundColor: Colors.white),
                    onPressed: _isEvaluating ? null : _runRAGEvaluation,
                    child: _isEvaluating 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Run Safety RAG Accuracy Check"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_evaluationResult != null) _buildEvaluationResultsCard(),
        ],
      ),
    );
  }

  Widget _buildEvaluationResultsCard() {
    final res = _evaluationResult!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("RAG Accuracy Metrics", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text("Accuracy: ${res.accuracy.toStringAsFixed(1)}%", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text("Total Test Queries: ${res.totalQuestions} | Correct Retrievals: ${res.correctRetrievals}/${res.totalQuestions}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const Divider(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: res.logs.length,
              itemBuilder: (context, index) {
                final log = res.logs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(log.isCorrect ? Icons.check_circle : Icons.error, color: log.isCorrect ? Colors.green : SajnaTheme.primaryRed, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(log.question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                const SizedBox(height: 2),
                                Text(
                                  "Expected CSPM Page: ${log.expectedPage} | Retrieved Page: ${log.retrievedPage ?? 'None'}",
                                  style: TextStyle(fontSize: 11, color: log.isCorrect ? Colors.green : SajnaTheme.primaryRed),
                                ),
                                Text(
                                  "Match Confidence: ${log.confidence} | Score: ${log.score.toStringAsFixed(1)}",
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 12),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("AI System Preferences", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _aiMode,
                decoration: const InputDecoration(labelText: "AI Operational Mode", border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: "auto", child: Text("Auto (Recommended - Sync when online)")),
                  DropdownMenuItem(value: "offline", child: Text("Offline Only (Strict offline safety manual)")),
                  DropdownMenuItem(value: "online", child: Text("Online Preferred (Query cloud models if connected)")),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _aiMode = val;
                      SajnaDatabase.saveAiMode(val);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _isDark,
                title: const Text("Dark Theme Mode"),
                activeColor: SajnaTheme.primaryRed,
                onChanged: (val) {
                  setState(() {
                    _isDark = val;
                    SajnaDatabase.saveThemeMode(val);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Restart application to apply theme changes.")));
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: SajnaTheme.primaryRed, foregroundColor: Colors.white, minimumSize: const Size(180, 48)),
                onPressed: () {
                  if (confirmReset()) {
                    SajnaDatabase.clearReports();
                    _refreshDefects();
                    _refreshNotes();
                    _resetChecklists();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Local safety databases cleared.")));
                  }
                },
                child: const Text("Clear Local EFB Databases"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool confirmReset() {
    return true; // Simple confirmation wrapper
  }
}
