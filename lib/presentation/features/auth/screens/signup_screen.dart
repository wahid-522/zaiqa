import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  UserRole _selectedRole = UserRole.customer;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignup() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await ref.read(authViewModelProvider.notifier).signup(
            name: _nameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            password: _passwordController.text,
            role: _selectedRole,
          );
      if (success && mounted) {
        if (_selectedRole == UserRole.restaurantOwner) {
          context.go(RouteNames.restaurantOnboardingPath);
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
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF7F4),
        elevation: 0,
        title: const Text('Create Account'),
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
                  'Join Zaiqa today',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2C221E),
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Select your account type to get started',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),

                // Account Type / Role Segmented Selector
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRole = UserRole.customer;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedRole == UserRole.customer
                                  ? const Color(0xFFC63D00)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_outline_rounded,
                                  size: 18,
                                  color: _selectedRole == UserRole.customer
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Customer',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedRole == UserRole.customer
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRole = UserRole.restaurantOwner;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedRole == UserRole.restaurantOwner
                                  ? const Color(0xFFC63D00)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.storefront_rounded,
                                  size: 18,
                                  color: _selectedRole == UserRole.restaurantOwner
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Restaurant',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedRole == UserRole.restaurantOwner
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                if (authState.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
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
                  hint: _selectedRole == UserRole.restaurantOwner ? 'e.g. Chef Marco / Owner' : 'e.g. Hamza Khan',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 14),

                ZaiqaTextField(
                  label: 'Email Address',
                  hint: 'name@domain.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (val) => val == null || !val.contains('@') ? 'Valid email required' : null,
                ),
                const SizedBox(height: 14),

                ZaiqaTextField(
                  label: 'Phone Number',
                  hint: '+92 300 1234567',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Phone number required' : null,
                ),
                const SizedBox(height: 14),

                ZaiqaTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (val) => val == null || val.length < 6 ? 'Min 6 characters' : null,
                ),
                const SizedBox(height: 24),

                ZaiqaButton(
                  text: _selectedRole == UserRole.restaurantOwner ? 'Continue to Restaurant Setup' : 'Create Account',
                  isLoading: authState.isLoading,
                  onPressed: _onSignup,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
