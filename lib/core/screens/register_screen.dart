import 'package:edumate/core/constants/images.dart';
import 'package:edumate/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:edumate/core/constants/sizes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  String email = '';
  String password = '';
  String confirmPassword = '';

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Keep a local copy of the typed password for cross-field validation
  String _passwordValue = '';

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Header ──────────────────────────────────────────────
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
                  const SizedBox(height: 8),
                  Text(
                    'Đăng ký',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tạo tài khoản để bắt đầu sử dụng ứng dụng',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // ── Form ─────────────────────────────────────────────────
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: ESizes.sm),

                    // Email
                    TextFormField(
                      focusNode: _emailFocus,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(ESizes.radiusMd),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Email không hợp lệ';
                        }
                        return null;
                      },
                      onSaved: (value) => email = value ?? '',
                    ),
                    const SizedBox(height: ESizes.sm),

                    // Password
                    TextFormField(
                      focusNode: _passwordFocus,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Mật khẩu',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(ESizes.radiusMd),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) => _passwordValue = value,
                      onFieldSubmitted: (_) {
                        FocusScope.of(
                          context,
                        ).requestFocus(_confirmPasswordFocus);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        if (value.length < 8) {
                          return 'Mật khẩu phải từ 8 ký tự';
                        }
                        return null;
                      },
                      onSaved: (value) => password = value ?? '',
                    ),
                    const SizedBox(height: ESizes.sm),

                    // Confirm Password
                    TextFormField(
                      focusNode: _confirmPasswordFocus,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Xác nhận mật khẩu',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(ESizes.radiusMd),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đăng ký thành công!'),
                            ),
                          );
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng xác nhận mật khẩu';
                        }
                        if (value != _passwordValue) {
                          return 'Mật khẩu xác nhận không khớp';
                        }
                        return null;
                      },
                      onSaved: (value) => confirmPassword = value ?? '',
                    ),
                    const SizedBox(height: ESizes.sm),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: ESizes.sm,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ESizes.radiusMd,
                            ),
                          ),
                          textStyle: context.text.titleMedium,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // TODO: Xử lý đăng ký
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đăng ký thành công!'),
                              ),
                            );
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                        child: const Text('Đăng ký'),
                      ),
                    ),

                    // Navigate to login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Đã có tài khoản? ',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                              color: colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ── Divider ─────────────────────────────────────
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ESizes.sm,
                          ),
                          child: Text(
                            'Hoặc đăng ký với',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: ESizes.md),
                    // ── Google button ────────────────────────────────
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
                        icon: Image.asset(
                          EImages.googleLogo,
                          height: 20,
                          width: 20,
                        ),
                        label: const Text('Đăng ký với Google'),
                        onPressed: () {
                          // TODO: Xử lý đăng ký Google
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
