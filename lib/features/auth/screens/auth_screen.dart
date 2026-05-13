import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/network/supabase_service.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/widgets/mesh_background.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../core/services/emulator_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pinController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkEmulatorAndPreload();
  }

  Future<void> _checkEmulatorAndPreload() async {
    final isEmulator = await emulatorService.isEmulator();
    if (isEmulator && mounted) {
      setState(() {
        _emailController.text = "demo@littlesteps.com";
        _passwordController.text = "password123";
      });
    }
  }


  Future<void> _handleAuth() async {
    setState(() => _isLoading = true);
    
    final service = SupabaseService();
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final pin = _pinController.text.trim();

      if (email.isEmpty || password.isEmpty) throw "Please fill in all fields.";

      if (_isLogin) {
        await service.signIn(email, password);
      } else {
        if (pin.length != 4) throw "Please set a 4-digit Parent PIN.";
        await service.signUp(email, password, pin: pin);
      }
    } catch (e) {
      _showFriendlyError(ErrorMapper.getFriendlyMessage(e));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showFriendlyError(String error) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(32.r),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.r))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100.h,
              child: Lottie.network('https://assets9.lottiefiles.com/packages/lf20_myejioos.json'), 
            ),
            SizedBox(height: 16.h),
            Text("Lisa's Help", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppColors.textMain)),
            SizedBox(height: 12.h),
            Text(
              error, 
              textAlign: TextAlign.center, 
              style: TextStyle(fontSize: 15.sp, color: AppColors.textSecondary, height: 1.5)
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.azure,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Got it!", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MeshBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(32.r),
            child: Column(
              children: [
                FadeInDown(child: Icon(Icons.child_care_rounded, size: 80.sp, color: AppColors.azure)),
                SizedBox(height: 16.h),
                Text("LittleSteps", style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w900, color: AppColors.textMain)),
                SizedBox(height: 48.h),

                FloatingCard(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputField("Email", _emailController, "example@mail.com"),
                        SizedBox(height: 24.h),
                        _buildInputField("Password", _passwordController, "••••••••", obscure: true),
                        
                        if (!_isLogin) ...[
                          SizedBox(height: 24.h),
                          _buildInputField("Secret Parent PIN", _pinController, "1234", limit: 4),
                          Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text("Required to access your Parent Dashboard later.", style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                          ),
                        ],

                        SizedBox(height: 40.h),
                        
                        if (_isLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          SizedBox(
                            width: double.infinity,
                            height: 60.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.seafoam,
                                foregroundColor: AppColors.textMain,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                              ),
                              onPressed: _handleAuth,
                              child: Text(_isLogin ? "Login" : "Create Account", style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24.h),
                GestureDetector(
                  onTap: () => setState(() => _isLogin = !_isLogin),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
                      children: [
                        TextSpan(text: _isLogin ? "New parent? " : "Already have an account? "),
                        TextSpan(
                          text: _isLogin ? "Sign Up" : "Log In",
                          style: const TextStyle(color: AppColors.azure, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, String hint, {bool obscure = false, int? limit}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain, fontSize: 16.sp)),
        TextField(
          controller: controller,
          obscureText: obscure,
          maxLength: limit,
          style: const TextStyle(color: AppColors.textMain),
          decoration: InputDecoration(
            hintText: hint,
            counterText: "",
            hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.2))),
          ),
        ),
      ],
    );
  }
}
