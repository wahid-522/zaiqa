import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/routing/route_names.dart';
import '../../../auth/viewmodels/auth_viewmodel.dart';
import '../../viewmodels/menu_management_viewmodel.dart';

class RestaurantSettingsTab extends ConsumerWidget {
  const RestaurantSettingsTab({super.key});

  Widget _buildSettingsRow({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (iconColor ?? const Color(0xFFC63D00)).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor ?? const Color(0xFFC63D00),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? const Color(0xFF2C221E),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authViewModelProvider).user;
    final restaurant = ref.watch(menuManagementViewModelProvider).restaurant;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF7F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Mode Switch Banner: Back to Customer Ordering View
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF0EC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 22),
                  ),
                  title: const Text(
                    'Switch to Customer Mode',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2C221E)),
                  ),
                  subtitle: const Text(
                    'Browse restaurants and order food',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.primary),
                  onTap: () => context.go(RouteNames.homePath),
                ),
              ),

              const SizedBox(height: 16),

              // Restaurant Profile Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 42,
                          backgroundColor: const Color(0xFFFFF0EC),
                          backgroundImage: restaurant != null ? NetworkImage(restaurant.imageUrl) : null,
                          child: restaurant == null
                              ? const Icon(Icons.storefront_rounded, size: 42, color: Color(0xFFC63D00))
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFC63D00),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      restaurant?.name ?? user?.name ?? 'My Restaurant',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2C221E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurant?.address ?? 'Owner Account • ${user?.email ?? ''}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (restaurant != null) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0EC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          restaurant.cuisineTypes.join(' • '),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFC63D00),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Restaurant Settings Action Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSettingsRow(
                      icon: Icons.storefront_outlined,
                      title: 'Edit Restaurant Profile',
                      onTap: () => context.push(RouteNames.restaurantOnboardingPath),
                    ),
                    const Divider(height: 1, indent: 50),
                    _buildSettingsRow(
                      icon: Icons.rate_review_outlined,
                      title: 'Customer Food Reviews & Ratings',
                      onTap: () {
                        context.push(
                          RouteNames.viewReviewPath.replaceAll(':orderId', 'ZQ-90182'),
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 50),
                    _buildSettingsRow(
                      icon: Icons.help_outline_rounded,
                      title: 'Owner Support & FAQs',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Zaiqa Owner Support: support@zaiqa.app')),
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 50),
                    _buildSettingsRow(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Terms & Restaurant Partner Policy',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Logout Button Row Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: _buildSettingsRow(
                  icon: Icons.logout_rounded,
                  title: 'Log Out',
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () {
                    ref.read(authViewModelProvider.notifier).logout();
                    context.go(RouteNames.loginPath);
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
