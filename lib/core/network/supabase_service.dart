import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://supppeaywogsioeurjmw.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN1cHBwZWF5d29nc2lvZXVyam13Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU4NzU0NTcsImV4cCI6MjA5MTQ1MTQ1N30.QyFt_8QwZIgTUz5odMq6rLkloYUUwQedsS7Ci3Dhh3I',
    );
  }

  final _supabase = Supabase.instance.client;

  // --- AUTH METHODS ---
  
  Future<AuthResponse> signUp(String email, String password, {String? pin}) async {
    final response = await _supabase.auth.signUp(email: email, password: password);
    if (response.user != null) {
      // 1. Create Profile with PIN
      await _supabase.from('profiles').upsert({'id': response.user!.id, 'parent_pin': pin ?? '0000'});
      
      // 2. Create Initial Child record
      await _supabase.from('children').insert({
        'parent_id': response.user!.id,
        'name_token': 'Child 1',
        'current_level': 'toddler',
      });
    }
    return response;
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? get currentUser => _supabase.auth.currentUser;

  // --- PROFILE & SECURITY ---

  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = currentUser;
    if (user == null) return null;
    return await _supabase.from('profiles').select().eq('id', user.id).maybeSingle();
  }

  Future<void> updateUserPin(String pin) async {
    final user = currentUser;
    if (user == null) return;
    await _supabase.from('profiles').upsert({'id': user.id, 'parent_pin': pin});
  }

  // --- CHILDREN & LEVEL SYNC ---

  Future<String?> getFirstChildId() async {
    final user = currentUser;
    if (user == null) return null;
    final data = await _supabase.from('children').select('id').eq('parent_id', user.id).maybeSingle();
    return data?['id'] as String?;
  }

  Stream<String> listenToChildLevel(String childId) {
    return _supabase
        .from('children')
        .stream(primaryKey: ['id'])
        .eq('id', childId)
        .map((data) => data.isEmpty ? 'toddler' : data.first['current_level'] as String);
  }

  Future<void> updateChildLevel(String childId, String level) async {
    await _supabase
        .from('children')
        .update({'current_level': level})
        .eq('id', childId);
  }

  // --- MILESTONES & MOOD ---

  Future<void> recordMilestone({
    required String childId,
    required String milestoneType, 
    required int score,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      await _supabase.from('milestones').insert({
        'child_id': childId,
        'type': milestoneType,
        'score': score,
        'metadata': metadata,
      });
    } catch (e) {
      print('Error recording milestone: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getMilestonesStream(String childId) {
    return _supabase
        .from('milestones')
        .stream(primaryKey: ['id'])
        .eq('child_id', childId)
        .order('created_at', ascending: false);
  }

  Future<List<Map<String, dynamic>>> getMilestonesFuture(String childId) async {
    try {
      final response = await _supabase
          .from('milestones')
          .select()
          .eq('child_id', childId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print('Error fetching milestones: $e');
      return [];
    }
  }
}
