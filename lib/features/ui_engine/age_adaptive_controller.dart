import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/supabase_service.dart';

enum AgeLevel {
  toddler,   // 1-3
  explorer,  // 3-5
  preschool, // 5-7
}

@immutable
class AdaptiveUiState {
  final AgeLevel level;
  final bool isParentMode;
  final String? activeChildId;
  final bool hasGreeted;

  const AdaptiveUiState({
    this.level = AgeLevel.toddler,
    this.isParentMode = false,
    this.activeChildId,
    this.hasGreeted = false,
  });

  AdaptiveUiState copyWith({
    AgeLevel? level,
    bool? isParentMode,
    String? activeChildId,
    bool? hasGreeted,
  }) {
    return AdaptiveUiState(
      level: level ?? this.level,
      isParentMode: isParentMode ?? this.isParentMode,
      activeChildId: activeChildId ?? this.activeChildId,
      hasGreeted: hasGreeted ?? this.hasGreeted,
    );
  }
}

class AdaptiveUiNotifier extends Notifier<AdaptiveUiState> {
  StreamSubscription<String>? _levelSubscription;

  @override
  AdaptiveUiState build() {
    return const AdaptiveUiState();
  }

  void setLevel(AgeLevel level) {
    state = state.copyWith(level: level);
  }

  void toggleParentMode(bool value) {
    state = state.copyWith(isParentMode: value);
  }

  void markGreeted() {
    state = state.copyWith(hasGreeted: true);
  }

  // --- REMOTE SYNC LOGIC ---

  void startSync(String childId) {
    _levelSubscription?.cancel();
    state = state.copyWith(activeChildId: childId);
    
    _levelSubscription = SupabaseService().listenToChildLevel(childId).listen((levelStr) {
      final level = _parseLevel(levelStr);
      if (level != state.level) {
        state = state.copyWith(level: level);
      }
    });
  }

  AgeLevel _parseLevel(String levelStr) {
    switch (levelStr) {
      case 'explorer': return AgeLevel.explorer;
      case 'preschool': return AgeLevel.preschool;
      default: return AgeLevel.toddler;
    }
  }

  void stopSync() {
    _levelSubscription?.cancel();
    state = state.copyWith(activeChildId: null);
  }
}

final uiProvider = NotifierProvider<AdaptiveUiNotifier, AdaptiveUiState>(() {
  return AdaptiveUiNotifier();
});

final milestonesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, childId) async {
  return SupabaseService().getMilestonesFuture(childId);
});
