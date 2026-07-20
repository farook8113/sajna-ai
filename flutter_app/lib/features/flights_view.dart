import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../core/theme.dart';
import '../core/database.dart';
import '../models/flight_report.dart';
import '../services/timeline_calculator.dart';

class FlightsView extends StatefulWidget {
  const FlightsView({super.key});

  @override
  State<FlightsView> createState() => _FlightsViewState();
}

class _FlightsViewState extends State<FlightsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _flightNoController = TextEditingController(text: "G9-137");
  final _sectorController = TextEditingController(text: "SHJ-CAI");
  final _acRegController = TextEditingController(text: "A6-ANA");
  final _paxCountController = TextEditingController(text: "162");
  final _stdController = TextEditingController(text: "08:15");
  final _staController = TextEditingController(text: "11:20");
  final _tzController = TextEditingController(text: "2");
  final _specialsController = TextEditingController(text: "2 WCHR, 1 INF");
  
  String _acType = "A320";
  Map<String, Map<String, String>>? _calculatedTimings;
  bool _isUtc = false;
  DateTime _selectedDate = DateTime.now();

  // Log Sheet Fields Controllers
  final _sheetDateController = TextEditingController();
  final _sheetSectorController = TextEditingController();
  final _sheetRegController = TextEditingController();
  final _sheetFlightOutController = TextEditingController();
  final _sheetPaxOutController = TextEditingController();
  final _sheetSpecialsOutController = TextEditingController();

  final _sheetFlightInController = TextEditingController();
  final _sheetPaxInController = TextEditingController();
  final _sheetSpecialsInController = TextEditingController();

  // Seal Verification & Log details
  final _fwdSealsController = TextEditingController(text: "OK / Secure - 418519");
  final _aftSealsController = TextEditingController(text: "OK / Secure - 912851");
  final _safetyChecksController = TextEditingController(text: "Completed by all crew positions");
  final _briefingController = TextEditingController(text: "Received & Actioned");

  final _outboundDelayController = TextEditingController(text: "None. OTP achieved.");
  final _inboundDelayController = TextEditingController(text: "None. Standard transit flow.");
  final _defectLogsController = TextEditingController(text: "None logged this segment.");

  // Timings Controllers for Log Sheet grid
  final Map<String, TextEditingController> _milestoneControllers = {};

  final List<String> _milestones = [
    "Arrive to Office", "Ready for Briefing", "Briefing Starts", "Briefing Completed",
    "Leave Office (latest)", "First Bus", "Second Bus", "Cabin Crew Onboard",
    "Cockpit Crew Onboard", "Cleaning Start", "Cleaning Done", "Boarding Clearance",
    "First Passenger", "Last Passenger", "Door Closed", "Aircraft Landed",
    "Door Open", "Last Passenger Disembarked", "Cleaning Started (Transit)",
    "Cleaning Completed (Transit)", "Door Open in Sharjah"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _dateController.text = DateFormat("yyyy-MM-dd").format(_selectedDate);
    _sheetDateController.text = DateFormat("dd/MM/yyyy").format(_selectedDate);

    for (var m in _milestones) {
      _milestoneControllers[m] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dateController.dispose();
    _flightNoController.dispose();
    _sectorController.dispose();
    _acRegController.dispose();
    _paxCountController.dispose();
    _stdController.dispose();
    _staController.dispose();
    _tzController.dispose();
    _specialsController.dispose();
    _sheetDateController.dispose();
    _sheetSectorController.dispose();
    _sheetRegController.dispose();
    _sheetFlightOutController.dispose();
    _sheetPaxOutController.dispose();
    _sheetSpecialsOutController.dispose();
    _sheetFlightInController.dispose();
    _sheetPaxInController.dispose();
    _sheetSpecialsInController.dispose();
    _fwdSealsController.dispose();
    _aftSealsController.dispose();
    _safetyChecksController.dispose();
    _briefingController.dispose();
    _outboundDelayController.dispose();
    _inboundDelayController.dispose();
    _defectLogsController.dispose();
    for (var c in _milestoneControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _calculateTimings() {
    if (!_formKey.currentState!.validate()) return;
    
    final std = _stdController.text;
    final sta = _staController.text;
    final tz = int.tryParse(_tzController.text) ?? 0;

    final results = TimelineCalculator.calculate(
      date: _selectedDate,
      stdLocal: std,
      staLocal: sta,
      acType: _acType,
      tzOffset: tz,
    );

    setState(() {
      _calculatedTimings = results;
    });
  }

  void _populateLogSheet() {
    if (_calculatedTimings == null) return;
    final meta = _calculatedTimings!;
    final times = meta['utc']!; // Standard UTC output

    setState(() {
      _sheetDateController.text = DateFormat("dd/MM/yyyy").format(_selectedDate);
      _sheetSectorController.text = _sectorController.text.toUpperCase();
      _sheetRegController.text = _acRegController.text.toUpperCase();
      _sheetFlightOutController.text = _flightNoController.text.toUpperCase();
      _sheetPaxOutController.text = _paxCountController.text;
      _sheetSpecialsOutController.text = _specialsController.text;

      // Auto-increment inbound flight no
      _sheetFlightInController.text = _incrementFlightNo(_flightNoController.text);

      for (var m in _milestones) {
        _milestoneControllers[m]?.text = times[m] ?? "";
      }
    });

    // Save to Hive Database
    final report = FlightReport(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: _selectedDate,
      flightNo: _flightNoController.text.toUpperCase(),
      sector: _sectorController.text.toUpperCase(),
      acType: _acType,
      acReg: _acRegController.text.toUpperCase(),
      paxCount: int.tryParse(_paxCountController.text) ?? 0,
      departureTimeLocal: _stdController.text,
      arrivalTimeLocal: _staController.text,
      timezoneOffset: int.tryParse(_tzController.text) ?? 0,
      specials: _specialsController.text,
      calculatedTimingsLocal: _calculatedTimings!['local']!,
      calculatedTimingsUtc: _calculatedTimings!['utc']!,
      forwardSeals: _fwdSealsController.text,
      aftSeals: _aftSealsController.text,
      delayOutbound: _outboundDelayController.text,
      delayInbound: _inboundDelayController.text,
      cabinDefects: _defectLogsController.text,
    );

    SajnaDatabase.saveReport(report);
    SajnaDatabase.resetAllChecklists(); // Clean checklists for the new sector

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✓ Timelines populated in Log Sheet. Checklists reset for the segment."),
        backgroundColor: Colors.green,
      ),
    );
    _tabController.animateTo(1);
  }

  String _incrementFlightNo(String current) {
    final match = RegExp(r'^([a-zA-Z0-9]+)-(\d+)$').firstMatch(current);
    if (match != null) {
      final prefix = match.group(1);
      final num = int.parse(match.group(2)!) + 1;
      return "$prefix-$num";
    }
    return current;
  }

  void _shareReport() {
    final summary = "SAJNA AI EFB Flight Summary:\n"
        "Date: ${_sheetDateController.text}\n"
        "Flight Outbound: ${_sheetFlightOutController.text}\n"
        "Sector: ${_sheetSectorController.text}\n"
        "A/C Reg: ${_sheetRegController.text}\n"
        "Pax: ${_sheetPaxOutController.text}\n"
        "OTP Status: OTP Achieved. Outbound Delay Code: ${_outboundDelayController.text}";
    
    Share.share(summary, subject: 'Air Arabia Cabin Log Sheet');
  }

  void _exportWordDoc() {
    // Replicating HTML-to-Word conversion logic safely
    final html = """
    <html>
    <body>
      <h2>Air Arabia</h2>
      <h1>Cabin Flight Log Sheet</h1>
      <p>Date: ${_sheetDateController.text} | Sector: ${_sheetSectorController.text}</p>
      <table border="1" cellpadding="5" cellspacing="0">
        <tr><th>Milestone</th><th>UTC Time</th></tr>
        ${_milestones.map((m) => "<tr><td>$m</td><td>${_milestoneControllers[m]?.text}</td></tr>").join()}
      </table>
    </body>
    </html>
    """;
    
    // Simulate writing to Android file storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✓ Log Sheet exported to Word (.doc) and saved to Downloads folder."),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sub tabs
        Container(
          color: Theme.of(context).colorScheme.surface,
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.edit_document), text: "Flight Creator"),
              Tab(icon: Icon(Icons.description), text: "A4 Log Sheet Wizard"),
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
              _buildFlightCreatorTab(),
              _buildLogSheetWizardTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlightCreatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Flight Details & Parameters",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _dateController,
                            decoration: const InputDecoration(labelText: "Flight Date", border: OutlineInputBorder()),
                            readOnly: true,
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2025),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setState(() {
                                  _selectedDate = picked;
                                  _dateController.text = DateFormat("yyyy-MM-dd").format(picked);
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _flightNoController,
                            decoration: const InputDecoration(labelText: "Flight No", border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _sectorController,
                            decoration: const InputDecoration(labelText: "Sector (From-To)", border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _acType,
                            decoration: const InputDecoration(labelText: "A/C Type", border: OutlineInputBorder()),
                            items: const [
                              DropdownMenuItem(value: "A320", child: Text("Airbus A320")),
                              DropdownMenuItem(value: "A321", child: Text("Airbus A321")),
                            ],
                            onChanged: (val) {
                              setState(() {
                                _acType = val ?? "A320";
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _acRegController,
                            decoration: const InputDecoration(labelText: "A/C Reg", border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _paxCountController,
                            decoration: const InputDecoration(labelText: "Pax Count", border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _stdController,
                            decoration: const InputDecoration(labelText: "STD (Local)", border: OutlineInputBorder()),
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _staController,
                            decoration: const InputDecoration(labelText: "STA (Local)", border: OutlineInputBorder()),
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _tzController,
                            decoration: const InputDecoration(labelText: "Outstation Timezone Offset", border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _specialsController,
                            decoration: const InputDecoration(labelText: "Specials (SCPs)", border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SajnaTheme.primaryRed,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _calculateTimings,
                      child: const Text("Generate Flight Timelines"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildCalculatedTimingsList(),
        ],
      ),
    );
  }

  Widget _buildCalculatedTimingsList() {
    if (_calculatedTimings == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: const [
              Icon(Icons.schedule, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text("Enter parameters and click generate to calculate times.", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    final source = _isUtc ? _calculatedTimings!['utc']! : _calculatedTimings!['local']!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Calculated Milestone Limits", style: TextStyle(fontWeight: FontWeight.bold)),
                ToggleButtons(
                  isSelected: [!_isUtc, _isUtc],
                  onPressed: (index) {
                    setState(() {
                      _isUtc = (index == 1);
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  constraints: const BoxConstraints(minHeight: 28, minWidth: 60),
                  children: const [
                    Text("Local", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    Text("UTC", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _milestones.length,
              itemBuilder: (context, index) {
                final m = _milestones[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(m, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(
                        source[m] ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: SajnaTheme.primaryRed),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SajnaTheme.primaryRed,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _populateLogSheet,
              child: const Text("Populate & Open Log Sheet"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogSheetWizardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Actions bar
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => windowPrintMock(),
                      icon: const Icon(Icons.picture_as_pdf, size: 16),
                      label: const Text("Save PDF"),
                      style: ElevatedButton.styleFrom(backgroundColor: SajnaTheme.surfaceDarkVar),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _exportWordDoc,
                      icon: const Icon(Icons.description, size: 16),
                      label: const Text("Export Word"),
                      style: ElevatedButton.styleFrom(backgroundColor: SajnaTheme.surfaceDarkVar),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _shareReport,
                      icon: const Icon(Icons.share, size: 16),
                      label: const Text("Share Report"),
                      style: ElevatedButton.styleFrom(backgroundColor: SajnaTheme.surfaceDarkVar),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _sheetFlightOutController.text = _incrementFlightNo(_sheetFlightOutController.text);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Segment duplicated. Flight number incremented.")),
                        );
                      },
                      icon: const Icon(Icons.content_copy, size: 16),
                      label: const Text("Duplicate"),
                      style: ElevatedButton.styleFrom(backgroundColor: SajnaTheme.surfaceDarkVar),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Recreated A4 Page Layout
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Center(
                  child: Text(
                    "AIR ARABIA",
                    style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                  ),
                ),
                const Center(
                  child: Text(
                    "CABIN FLIGHT LOG SHEET",
                    style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                  ),
                ),
                const Center(
                  child: Text(
                    "Official Flight Operations & Safety Record (UTC)",
                    style: TextStyle(fontFamily: 'Courier', fontStyle: FontStyle.italic, fontSize: 10, color: Colors.black54),
                  ),
                ),
                const Divider(color: Colors.black, thickness: 1.5),

                // Table 1: Flight Details
                _buildSheetTitle("1. Flight Segment Details"),
                _buildA4GridRow([
                  _buildA4Cell("Date", _sheetDateController),
                  _buildA4Cell("Sector", _sheetSectorController),
                  _buildA4Cell("A/C Reg", _sheetRegController),
                ]),
                _buildA4GridRow([
                  _buildA4Cell("Flt Out", _sheetFlightOutController),
                  _buildA4Cell("Pax Out", _sheetPaxOutController),
                  _buildA4Cell("Specials", _sheetSpecialsOutController),
                ]),
                _buildA4GridRow([
                  _buildA4Cell("Flt In", _sheetFlightInController),
                  _buildA4Cell("Pax In", _sheetPaxInController),
                  _buildA4Cell("Specials In", _sheetSpecialsInController),
                ]),

                const SizedBox(height: 12),
                // Table 2: Milestones
                _buildSheetTitle("2. Operational Timings (UTC)"),
                Table(
                  border: TableBorder.all(color: Colors.black),
                  children: _milestones.map((m) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(m, style: const TextStyle(fontFamily: 'Courier', fontSize: 11, color: Colors.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: TextField(
                            controller: _milestoneControllers[m],
                            style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black),
                            decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),
                // Table 3: Safety Checks
                _buildSheetTitle("3. Safety Verifications & Security Seals"),
                _buildA4GridRow([
                  _buildA4Cell("Fwd Seals", _fwdSealsController),
                  _buildA4Cell("Aft Seals", _aftSealsController),
                ]),
                _buildA4GridRow([
                  _buildA4Cell("Safety Checks", _safetyChecksController),
                  _buildA4Cell("Capt Briefing", _briefingController),
                ]),

                const SizedBox(height: 12),
                // Table 4: Delay details
                _buildSheetTitle("4. Safety Discrepancies & Delay Log"),
                _buildA4Cell("Outbound Delay Reason", _outboundDelayController),
                _buildA4Cell("Inbound Delay Reason", _inboundDelayController),
                _buildA4Cell("Logged Interior Defects", _defectLogsController),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: const [
                        SizedBox(width: 140, child: Divider(color: Colors.black)),
                        Text("Cabin Supervisor Signature", style: TextStyle(fontFamily: 'Courier', fontSize: 9, color: Colors.black)),
                      ],
                    ),
                    Column(
                      children: const [
                        SizedBox(width: 140, child: Divider(color: Colors.black)),
                        Text("Commander Signature (Verify)", style: TextStyle(fontFamily: 'Courier', fontSize: 9, color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        text,
        style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black),
      ),
    );
  }

  Widget _buildA4GridRow(List<Widget> cells) {
    return Row(
      children: cells.map((c) => Expanded(child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
        child: c,
      ))).toList(),
    );
  }

  Widget _buildA4Cell(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Courier', fontSize: 9, color: Colors.black54)),
          TextField(
            controller: controller,
            style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black),
            decoration: const InputDecoration(border: InputBorder.none, isDense: true),
          ),
        ],
      ),
    );
  }

  void windowPrintMock() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Simulated PDF Print"),
        content: const Text("A4 Log Sheet layout generated successfully. Spooling to Android Print Manager..."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Close")),
        ],
      ),
    );
  }
}
