import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../core/connectivity.dart';
import '../core/database.dart';
import '../models/flight_report.dart';

class DashboardView extends ConsumerWidget {
  final Function(int) onTabChange;
  const DashboardView({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityProvider);
    final syncState = ref.watch(syncProvider);
    final aiMode = SajnaDatabase.getAiMode();
    final reports = SajnaDatabase.getReports();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today's Flight status card (Air Arabia red theme gradient)
          _buildActiveFlightCard(context),
          const SizedBox(height: 16),

          // Connectivity Status Card
          _buildConnectivityCard(context, isOnline, aiMode, syncState),
          const SizedBox(height: 24),

          // Quick Actions Section
          const Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 12),
          _buildQuickActionsGrid(),
          const SizedBox(height: 24),

          // Side-by-side or stacked summary panels
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildSecurityStatusCard(context, isOnline),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildRecentReportsCard(context, reports),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFlightCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: Theme.of(context).brightness == Brightness.dark
              ? [const Color(0xFF2A0104), const Color(0xFF150002)]
              : [const Color(0xFFFFDAD9), const Color(0xFFF5F0F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF5C000B)
              : const Color(0xFFFF8E94),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: SajnaTheme.primaryRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "ACTIVE FLIGHT",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFFF8E94)
                          : SajnaTheme.primaryRed,
                    ),
                  ),
                ],
              ),
              const Text(
                "20 Jul 2026",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SHJ",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text("Sharjah", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: SajnaTheme.primaryRed,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "G9-137",
                        style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey, thickness: 1, indent: 8, endIndent: 8)),
                        Icon(Icons.flight_takeoff, color: SajnaTheme.primaryRed, size: 20),
                        Expanded(child: Divider(color: Colors.grey, thickness: 1, indent: 8, endIndent: 8)),
                      ],
                    ),
                  ],
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "CAI",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text("Cairo", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Step timeline indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimelineStep(1, "Sign In", true, false),
              _buildTimelineStep(2, "Briefing", true, false),
              _buildTimelineStep(3, "Boarding", false, true),
              _buildTimelineStep(4, "Landed", false, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(int num, String label, bool isDone, bool isActive) {
    Color circleColor = Colors.grey.withOpacity(0.2);
    Color textColor = Colors.grey;
    if (isDone) {
      circleColor = Colors.green;
      textColor = Colors.green;
    } else if (isActive) {
      circleColor = SajnaTheme.primaryRed;
      textColor = SajnaTheme.primaryRed;
    }

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            "$num",
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textColor),
        ),
      ],
    );
  }

  Widget _buildConnectivityCard(BuildContext context, bool isOnline, String aiMode, SyncState syncState) {
    Color cardColor;
    Color iconColor;
    IconData icon;
    String title;
    String subtitle;

    if (isOnline) {
      cardColor = Colors.green.withOpacity(0.05);
      iconColor = Colors.green;
      icon = Icons.wifi;
      title = "🟢 Online";
      subtitle = (aiMode == 'offline') 
          ? "Connected (AI Mode: Strict Offline)" 
          : (syncState == SyncState.syncing) ? "Synchronizing data..." : "Connected to Internet";
    } else {
      cardColor = SajnaTheme.primaryRed.withOpacity(0.05);
      iconColor = SajnaTheme.primaryRed;
      icon = Icons.wifi_off;
      title = "🔴 Offline Mode";
      subtitle = "Using Local Safety Manual & Database";
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: iconColor.withOpacity(0.2), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11),
                ),
              ],
            ),
            const Spacer(),
            if (isOnline && syncState == SyncState.syncing)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: SajnaTheme.primaryRed),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double spacing = 12.0;
        final double tileWidth = (width - (spacing * 4)) / 5;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionTile("New Flight", Icons.edit_document, Colors.red, () => onTabChange(1)),
            _buildActionTile("Log Sheet", Icons.description, Colors.blue, () => onTabChange(1)),
            _buildActionTile("AI Chat", Icons.chat_bubble, Colors.orange, () => onTabChange(2)),
            _buildActionTile("Voice Notes", Icons.mic, Colors.green, () => onTabChange(4)),
            _buildActionTile("EFB Manual", Icons.library_books, Colors.purple, () => onTabChange(3)),
          ],
        );
      },
    );
  }

  Widget _buildActionTile(String title, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: SajnaTheme.surfaceDarkVar,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: SajnaTheme.borderDark, width: 1),
          ),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityStatusCard(BuildContext context, bool isOnline) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lock_open, color: SajnaTheme.primaryRed, size: 20),
                SizedBox(width: 8),
                Text(
                  "EFB Safety Status",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMetricRow("CSPM Revision", "Rev 18 (Oct 2025)"),
            _buildMetricRow("Safety Database", "Offline Decrypted"),
            _buildMetricRow("Local Sync", isOnline ? "Synced" : "Pending"),
            _buildMetricRow("Mic Access", "Granted"),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentReportsCard(BuildContext context, List<FlightReport> reports) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.history, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text(
                  "Recent Flights",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (reports.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text("No logged reports", style: TextStyle(fontSize: 12, color: Colors.grey))),
              )
            else
              Column(
                children: reports.take(3).map((rep) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${rep.flightNo} (${rep.sector})",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(
                              rep.acReg,
                              style: const TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                          ],
                        ),
                        const Icon(Icons.check_circle, color: Colors.green, size: 16),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
