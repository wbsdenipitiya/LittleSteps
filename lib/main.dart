import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/network/supabase_service.dart';
import 'core/services/permission_service.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/ui_engine/age_adaptive_controller.dart';
import 'features/ui_engine/layouts/toddler_layout.dart';
import 'features/ui_engine/layouts/explorer_layout.dart';
import 'features/ui_engine/layouts/preschool_layout.dart';
import 'features/parent_dashboard/screens/milestone_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SupabaseService.initialize();
  await PermissionService().requestInitialPermissions();
  
  runApp(
    const ProviderScope(
      child: LittleStepsApp(),
    ),
  );
}

class LittleStepsApp extends ConsumerWidget {
  const LittleStepsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'LittleSteps',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const AuthGate(),
        );
      },
    );
  }
}

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(uiProvider);

    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session;

        if (session == null) {
          return const AuthScreen();
        }

        // Initialize Child Sync once logged in
        _initializeChildSync(ref);

        if (!uiState.isParentMode) {
          return _getLayout(uiState.level);
        }

        return const MilestoneDashboard();
      },
    );
  }

  void _initializeChildSync(WidgetRef ref) async {
    final uiNotifier = ref.read(uiProvider.notifier);
    final currentState = ref.read(uiProvider);
    
    if (currentState.activeChildId == null) {
      final childId = await SupabaseService().getFirstChildId();
      if (childId != null) {
        uiNotifier.startSync(childId);
      }
    }
  }

  Widget _getLayout(AgeLevel level) {
    switch (level) {
      case AgeLevel.toddler:
        return const ToddlerLayout();
      case AgeLevel.explorer:
        return const ExplorerLayout();
      case AgeLevel.preschool:
        return const PreschoolLayout();
    }
  }
}
