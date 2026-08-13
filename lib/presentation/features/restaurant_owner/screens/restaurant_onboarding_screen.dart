import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../domain/entities/restaurant.dart';
import '../../../../shared/widgets/zaiqa_button.dart';
import '../../../../shared/widgets/zaiqa_text_field.dart';
import '../../../../shared/widgets/zaiqa_image_picker_tile.dart';
import '../../../../shared/widgets/zaiqa_multi_image_picker.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../../shared_providers.dart';

class RestaurantOnboardingScreen extends ConsumerStatefulWidget {
  const RestaurantOnboardingScreen({super.key});

  @override
  ConsumerState<RestaurantOnboardingScreen> createState() => _RestaurantOnboardingScreenState();
}

class _RestaurantOnboardingScreenState extends ConsumerState<RestaurantOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Basic Information
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _imageUrlController = TextEditingController();

  // Owner Credentials
  final _ownerEmailController = TextEditingController();
  final _ownerPasswordController = TextEditingController();

  // Verification Documents
  final _licenseUrlController = TextEditingController();
  final _premisesDocUrlController = TextEditingController();
  String _premisesType = 'owned'; // 'owned' | 'rented'
  List<String> _restaurantPhotos = [];
  List<String> _menuPhotos = [];

  bool _isLoading = false;

  final List<String> _availableCategories = const [
    'Pakistani',
    'Fast Food',
    'Italian',
    'Chinese',
    'Barbecue',
    'Burgers',
    'Desserts',
    'Beverages',
    'Gourmet',
  ];

  final Set<String> _selectedCuisines = {'Pakistani'};

  @override
  void initState() {
    super.initState();
    _imageUrlController.text =
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&auto=format&fit=crop&q=80';
    _licenseUrlController.text =
        'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=800&auto=format&fit=crop&q=80';
    _premisesDocUrlController.text =
        'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=800&auto=format&fit=crop&q=80';
    _restaurantPhotos = [
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&auto=format&fit=crop&q=80'
    ];
    _menuPhotos = [
      'https://images.unsplash.com/photo-1541544741938-0af808871cc0?w=800&auto=format&fit=crop&q=80'
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _imageUrlController.dispose();
    _ownerEmailController.dispose();
    _ownerPasswordController.dispose();
    _licenseUrlController.dispose();
    _premisesDocUrlController.dispose();
    super.dispose();
  }

  void _onSaveRestaurant() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedCuisines.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one Food Category')),
        );
        return;
      }

      if (_ownerEmailController.text.trim().isEmpty || !_ownerEmailController.text.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A valid Restaurant Owner login email is required')),
        );
        return;
      }

      if (_ownerPasswordController.text.trim().length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Owner login password must be at least 6 characters')),
        );
        return;
      }

      if (_licenseUrlController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Government Business License / Food Authority Approval is required')),
        );
        return;
      }

      if (_premisesDocUrlController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Proof of Premises (${_premisesType == 'owned' ? 'Ownership Document' : 'Rental Agreement'}) is required')),
        );
        return;
      }

      if (_restaurantPhotos.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('At least 1 photo of restaurant premises is required')),
        );
        return;
      }

      if (_menuPhotos.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('At least 1 photo of your physical menu is required')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final currentUser = ref.read(authViewModelProvider).user;
      final restaurantId = 'rest_${currentUser?.id ?? DateTime.now().millisecondsSinceEpoch}';
      final ownerEmail = _ownerEmailController.text.trim();
      final ownerPassword = _ownerPasswordController.text.trim();

      final newRestaurant = Restaurant(
        id: restaurantId,
        ownerId: currentUser?.id,
        ownerEmail: ownerEmail,
        name: _nameController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        rating: 5.0,
        reviewCount: 1,
        deliveryTime: '25-35 min',
        deliveryFee: 120.0,
        cuisineTypes: _selectedCuisines.toList(),
        address: _addressController.text.trim(),
        menu: const [],
        verificationStatus: 'pending',
        verificationDocumentUrl: _licenseUrlController.text.trim(),
        premisesType: _premisesType,
        premisesDocumentUrl: _premisesDocUrlController.text.trim(),
        restaurantPhotoUrls: _restaurantPhotos,
        menuPhotoUrls: _menuPhotos,
        verificationSubmittedAt: DateTime.now(),
      );

      final createResult = await ref.read(createRestaurantUseCaseProvider).execute(newRestaurant);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        createResult.when(
          success: (createdRest) async {
            // Save restaurant owner credentials & link to user doc in Firestore
            try {
              if (currentUser != null) {
                await FirebaseFirestore.instance.collection('users').doc(currentUser.id).update({
                  'restaurantId': createdRest.id,
                  'ownerEmail': ownerEmail,
                  'ownerPassword': ownerPassword,
                });
              }

              // Also store in owner_credentials collection for lookup
              await FirebaseFirestore.instance.collection('owner_credentials').doc(ownerEmail.toLowerCase()).set({
                'restaurantId': createdRest.id,
                'email': ownerEmail,
                'password': ownerPassword,
                'createdAt': FieldValue.serverTimestamp(),
              });
            } catch (_) {}

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Restaurant registration submitted! Review pending. Use your registered Owner Email & Password to log into the Owner Portal.'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 4),
                ),
              );
              context.go(RouteNames.profilePath);
            }
          },
          failure: (failure) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to submit restaurant: ${failure.message}')),
              );
            }
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2C221E)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Register Your Restaurant',
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
                  'Basic Information',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFC63D00),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enter your restaurant name, address, and category details.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),

                ZaiqaTextField(
                  label: 'Restaurant Name',
                  hint: 'e.g. Spice Route Biryani House',
                  controller: _nameController,
                  prefixIcon: Icons.storefront_outlined,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Restaurant name is required' : null,
                ),
                const SizedBox(height: 16),

                // Multi-select Food Categories / Cuisine Types
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Food Category / Cuisine Types',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2C221E)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Select categories that apply to your restaurant',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableCategories.map((cat) {
                        final isSelected = _selectedCuisines.contains(cat);
                        return FilterChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: const Color(0xFFFFF0EC),
                          checkmarkColor: AppColors.primary,
                          labelStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.primary : const Color(0xFF2C221E),
                          ),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : Colors.grey.shade300,
                            ),
                          ),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedCuisines.add(cat);
                              } else {
                                if (_selectedCuisines.length > 1) {
                                  _selectedCuisines.remove(cat);
                                }
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
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
                  label: 'Restaurant Banner Cover Image',
                  initialImageUrl: _imageUrlController.text,
                  onImageSelected: (path) {
                    _imageUrlController.text = path;
                  },
                ),
                const SizedBox(height: 28),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 24),

                // Restaurant Owner Sign-In Credentials Section
                Text(
                  'Restaurant Owner Login Credentials',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFC63D00),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Set the email & password you will use to sign into your Restaurant Portal.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),

                ZaiqaTextField(
                  label: 'Owner Login Email',
                  hint: 'owner@myrestaurant.com',
                  controller: _ownerEmailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Owner login email is required';
                    if (!val.contains('@')) return 'Enter a valid email address';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                ZaiqaTextField(
                  label: 'Owner Login Password',
                  hint: '••••••••',
                  controller: _ownerPasswordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (val) {
                    if (val == null || val.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 24),

                // Expanded Verification Section
                Text(
                  'Verification Documents',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFC63D00),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Required documents to verify your business before accepting orders.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),

                // 1. Business License Upload
                ZaiqaImagePickerTile(
                  label: '1. Government Business License / Food Authority Approval',
                  initialImageUrl: _licenseUrlController.text,
                  onImageSelected: (path) {
                    _licenseUrlController.text = path;
                  },
                ),
                const SizedBox(height: 20),

                // 2. Proof of Premises Selection & Upload
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '2. Proof of Premises Requirement',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2C221E)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Property Owner')),
                            selected: _premisesType == 'owned',
                            selectedColor: const Color(0xFFFFF0EC),
                            labelStyle: TextStyle(
                              fontWeight: _premisesType == 'owned' ? FontWeight.bold : FontWeight.normal,
                              color: _premisesType == 'owned' ? AppColors.primary : const Color(0xFF2C221E),
                            ),
                            onSelected: (selected) {
                              if (selected) setState(() => _premisesType = 'owned');
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Rented Property')),
                            selected: _premisesType == 'rented',
                            selectedColor: const Color(0xFFFFF0EC),
                            labelStyle: TextStyle(
                              fontWeight: _premisesType == 'rented' ? FontWeight.bold : FontWeight.normal,
                              color: _premisesType == 'rented' ? AppColors.primary : const Color(0xFF2C221E),
                            ),
                            onSelected: (selected) {
                              if (selected) setState(() => _premisesType = 'rented');
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ZaiqaImagePickerTile(
                      label: _premisesType == 'owned'
                          ? 'Upload Property Ownership Document / Title Deed'
                          : 'Upload Rental / Lease Agreement',
                      initialImageUrl: _premisesDocUrlController.text,
                      onImageSelected: (path) {
                        _premisesDocUrlController.text = path;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 3. Restaurant Premises Photos Upload
                ZaiqaMultiImagePicker(
                  label: '3. Restaurant Premises Photos',
                  sublabel: 'Upload 1 to 5 clear photos of your dining/kitchen premises',
                  minImages: 1,
                  maxImages: 5,
                  initialImageUrls: _restaurantPhotos,
                  onChanged: (photos) {
                    setState(() {
                      _restaurantPhotos = photos;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // 4. Physical Menu Photos Upload
                ZaiqaMultiImagePicker(
                  label: '4. Physical Printed Menu Photos',
                  sublabel: 'Upload 1 to 10 photos of your physical printed menu',
                  minImages: 1,
                  maxImages: 10,
                  initialImageUrls: _menuPhotos,
                  onChanged: (photos) {
                    setState(() {
                      _menuPhotos = photos;
                    });
                  },
                ),
                const SizedBox(height: 32),

                ZaiqaButton(
                  text: 'Submit Restaurant Application',
                  isLoading: _isLoading,
                  onPressed: _onSaveRestaurant,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
