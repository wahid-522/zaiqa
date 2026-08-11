import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../shared/widgets/zaiqa_button.dart';
import '../../../../shared/widgets/zaiqa_text_field.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'hamza@zaiqa.app');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await ref.read(authViewModelProvider.notifier).login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      if (success && mounted) {
        final currentUser = ref.read(authViewModelProvider).user;
        if (currentUser?.isRestaurantOwner ?? false) {
          context.go(RouteNames.restaurantMenuManagementPath);
        } else {
          context.go(RouteNames.homePath);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF7F4),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Brand Logo & Name
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'ذ',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 32,
                          color: AppColors.primary,
                        ),
                  ),
                  Text(
                    AppConstants.appTagline,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 28),

                  // Quick Account Role Switch Demo Chips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        avatar: const Icon(Icons.person_outline, size: 16, color: Color(0xFFC63D00)),
                        label: const Text('Customer Demo'),
                        selected: !_emailController.text.toLowerCase().contains('owner') &&
                            !_emailController.text.toLowerCase().contains('restaurant'),
                        selectedColor: const Color(0xFFFFF0EC),
                        backgroundColor: Colors.white,
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _emailController.text = 'hamza@zaiqa.app';
                              _passwordController.text = 'password123';
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        avatar: const Icon(Icons.storefront_outlined, size: 16, color: Color(0xFFC63D00)),
                        label: const Text('Restaurant Owner Demo'),
                        selected: _emailController.text.toLowerCase().contains('owner') ||
                            _emailController.text.toLowerCase().contains('restaurant'),
                        selectedColor: const Color(0xFFFFF0EC),
                        backgroundColor: Colors.white,
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _emailController.text = 'owner@zaiqa.app';
                              _passwordController.text = 'password123';
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Error Banner
                  if (authState.errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Text(
                        authState.errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  ZaiqaTextField(
                    label: 'Email Address',
                    hint: 'enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Email is required';
                      if (!val.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  ZaiqaTextField(
                    label: 'Password',
                    hint: '••••••••',
                    controller: _passwordController,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                    validator: (val) {
                      if (val == null || val.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  ZaiqaButton(
                    text: 'Sign In',
                    isLoading: authState.isLoading,
                    onPressed: _onLogin,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () => context.push(RouteNames.signupPath),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
