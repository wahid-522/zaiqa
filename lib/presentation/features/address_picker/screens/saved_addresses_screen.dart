import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final List<Map<String, dynamic>> _addresses = [
    {
      'id': 'addr_1',
      'label': 'Home',
      'isDefault': true,
      'address': '123 Culinary Avenue, Apt 4B, Flavor District, FD 10023',
      'note': 'Note: Leave at front desk',
      'icon': Icons.home,
    },
    {
      'id': 'addr_2',
      'label': 'Work',
      'isDefault': false,
      'address': '456 Corporate Blvd, Suite 200, Business Park, BP 90210',
      'note': null,
      'icon': Icons.work_outlined,
    },
    {
      'id': 'addr_3',
      'label': 'Sarah\'s House',
      'isDefault': false,
      'address': '789 Pine Street, Suburban Oasis, SO 54321',
      'note': null,
      'icon': Icons.location_on_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF7F4),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back, color: Color(0xFF2C221E), size: 24),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Saved Addresses',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFC63D00),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24), // Balance left arrow
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  children: [
                    ..._addresses.map((item) {
                      final id = item['id'] as String;
                      final label = item['label'] as String;
                      final isDefault = item['isDefault'] as bool;
                      final addressStr = item['address'] as String;
                      final noteStr = item['note'] as String?;
                      final icon = item['icon'] as IconData;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Icon Circle
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFF0EC),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                icon,
                                size: 22,
                                color: const Color(0xFF2C221E),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Address Details Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        label,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2C221E),
                                        ),
                                      ),
                                      if (isDefault) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF0EC),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'DEFAULT',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFC63D00),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    addressStr,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                      height: 1.3,
                                    ),
                                  ),
                                  if (noteStr != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      noteStr,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // Action Icons Column
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.push('/address-picker');
                                  },
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                    color: Color(0xFF2C221E),
                                  ),
                                ),
                                if (!isDefault) ...[
                                  const SizedBox(height: 14),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _addresses.removeWhere((a) => a['id'] == id);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.delete_outline,
                                      size: 18,
                                      color: Color(0xFFD32F2F),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Add New Address Button Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC63D00),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => context.push('/address-picker'),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'Add New Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
