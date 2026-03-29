import 'package:edumate/core/constants/images.dart';
import 'package:edumate/core/config/app_config.dart';
import 'package:edumate/core/extensions/theme_extension.dart';
import 'package:edumate/core/constants/sizes.dart';
import 'package:edumate/data/repositories/auth_repository.dart';
import 'package:edumate/data/services/api_service.dart';
import 'package:edumate/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthRepository _authRepository = AuthRepository.create();
  late final GoogleSignIn _googleSignIn;
  bool _isGoogleSigningIn = false;

  bool get _canUseGoogleSignIn {
    if (!kIsWeb) {
      return true;
    }
    return AppConfig.googleWebClientId != null;
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(
      scopes: const <String>['email', 'profile'],
      clientId: kIsWeb ? AppConfig.googleWebClientId : null,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isGoogleSigningIn) {
      return;
    }

    setState(() {
      _isGoogleSigningIn = true;
    });

    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        return;
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw Exception('Google ID token is missing.');
      }

      final tokenResponse = await _authRepository.signInWithGoogle(idToken);
      ApiService().setBearerToken(tokenResponse.accessToken);

      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      if (!mounted) {
        return;
      }
      final message = e.toString();
      final normalized = message.toLowerCase();
      final isWebGoogleConfigIssue = kIsWeb &&
          (normalized.contains('signin') || normalized.contains('signln'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isWebGoogleConfigIssue
                ? 'Google Sign-In web is not configured correctly. Check GOOGLE_WEB_CLIENT_ID and Google OAuth Web setup.'
                : 'Google sign-in failed: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleSigningIn = false;
        });
      }
    }
  }

  void _handleTemporaryLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Temporary login enabled: opening Home screen.'),
      ),
    );
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: AssetImage(EImages.playStoreLogo),
                      height: 70,
                    ),
                  ),
                  Text(
                    'Đăng nhập',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Đăng nhập để tiếp tục sử dụng ứng dụng',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ESizes.lg),
              Text(
                _canUseGoogleSignIn
                    ? 'Chỉ hỗ trợ đăng nhập bằng Google'
                    : 'Chưa có GOOGLE_WEB_CLIENT_ID, đang dùng đăng nhập tạm để xem giao diện',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: ESizes.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: ESizes.sm,
                    ),
                    side: BorderSide(color: context.colors.outline),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ESizes.radiusMd,
                      ),
                    ),
                    textStyle: context.text.titleMedium,
                  ),
                  icon: _isGoogleSigningIn
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Image.asset(
                          EImages.googleLogo,
                          height: 20,
                          width: 20,
                        ),
                  label: Text(
                    _canUseGoogleSignIn
                        ? (_isGoogleSigningIn
                            ? 'Đang đăng nhập...'
                            : 'Đăng nhập với Google')
                        : 'Đăng nhập tạm thời',
                  ),
                  onPressed: _isGoogleSigningIn
                      ? null
                      : (_canUseGoogleSignIn
                          ? _handleGoogleSignIn
                          : _handleTemporaryLogin),
                ),
              ),
              const SizedBox(height: 12),

              /*
              Legacy login flows are temporarily disabled by requirement:
              - Email/password form
              - Register CTA
              Keep this block as reference while Google-only auth is active.
              */
            ],
          ),
        ),
      ),
    );
  }
}
