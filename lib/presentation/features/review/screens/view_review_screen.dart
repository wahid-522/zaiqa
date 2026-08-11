import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../domain/entities/review.dart';
import '../../../shared_providers.dart';

final orderReviewProvider = FutureProvider.autoDispose.family<Review?, String>((ref, orderId) async {
  final useCase = ref.watch(getReviewForOrderUseCaseProvider);
  final result = await useCase.execute(orderId);
  return result.when(
    success: (review) => review,
    failure: (_) => null,
  );
});

class ViewReviewScreen extends ConsumerWidget {
  final String orderId;
  final String restaurantName;
  final String imageUrl;
  final String dateStr;

  const ViewReviewScreen({
    super.key,
    required this.orderId,
    this.restaurantName = 'The Spice Route',
    this.imageUrl = 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800&auto=format&fit=crop&q=80',
    this.dateStr = 'Today, 2:15 PM',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewAsync = ref.watch(orderReviewProvider(orderId));

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
          'Customer Review',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C221E),
          ),
        ),
      ),
      body: SafeArea(
        child: reviewAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFC63D00))),
          error: (err, stack) => Center(child: Text('Failed to load review: $err')),
          data: (review) {
            final rating = review?.rating ?? 5;
            final comment = review?.comment ??
                '"Absolutely phenomenal! The chicken tikka masala was piping hot, fragrant, and perfectly spiced. Packaging was intact and delivery was super quick. Will definitely order again!"';
            final photoUrl = (review?.photoUrls.isNotEmpty ?? false)
                ? review!.photoUrls.first
                : 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=800&auto=format&fit=crop&q=80';

            return Column(
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
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 90,
                                height: 90,
                                color: const Color(0xFFFFF0EC),
                                child: const Icon(Icons.restaurant, color: Color(0xFFC63D00), size: 44),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Restaurant Name & Reviewer Name
                        Text(
                          restaurantName,
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2C221E),
                          ),
                        ),

                        if (review != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Reviewed by ${review.userName}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],

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

                        const SizedBox(height: 18),

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
                            rating >= 4 ? 'Excellent Experience' : 'Customer Feedback',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8D4B38),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Review Quote Card Container
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
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
                                  comment,
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

                        // Customer Attached Food Photo Card Section
                        if (photoUrl.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.photo_camera_outlined, size: 18, color: Color(0xFFC63D00)),
                                    SizedBox(width: 8),
                                    Text(
                                      'Customer Food Photo',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2C221E),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.network(
                                    photoUrl,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      height: 120,
                                      color: const Color(0xFFFFF0EC),
                                      child: const Center(
                                        child: Icon(Icons.fastfood, color: Color(0xFFC63D00), size: 36),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
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
            );
          },
        ),
      ),
    );
  }
}
