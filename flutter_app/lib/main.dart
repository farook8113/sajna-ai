import 'package:flutter/material';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('sajna_settings');
  await Hive.openBox('sajna_reports');
  await Hive.openBox('sajna_notes');
  await Hive.openBox('sajna_defects');

  runApp(
    const ProviderScope(
      child: SajnaApp(),
    ),
  );
}

class SajnaApp extends StatelessWidget {
  const SajnaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAJNA AI',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD20A11), // Air Arabia Crimson
          primary: const Color(0xFFD20A11),
          secondary: Colors.black,
          background: const Color(0xFFF4F5F7),
          surface: Colors.white,
        ),
        fontFamily: 'Outfit',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD20A11),
          secondary: Colors.white,
          background: Color(0xFF121214),
          surface: Color(0xFF1C1C1E),
        ),
        fontFamily: 'Outfit',
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const FlightReportScreen(),
    const LogSheetScreen(),
    const ChatScreen(),
    const NotesScreen(),
    const ManualsScreen(),
    const ChecklistsScreen(),
    const CalculatorsScreen(),
    const DefectsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Row(
        children: [
          if (isTablet)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Icon(Icons.flight_takeoff, color: Color(0xFFD20A11), size: 36),
              ),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
                NavigationRailDestination(icon: Icon(Icons.edit_document), label: Text('Report')),
                NavigationRailDestination(icon: Icon(Icons.description), label: Text('Log Sheet')),
                NavigationRailDestination(icon: Icon(Icons.chat_bubble), label: Text('AI Chat')),
                NavigationRailDestination(icon: Icon(Icons.notes), label: Text('Notes')),
                NavigationRailDestination(icon: Icon(Icons.library_books), label: Text('Manuals')),
                NavigationRailDestination(icon: Icon(Icons.fact_check), label: Text('Checklists')),
                NavigationRailDestination(icon: Icon(Icons.calculate), label: Text('Calculators')),
                NavigationRailDestination(icon: Icon(Icons.report_problem), label: Text('Defects')),
              ],
            ),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: isTablet
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFFD20A11),
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
                BottomNavigationBarItem(icon: Icon(Icons.edit_document), label: 'Report'),
                BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Log Sheet'),
                BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'AI Chat'),
                BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
              ],
            ),
    );
  }
}

// Shell Widget Screen Placeholders
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Dashboard')), body: const Center(child: Text('Dashboard (Tablet & One-Hand Usability Optimised)')));
}

class FlightReportScreen extends StatelessWidget {
  const FlightReportScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Smart Flight Report')), body: const Center(child: Text('Report Calculations')));
}

class LogSheetScreen extends StatelessWidget {
  const LogSheetScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Flight Log Sheet')), body: const Center(child: Text('A4 Recreated Print Template')));
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('SAJNA AI Chat')), body: const Center(child: Text('Local manual RAG Chatbot')));
}

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Flight & Voice Notes')), body: const Center(child: Text('Speech to Text Notes')));
}

class ManualsScreen extends StatelessWidget {
  const ManualsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Manual Library')), body: const Center(child: Text('Cached PDF Manuals')));
}

class ChecklistsScreen extends StatelessWidget {
  const ChecklistsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Interactive Checklists')), body: const Center(child: Text('Safety Checklists')));
}

class CalculatorsScreen extends StatelessWidget {
  const CalculatorsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Calculators')), body: const Center(child: Text('Crew Calculators')));
}

class DefectsScreen extends StatelessWidget {
  const DefectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cabin Defect Log'),
      ),
      body: const Center(
        child: Text('Report Defects'),
      ),
    );
  }
}
