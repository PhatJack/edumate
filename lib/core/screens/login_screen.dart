import 'package:edumate/core/constants/images.dart';
import 'package:edumate/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:edumate/core/constants/sizes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  String email = '';
  String password = '';
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: ESizes.lg),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Email không hợp lệ';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      },
                      onSaved: (value) => email = value ?? '',
                    ),
                    const SizedBox(height: ESizes.sm),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        if (value.length < 8) {
                          return 'Mật khẩu phải từ 8 ký tự';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // TODO: Xử lý đăng nhập
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đăng nhập thành công!'),
                            ),
                          );
                        }
                      },
                      onSaved: (value) => password = value ?? '',
                    ),
                    const SizedBox(height: ESizes.sm),
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
                            // TODO: Xử lý đăng nhập
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đăng nhập thành công!'),
                              ),
                            );
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                        child: const Text('Đăng nhập'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chưa có tài khoản? ',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              '/register',
                            );
                          },
                          child: Text(
                            'Đăng ký',
                            style: TextStyle(
                              color: context.colors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ── Divider ─────────────────────────────────────
                    const SizedBox(height: ESizes.sm),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Hoặc đăng nhập với',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: context.colors.onSurfaceVariant,
                                ),
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
                        label: const Text('Đăng nhập với Google'),
                        onPressed: () {
                          // TODO: Xử lý đăng nhập Google
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
