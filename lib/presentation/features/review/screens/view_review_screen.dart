import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewReviewScreen extends ConsumerWidget {
  final String orderId;
  final String restaurantName;
  final String imageUrl;
  final String dateStr;
  final int rating;
  final String experienceTag;
  final String reviewText;

  const ViewReviewScreen({
    super.key,
    required this.orderId,
    this.restaurantName = 'Osteria Morini',
    this.imageUrl = 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&auto=format&fit=crop&q=80',
    this.dateStr = 'Oct 24, 2023',
    this.rating = 5,
    this.experienceTag = 'Excellent Experience',
    this.reviewText =
        '"Absolutely phenomenal. The pasta was perfectly al dente, and the truffle cream sauce was rich without being overwhelming. Packaging kept everything piping hot. This has quickly become my go-to spot for a comforting, high-quality dinner at home."',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF7F4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2C221E)),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'Your Review',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C221E),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Restaurant Circular Image Header
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 16,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 100,
                            height: 100,
                            color: const Color(0xFFFFF0EC),
                            child: const Icon(Icons.restaurant, color: Color(0xFFC63D00), size: 44),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Restaurant Name
                    Text(
                      restaurantName,
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2C221E),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Delivery Date Subtitle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey.shade600),
                        const SizedBox(width: 5),
                        Text(
                          'Delivered on $dateStr',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 5 Filled Rating Stars Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Icon(
                            index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                            size: 28,
                            color: const Color(0xFFC63D00),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 10),

                    // Experience Tag Pill Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0EC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        experienceTag,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8D4B38),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Review Quote Card Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Soft Peach Quote Mark Watermark Background
                          Positioned(
                            top: -10,
                            left: -4,
                            child: Text(
                              '“',
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFFF0EC),
                                fontFamily: GoogleFonts.outfit().fontFamily,
                              ),
                            ),
                          ),

                          // Review Text Content
                          Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Text(
                              reviewText,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Color(0xFF2C221E),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Close Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFFCF7F4),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB33600),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => context.pop(),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
