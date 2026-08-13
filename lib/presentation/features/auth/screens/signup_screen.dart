import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../../../shared/widgets/zaiqa_button.dart';
import '../../../../shared/widgets/zaiqa_text_field.dart';
import '../viewmodels/auth_viewmodel.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignup() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await ref.read(authViewModelProvider.notifier).signup(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text.trim(),
            role: UserRole.customer,
          );

      if (success && mounted) {
        context.go(RouteNames.homePath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF7F4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2C221E)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(color: Color(0xFF2C221E), fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Join Zaiqa Today',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2C221E),
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Fill in your information to start ordering delicious food',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),

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
                  label: 'Full Name',
                  hint: 'e.g. Hamza Khan',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Full name is required';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                ZaiqaTextField(
                  label: 'Email Address',
                  hint: 'e.g. name@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Email is required';
                    if (!val.contains('@') || !val.contains('.')) return 'Enter a valid email address';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                ZaiqaTextField(
                  label: 'Phone Number',
                  hint: 'e.g. +92 300 1234567',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Phone number is required';
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
                const SizedBox(height: 16),

                ZaiqaTextField(
                  label: 'Confirm Password',
                  hint: '••••••••',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_clock_outlined,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Please confirm your password';
                    if (val != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                ZaiqaButton(
                  text: 'Create Account',
                  isLoading: authState.isLoading,
                  onPressed: _onSignup,
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: () => context.go(RouteNames.loginPath),
                      child: const Text(
                        'Sign In',
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
    );
  }
}
