import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../../../shared/widgets/zaiqa_button.dart';
import '../../../../shared/widgets/zaiqa_text_field.dart';
import '../viewmodels/auth_viewmodel.dart';

enum LoginMode { customer, restaurantOwner }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  LoginMode _selectedMode = LoginMode.customer;

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
            role: _selectedMode == LoginMode.restaurantOwner ? UserRole.restaurantOwner : UserRole.customer,
          );

      if (success && mounted) {
        final currentUser = ref.read(authViewModelProvider).user;

        if (_selectedMode == LoginMode.restaurantOwner || (currentUser?.isRestaurantOwner ?? false)) {
          String? restId = currentUser?.restaurantId;

          // Auto-discover restaurant ID from Firestore if missing
          if ((restId == null || restId.isEmpty) && currentUser != null) {
            try {
              final emailInput = _emailController.text.trim();
              
              // 1. Query restaurants by ownerEmail
              final emailQuery = await FirebaseFirestore.instance
                  .collection('restaurants')
                  .where('ownerEmail', isEqualTo: emailInput)
                  .limit(1)
                  .get();

              if (emailQuery.docs.isNotEmpty) {
                restId = emailQuery.docs.first.id;
              } else {
                // 2. Query restaurants by ownerId
                final idQuery = await FirebaseFirestore.instance
                    .collection('restaurants')
                    .where('ownerId', isEqualTo: currentUser.id)
                    .limit(1)
                    .get();
                if (idQuery.docs.isNotEmpty) {
                  restId = idQuery.docs.first.id;
                }
              }

              if (restId != null && restId.isNotEmpty) {
                await FirebaseFirestore.instance.collection('users').doc(currentUser.id).update({
                  'restaurantId': restId,
                  'role': 'restaurantOwner',
                });
                ref.read(authViewModelProvider.notifier).updateCurrentUser(
                      currentUser.copyWith(restaurantId: restId, role: UserRole.restaurantOwner),
                    );
              }
            } catch (_) {}
          }

          if (mounted) {
            if (restId != null && restId.isNotEmpty) {
              context.go(RouteNames.restaurantMenuManagementPath);
            } else {
              context.go(RouteNames.restaurantOnboardingPath);
            }
          }
        } else {
          if (mounted) {
            context.go(RouteNames.homePath);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final isOwnerMode = _selectedMode == LoginMode.restaurantOwner;

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
                  const SizedBox(height: 24),

                  // Portal Selection Switcher (Customer vs Restaurant Owner)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedMode = LoginMode.customer;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !isOwnerMode ? AppColors.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 18,
                                    color: !isOwnerMode ? Colors.white : Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Customer Login',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: !isOwnerMode ? Colors.white : Colors.grey.shade700,
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
                                _selectedMode = LoginMode.restaurantOwner;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isOwnerMode ? AppColors.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.storefront_rounded,
                                    size: 18,
                                    color: isOwnerMode ? Colors.white : Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Restaurant Owner',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: isOwnerMode ? Colors.white : Colors.grey.shade700,
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
                  const SizedBox(height: 24),

                  // Header Badge for Selected Mode
                  if (isOwnerMode)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0EC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Restaurant Partner Sign In',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2C221E)),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Sign in with your email/password to manage menu & orders',
                                  style: TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

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
                    label: isOwnerMode ? 'Restaurant Owner Email' : 'Email Address',
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
                    text: isOwnerMode ? 'Sign In to Restaurant Portal' : 'Sign In',
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
