import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../domain/entities/restaurant.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../../../data/models/restaurant_model.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../shared_providers.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<Restaurant?> _findOrFetchRestaurant(WidgetRef ref, UserProfile? user) async {
    if (user == null) return null;

    // 1. If user already has restaurantId, fetch it directly
    if (user.restaurantId != null && user.restaurantId!.isNotEmpty) {
      final res = await ref.read(getRestaurantDetailUseCaseProvider).execute(user.restaurantId!);
      Restaurant? found;
      res.when(success: (r) => found = r, failure: (_) {});
      if (found != null) return found;
    }

    // 2. Try candidate IDs (e.g. rest_uid, rest_spice_route for wahid)
    final candidateIds = [
      'rest_${user.id}',
      if (user.email.toLowerCase().contains('wahid') || user.name.toLowerCase().contains('wahid')) 'rest_spice_route',
    ];

    for (final candId in candidateIds) {
      final res = await ref.read(getRestaurantDetailUseCaseProvider).execute(candId);
      Restaurant? found;
      res.when(success: (r) => found = r, failure: (_) {});
      if (found != null) {
        try {
          await FirebaseFirestore.instance.collection('users').doc(user.id).update({
            'restaurantId': found!.id,
            'role': 'restaurantOwner',
          });
          ref.read(authViewModelProvider.notifier).updateCurrentUser(
                user.copyWith(restaurantId: found!.id, role: UserRole.restaurantOwner),
              );
        } catch (_) {}
        return found;
      }
    }

    // 3. Query Firestore 'restaurants' collection by ownerId == user.id
    try {
      final query = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('ownerId', isEqualTo: user.id)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final data = Map<String, dynamic>.from(query.docs.first.data());
        data['id'] = query.docs.first.id;
        final found = RestaurantModel.fromJson(data);
        try {
          await FirebaseFirestore.instance.collection('users').doc(user.id).update({
            'restaurantId': found.id,
            'role': 'restaurantOwner',
          });
          ref.read(authViewModelProvider.notifier).updateCurrentUser(
                user.copyWith(restaurantId: found.id, role: UserRole.restaurantOwner),
              );
        } catch (_) {}
        return found;
      }
    } catch (_) {}

    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModelProvider);
    final profileVM = ref.read(profileViewModelProvider.notifier);
    final user = profileState.user;

    if (profileState.isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFCF7F4),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: const [
                LoadingShimmer(width: 100, height: 100, borderRadius: 50),
                SizedBox(height: 16),
                LoadingShimmer(width: 180, height: 24, borderRadius: 12),
                SizedBox(height: 30),
                LoadingShimmer(width: double.infinity, height: 280, borderRadius: 20),
              ],
            ),
          ),
        ),
      );
    }

    final menuItems = [
      {
        'title': 'Saved Addresses',
        'icon': Icons.location_on_outlined,
        'isLogout': false,
        'onTap': () => context.push(RouteNames.savedAddressesPath),
      },
      {
        'title': 'Order History',
        'icon': Icons.history,
        'isLogout': false,
        'onTap': () => context.push('/orders'),
      },
      {
        'title': 'Favorites',
        'icon': Icons.favorite_border,
        'isLogout': false,
        'onTap': () => context.push('/favorites'),
      },
      {
        'title': 'Log Out',
        'icon': Icons.logout,
        'isLogout': true,
        'onTap': () async {
          await profileVM.logout();
          ref.read(authViewModelProvider.notifier).logout();
          if (context.mounted) {
            context.go(RouteNames.loginPath);
          }
        },
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFCF7F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),

              // Avatar & Edit Badge Stack
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 105,
                          height: 105,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=800&auto=format&fit=crop&q=80',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: const Color(0xFFFFF0EC),
                                child: Center(
                                  child: Text(
                                    user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'A',
                                    style: const TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFC63D00),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Edit Badge Button
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC63D00),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
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
                    const SizedBox(height: 16),

                    // User Name
                    Text(
                      user?.name.isNotEmpty == true ? user!.name : 'Customer User',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C221E),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Phone Number Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 15,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          user?.phone.isNotEmpty == true ? user!.phone : '+92 300 1234567',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Dynamic Restaurant Business & Registration Section
              FutureBuilder<Restaurant?>(
                future: _findOrFetchRestaurant(ref, user),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingShimmer(width: double.infinity, height: 90, borderRadius: 20);
                  }

                  final restaurant = snapshot.data;
                  if (restaurant == null) {
                    return _buildRegisterRestaurantCard(context);
                  }

                  return _buildRestaurantStatusSection(context, ref, restaurant);
                },
              ),

              const SizedBox(height: 24),

              // Menu Action List Card Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(menuItems.length, (index) {
                    final item = menuItems[index];
                    final title = item['title'] as String;
                    final icon = item['icon'] as IconData;
                    final isLogout = item['isLogout'] as bool;
                    final onTap = item['onTap'] as VoidCallback;
                    final isLast = index == menuItems.length - 1;

                    return Column(
                      children: [
                        InkWell(
                          onTap: onTap,
                          borderRadius: BorderRadius.vertical(
                            top: index == 0 ? const Radius.circular(20) : Radius.zero,
                            bottom: isLast ? const Radius.circular(20) : Radius.zero,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFF0EC),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    icon,
                                    size: 20,
                                    color: const Color(0xFFC63D00),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isLogout ? const Color(0xFFC63D00) : const Color(0xFF2C221E),
                                    ),
                                  ),
                                ),

                                Icon(
                                  Icons.chevron_right,
                                  size: 20,
                                  color: isLogout
                                      ? const Color(0xFFC63D00).withValues(alpha: 0.7)
                                      : Colors.grey.shade400,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!isLast)
                          Divider(
                            height: 1,
                            thickness: 0.8,
                            indent: 68,
                            endIndent: 16,
                            color: Colors.grey.shade100,
                          ),
                      ],
                    );
                  }),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Card for Customers who haven't registered a restaurant yet
  Widget _buildRegisterRestaurantCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RouteNames.restaurantOnboardingPath),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.storefront_rounded,
                size: 28,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Register Your Restaurant',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C221E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'List your kitchen on Zaiqa and accept orders',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dynamic Section for Users with an existing Restaurant (Pending, Approved, or Rejected)
  Widget _buildRestaurantStatusSection(BuildContext context, WidgetRef ref, Restaurant restaurant) {
    final status = restaurant.verificationStatus;

    if (status == 'pending') {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber.shade300),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.access_time_rounded, color: Colors.amber, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Restaurant Registration',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2C221E)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Pending Review',
                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your business documents are under verification.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (status == 'rejected') {
      return GestureDetector(
        onTap: () => context.push(RouteNames.restaurantOnboardingPath),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.red.shade300),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Action Required',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Resubmit Docs',
                            style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurant.verificationNote ?? 'Verification requires doc updates. Tap to re-upload.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Approved Restaurant Status Card (No direct portal navigation from Settings)
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_rounded, color: Colors.green, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2C221E)),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Approved Business',
                            style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            restaurant.address,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'To access your Restaurant Owner Portal, log out and sign in with your Restaurant Owner email & password on the login screen.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
          ),
        ],
      ),
    );
  }
}
