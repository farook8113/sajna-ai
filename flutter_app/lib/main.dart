import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'core/database.dart';
import 'core/connectivity.dart';
import 'features/dashboard_view.dart';
import 'features/flights_view.dart';
import 'features/chat_view.dart';
import 'features/manual_view.dart';
import 'features/settings_view.dart';

// Riverpod states for Tab navigation and page jumps
final tabIndexProvider = StateProvider<int>((ref) => 0);
final manualJumpPageProvider = StateProvider<int>((ref) => 9);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive offline databases
  await SajnaDatabase.init();
  
  runApp(
    const ProviderScope(
      child: SajnaApp(),
    ),
  );
}

class SajnaApp extends ConsumerWidget {
  const SajnaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = SajnaDatabase.isDarkMode();
    
    return MaterialApp(
      title: 'SAJNA AI',
      debugShowCheckedModeBanner: false,
      theme: SajnaTheme.lightTheme,
      darkTheme: SajnaTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends ConsumerWidget {
  const MainNavigationShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = ref.watch(tabIndexProvider);
    final manualPage = ref.watch(manualJumpPageProvider);
    
    // Listen for cloud sync notifications
    final syncState = ref.watch(syncProvider);
    
    final List<Widget> screens = [
      DashboardView(onTabChange: (index) {
        ref.read(tabIndexProvider.notifier).state = index;
      }),
      const FlightsView(),
      ChatView(onJumpToManual: (tabIdx, pageNum) {
        ref.read(manualJumpPageProvider.notifier).state = pageNum;
        ref.read(tabIndexProvider.notifier).state = 3; // Switch to Manual tab
      }),
      ManualView(initialPage: manualPage),
      const SettingsView(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SAJNA EFB",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
        ),
        actions: [
          // Global Network connectivity indicator badge in app bar
          _buildAppBarSyncIndicator(context, ref),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: activeIndex,
            children: screens,
          ),
          
          // Toast Synchronization Alert overlay
          if (syncState == SyncState.completed)
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Card(
                color: Colors.green,
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text(
                        "✓ Data synchronized successfully.",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: activeIndex,
        onDestinationSelected: (index) {
          ref.read(tabIndexProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: "Dashboard"),
          NavigationDestination(icon: Icon(Icons.flight_takeoff), label: "Flights"),
          NavigationDestination(icon: Icon(Icons.chat_bubble), label: "AI Chat"),
          NavigationDestination(icon: Icon(Icons.library_books), label: "Manual"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  Widget _buildAppBarSyncIndicator(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityProvider);
    final isSyncing = ref.watch(syncProvider) == SyncState.syncing;

    if (isSyncing) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green.withOpacity(0.15) : SajnaTheme.primaryRed.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOnline ? Colors.green : SajnaTheme.primaryRed,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnline ? Icons.cloud_done : Icons.cloud_off,
            color: isOnline ? Colors.green : SajnaTheme.primaryRed,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            isOnline ? "Online" : "Offline",
            style: TextStyle(
              color: isOnline ? Colors.green : SajnaTheme.primaryRed,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
