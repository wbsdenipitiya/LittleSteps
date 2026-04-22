import 'package:flutter/material.dart';

class AppColors {
  // --- HIGH-CONTRAST VIBRANT PALETTE ---
  // We use saturated colors for icons/buttons and "Deep Slate" for text.

  static const Color seafoam = Color(0xFF00DDAA);     // Vibrant Electric Seafoam (Passed 4.5:1 on dark text)
  static const Color azure = Color(0xFF2277FF);       // Bold Royal Azure
  static const Color coral = Color(0xFFFF6644);       // Saturated Sunset Coral
  static const Color gold = Color(0xFFFFCC00);        // High-Vis Gold
  
  // The "Dark Anchor" - Vital for Readability
  static const Color textMain = Color(0xFF112233);    // Deep Slate (High contrast for all labels)
  static const Color textSecondary = Color(0xFF445566); // Mid-Slate

  // Background Surfaces (Easy on eyes)
  static const Color primaryBackground = Color(0xFFF0F4F8); // Very soft grey-blue
  static const Color secondaryBackground = Colors.white;

  // Semantic Colors
  static const Color error = Color(0xFFFF4466);
  static const Color success = seafoam;

  // Gradients for Mesh
  static List<Color> get meshColors => [
    seafoam.withValues(alpha: 0.5),
    azure.withValues(alpha: 0.5),
    coral.withValues(alpha: 0.3),
  ];

  static const LinearGradient proGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [seafoam, azure],
  );
}
