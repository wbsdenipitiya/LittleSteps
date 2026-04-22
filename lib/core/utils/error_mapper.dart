import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorMapper {
  static String getFriendlyMessage(dynamic error) {
    if (error is AuthException) {
      switch (error.code) {
        case 'user_already_exists':
          return "You already have an account with this email! Try logging in instead.";
        case 'invalid_credentials':
          return "The email or password doesn't match. Lisa suggests checking them carefully and trying again!";
        case 'email_not_confirmed':
          return "Please check your inbox and confirm your email before logging in.";
        case 'network_error':
          return "Lisa is having trouble connecting to the cloud. Please check your Wifi or Mobile Data!";
        default:
          return "Lisa found a small hiccup: ${error.message}";
      }
    }

    final errString = error.toString().toLowerCase();
    if (errString.contains('socketexception') || errString.contains('network')) {
      return "It looks like you are offline. Lisa needs internet to sync your progress!";
    }
    
    if (errString.contains('422')) {
      return "This email is already in use. Try logging in!";
    }

    return "Oops! Lisa ran into a problem. Let's try that again in a moment.";
  }
}
