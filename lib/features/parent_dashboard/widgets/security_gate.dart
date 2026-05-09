import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:async';
import '../../../core/services/security_service.dart';
import '../../../core/services/sound_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/emulator_service.dart';

class SecurityGate extends StatefulWidget {
  final VoidCallback onAuthenticated;
  const SecurityGate({super.key, required this.onAuthenticated});

  @override
  State<SecurityGate> createState() => _SecurityGateState();
}

class _SecurityGateState extends State<SecurityGate> {
  final _pinController = TextEditingController();
  final _security = SecurityService();
  bool _isBiometricAvailable = false;
  bool _needsPinSetup = false;
  bool _isLoading = true;
  bool _isSimulatingBiometric = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    try {
      // Direct check: No fake delays or errors
      final available = await _security.isBiometricAvailable();
      final profile = await _security.getProfile();
      
      if (mounted) {
        setState(() {
          _isBiometricAvailable = available;
          _needsPinSetup = profile == null || profile['parent_pin'] == null;
          _isLoading = false;
        });

        if (!_needsPinSetup && available) {
          _tryBiometric();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isBiometricAvailable = false;
          // Silently default to PIN if there is any issue
          _needsPinSetup = true; 
        });
      }
    }
  }

  Future<void> _tryBiometric() async {
    final isEmulator = await emulatorService.isEmulator();
    if (isEmulator && mounted) {
      setState(() {
        _isSimulatingBiometric = true;
        _errorMessage = "";
      });
    }

    try {
      final success = await _security.authenticateBiometric();
      if (success && mounted) {
        soundService.playSuccess();
        widget.onAuthenticated();
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() => _isSimulatingBiometric = false);
      }
    }
  }

  Future<void> _handlePrimaryAction() async {
    if (_pinController.text.length != 4) return;
    
    try {
      if (_needsPinSetup) {
        await _security.updatePin(_pinController.text);
        soundService.playSuccess();
        widget.onAuthenticated();
      } else {
        final success = await _security.validatePin(_pinController.text);
        if (success) {
          soundService.playSuccess();
          widget.onAuthenticated();
        } else {
          setState(() => _errorMessage = "Incorrect PIN.");
          _pinController.clear();
        }
      }
    } catch (e) {
      setState(() => _errorMessage = "Try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 250.h,
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.r))
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.azure),
        ),
      );
    }

    final themeColor = _needsPinSetup ? const Color(0xFFFFD700) : AppColors.azure; // Gold for Setup

    return Container(
      padding: EdgeInsets.all(32.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeInDown(
                child: Icon(
                  _needsPinSetup ? Icons.stars_rounded : Icons.lock_person_rounded, 
                  size: 60.sp, 
                  color: themeColor
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                _needsPinSetup ? "Create Your Secret PIN" : "Parental Verification",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: AppColors.textMain),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Text(
                  _needsPinSetup 
                    ? "Welcome! Lisa is helping you set a 4-digit code to keep the Dashboard safe."
                    : "Lisa needs your PIN to open the Command Hub.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
                ),
              ),
              SizedBox(height: 12.h),
              
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Text(_errorMessage, style: const TextStyle(color: AppColors.coral, fontWeight: FontWeight.bold)),
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 4; i++)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      width: 50.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBackground,
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: _pinController.text.length > i ? themeColor : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _pinController.text.length > i ? "●" : "",
                          style: TextStyle(fontSize: 24.sp, color: AppColors.textMain),
                        ),
                      ),
                    ),
                ],
              ),
              
              SizedBox(height: 24.h),
              
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 1.8,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (var i = 1; i <= 9; i++) _buildKey(i.toString(), themeColor),
                  if (_isBiometricAvailable && !_needsPinSetup)
                    IconButton(
                      icon: const Icon(Icons.fingerprint_rounded, size: 40, color: AppColors.azure),
                      onPressed: _tryBiometric,
                    )
                  else
                    const SizedBox(),
                  _buildKey("0", themeColor),
                  IconButton(
                    icon: const Icon(Icons.backspace_rounded, size: 30, color: AppColors.coral),
                    onPressed: () {
                      if (_pinController.text.isNotEmpty) {
                        setState(() => _pinController.text = _pinController.text.substring(0, _pinController.text.length - 1));
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          if (_isSimulatingBiometric)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ZoomIn(
                      child: Container(
                        padding: EdgeInsets.all(24.r),
                        decoration: BoxDecoration(
                          color: AppColors.azure.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Pulse(
                          infinite: true,
                          duration: const Duration(seconds: 1),
                          child: Icon(
                            Icons.fingerprint_rounded,
                            size: 80.sp,
                            color: AppColors.azure,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "Biometric Verification",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Simulating fingerprint sensor...",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildKey(String label, Color color) {
    return InkWell(
      onTap: () {
        soundService.playTap();
        if (_pinController.text.length < 4) {
          setState(() => _pinController.text += label);
          if (_pinController.text.length == 4) {
            _handlePrimaryAction();
          }
        }
      },
      borderRadius: BorderRadius.circular(20.r),
      child: Center(
        child: Text(
          label,
          style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold, color: AppColors.textMain),
        ),
      ),
    );
  }
}

