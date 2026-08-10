import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routing/route_names.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  final List<Map<String, dynamic>> _favorites = [
    {
      'id': 'rest_kiku',
      'name': 'Kiku Japanese',
      'imageUrl': 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800&auto=format&fit=crop&q=80',
      'rating': 4.8,
      'cuisines': 'Sushi • Asian • Premium',
      'deliveryTime': '25–35 min',
      'deliveryFee': 'Free',
    },
    {
      'id': 'rest_nonna',
      'name': 'Nonna\'s Pizzeria',
      'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&auto=format&fit=crop&q=80',
      'rating': 4.9,
      'cuisines': 'Italian • Wood-fired • Casual',
      'deliveryTime': '30–45 min',
      'deliveryFee': 'Rs. 150',
    },
    {
      'id': 'rest_burger_forge',
      'name': 'Burger Forge',
      'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&auto=format&fit=crop&q=80',
      'rating': 4.6,
      'cuisines': 'American • Burgers • Comfort',
      'deliveryTime': '15–25 min',
      'deliveryFee': 'Free',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF7F4),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar Header with Logo & Avatar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notes_rounded, size: 26, color: Color(0xFF2C221E)),
                    onPressed: () {},
                  ),
                  Text(
                    'Zaiqa',
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFC63D00),
                      letterSpacing: -0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(RouteNames.profilePath),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5EBE6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        size: 22,
                        color: Color(0xFF2C221E),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Screen Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Favorites',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C221E),
                  ),
                ),
              ),
            ),

            // Favorites Restaurant Cards List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: _favorites.length,
                itemBuilder: (context, index) {
                  final item = _favorites[index];
                  final id = item['id'] as String;
                  final name = item['name'] as String;
                  final img = item['imageUrl'] as String;
                  final rating = item['rating'] as double;
                  final cuisines = item['cuisines'] as String;
                  final deliveryTime = item['deliveryTime'] as String;
                  final deliveryFee = item['deliveryFee'] as String;

                  return GestureDetector(
                    onTap: () => context.push('/restaurant/rest_spice_route'),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hero Header Image with Floating Favorite Heart Badge
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                child: Image.network(
                                  img,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    height: 180,
                                    color: const Color(0xFFFFF0EC),
                                    child: const Icon(Icons.restaurant, size: 48, color: Color(0xFFC63D00)),
                                  ),
                                ),
                              ),

                              // Floating Favorite Heart Button
                              Positioned(
                                top: 12,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _favorites.removeWhere((f) => f['id'] == id);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Color(0xFFC63D00),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Details Body Container
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title & Rating Pill Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2C221E),
                                        ),
                                      ),
                                    ),

                                    // Rating Pill
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFF0EC),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.star_rounded, color: Color(0xFFC63D00), size: 14),
                                          const SizedBox(width: 3),
                                          Text(
                                            rating.toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFC63D00),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                // Cuisines Subtitle
                                Text(
                                  cuisines,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Delivery Time & Fee Specs Row
                                Row(
                                  children: [
                                    Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade600),
                                    const SizedBox(width: 4),
                                    Text(
                                      deliveryTime,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Icon(Icons.local_shipping_outlined, size: 14, color: Colors.grey.shade600),
                                    const SizedBox(width: 4),
                                    Text(
                                      deliveryFee,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
