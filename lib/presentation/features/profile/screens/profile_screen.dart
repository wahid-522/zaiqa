import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

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
        'title': 'Settings',
        'icon': Icons.settings_outlined,
        'isLogout': false,
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Settings feature coming soon!')),
          );
        },
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
                      user?.name.isNotEmpty == true ? user!.name : 'Alex Carter',
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
                          user?.phone.isNotEmpty == true ? user!.phone : '+1 (555) 123–4567',
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

              const SizedBox(height: 32),

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
                                // Left Icon in soft peach circle
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

                                // Title Text
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

                                // Right Chevron Arrow
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
}
