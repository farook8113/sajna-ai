import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database.dart';

// Notifies of internet connectivity changes (true = online, false = offline)
class ConnectivityNotifier extends StateNotifier<bool> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _subscription;

  ConnectivityNotifier() : super(false) {
    _init();
  }

  void _init() async {
    // 1. Initial check
    try {
      final results = await _connectivity.checkConnectivity();
      _updateStatusList(results);
    } catch (_) {
      state = false;
    }
    
    // 2. Real-time stream check
    _subscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event is List<ConnectivityResult>) {
        _updateStatusList(event);
      } else {
        // Fallback for older package versions
        _updateStatusSingle(event as ConnectivityResult);
      }
    });
  }

  void _updateStatusList(List<ConnectivityResult> results) {
    state = results.isNotEmpty && results.any((r) => r != ConnectivityResult.none);
  }

  void _updateStatusSingle(ConnectivityResult result) {
    state = (result != ConnectivityResult.none);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, bool>((ref) {
  return ConnectivityNotifier();
});

// Manage Synchronization notifications states
enum SyncState { idle, syncing, completed }

class SyncNotifier extends StateNotifier<SyncState> {
  final Ref _ref;
  Timer? _toastTimer;

  SyncNotifier(this._ref) : super(SyncState.idle) {
    // Watch for offline -> online transitions to trigger auto-sync
    _ref.listen<bool>(connectivityProvider, (previous, next) {
      final aiMode = SajnaDatabase.getAiMode();
      if (next && (previous == false) && aiMode != 'offline') {
        triggerSync();
      }
    });
  }

  Future<void> triggerSync() async {
    if (state == SyncState.syncing) return;
    
    state = SyncState.syncing;
    
    // Simulate cloud uploading logs delay (2 seconds)
    await Future.delayed(const Duration(seconds: 2));
    
    state = SyncState.completed;
    
    // Auto clear completed notification after 4 seconds
    _toastTimer?.cancel();
    _toastTimer = Timer(const Duration(seconds: 4), () {
      state = SyncState.idle;
    });
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }
}

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(ref);
});
