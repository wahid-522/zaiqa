import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../domain/entities/restaurant.dart';
import '../../../../shared/widgets/zaiqa_button.dart';
import '../../../../shared/widgets/zaiqa_text_field.dart';
import '../../../../shared/widgets/zaiqa_image_picker_tile.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../../shared_providers.dart';

class RestaurantOnboardingScreen extends ConsumerStatefulWidget {
  const RestaurantOnboardingScreen({super.key});

  @override
  ConsumerState<RestaurantOnboardingScreen> createState() => _RestaurantOnboardingScreenState();
}

class _RestaurantOnboardingScreenState extends ConsumerState<RestaurantOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cuisineController = TextEditingController();
  final _addressController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlController.text =
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&auto=format&fit=crop&q=80';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cuisineController.dispose();
    _addressController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _onSaveRestaurant() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final restaurantId = 'rest_owner_${DateTime.now().millisecondsSinceEpoch}';
      final cuisines = _cuisineController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final newRestaurant = Restaurant(
        id: restaurantId,
        name: _nameController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        rating: 5.0,
        reviewCount: 1,
        deliveryTime: '25-35 min',
        deliveryFee: 120.0,
        cuisineTypes: cuisines.isEmpty ? ['Italian', 'Gourmet'] : cuisines,
        address: _addressController.text.trim(),
        menu: const [],
      );

      final createResult = await ref.read(createRestaurantUseCaseProvider).execute(newRestaurant);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        createResult.when(
          success: (createdRest) {
            // Update auth state current user with restaurantId
            final currentUser = ref.read(authViewModelProvider).user;
            if (currentUser != null) {
              ref.read(authViewModelProvider.notifier).updateCurrentUser(
                    currentUser.copyWith(restaurantId: createdRest.id),
                  );
            }
            context.go(RouteNames.restaurantMenuManagementPath);
          },
          failure: (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to set up restaurant: ${failure.message}')),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF7F4),
        elevation: 0,
        title: Text(
          'Restaurant Profile Setup',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C221E),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Set up your restaurant',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFC63D00),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Enter your business details so customers can discover your menu.',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),

                ZaiqaTextField(
                  label: 'Restaurant Name',
                  hint: 'e.g. Bella Italia Bistro',
                  controller: _nameController,
                  prefixIcon: Icons.storefront_outlined,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Restaurant name is required' : null,
                ),
                const SizedBox(height: 16),

                ZaiqaTextField(
                  label: 'Cuisine Types (comma-separated)',
                  hint: 'e.g. Italian, Wood-fired Pizza, Pasta',
                  controller: _cuisineController,
                  prefixIcon: Icons.restaurant_menu_outlined,
                  validator: (val) => val == null || val.trim().isEmpty ? 'At least one cuisine required' : null,
                ),
                const SizedBox(height: 16),

                ZaiqaTextField(
                  label: 'Restaurant Address',
                  hint: 'e.g. Plot 14-C, Commercial Lane, Karachi',
                  controller: _addressController,
                  prefixIcon: Icons.location_on_outlined,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Address is required' : null,
                ),
                const SizedBox(height: 16),

                ZaiqaImagePickerTile(
                  label: 'Restaurant Banner Image',
                  initialImageUrl: _imageUrlController.text,
                  onImageSelected: (path) {
                    _imageUrlController.text = path;
                  },
                ),
                const SizedBox(height: 28),

                ZaiqaButton(
                  text: 'Save & Go to Menu Dashboard',
                  isLoading: _isLoading,
                  onPressed: _onSaveRestaurant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
