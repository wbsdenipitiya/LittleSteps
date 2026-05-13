import '../../../core/network/supabase_service.dart';

class AiService {
  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;
  AiService._internal();

  /// Generates a "Parental Insight" using AI (Simulated Grok/LLaMA logic) 
  /// based on recent child milestones and mood.
  Future<Map<String, String>> getParentInsight(String childId) async {
    final supabase = SupabaseService();
    final milestones = await supabase.getMilestonesStream(childId).first;
    
    if (milestones.isEmpty) {
      return {
        'title': 'Kickstart the Journey!',
        'content': 'Lisa is waiting! Let your child explore the "Feelings" module to help the AI understand their needs.',
      };
    }

    // Expert Logic: Analyze recent mood
    final lastMood = milestones.firstWhere((m) => m['type']?.startsWith('Mood') ?? false, orElse: () => {});
    final moodText = lastMood['type']?.split(':').last.trim().toLowerCase() ?? 'happy';

    if (moodText == 'grumpy') {
      return {
        'title': 'Grok Insight: Empathy Day',
        'content': 'Your kiddo has been feeling a bit grumpy. Try a "Safe Zone" story about sharing to help them navigate big emotions.',
      };
    }

    if (moodText == 'sleepy') {
      return {
        'title': 'AI Coach: Calm Routine',
        'content': 'Lisa suggests a quiet reading session in "My Books" before nap time to improve focus.',
      };
    }

    return {
      'title': 'Expert Progress: On Track!',
      'content': 'Daily activity is great! Your child is showing high cognitive focus in the Games area.',
    };
  }

  /// AI-suggested next curriculum target
  String getNextTarget(String currentLevel) {
    if (currentLevel == 'toddler') return 'Learn basic colors in My Books';
    if (currentLevel == 'explorer') return 'Advanced Safety in Safe Zone';
    return 'Creative Storytelling';
  }
}
final aiService = AiService();
