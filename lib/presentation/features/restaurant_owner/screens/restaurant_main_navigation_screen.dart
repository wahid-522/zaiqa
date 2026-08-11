import 'package:flutter/material.dart';
import '../../../../domain/entities/menu_item.dart';
import 'tabs/restaurant_add_item_tab.dart';
import 'tabs/restaurant_menu_tab.dart';
import 'tabs/restaurant_orders_tab.dart';
import 'tabs/restaurant_settings_tab.dart';

class RestaurantMainNavigationScreen extends StatefulWidget {
  const RestaurantMainNavigationScreen({super.key});

  @override
  State<RestaurantMainNavigationScreen> createState() => _RestaurantMainNavigationScreenState();
}

class _RestaurantMainNavigationScreenState extends State<RestaurantMainNavigationScreen> {
  int _selectedIndex = 0;
  MenuItem? _itemToEdit;

  void _onEditItem(MenuItem item) {
    setState(() {
      _itemToEdit = item;
      _selectedIndex = 1; // Switch to Add/Edit Item tab
    });
  }

  void _onItemSaved() {
    setState(() {
      _itemToEdit = null;
      _selectedIndex = 0; // Switch back to Menu tab
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      RestaurantMenuTab(
        onEditItem: _onEditItem,
      ),
      RestaurantAddItemTab(
        itemToEdit: _itemToEdit,
        onSaved: _onItemSaved,
      ),
      const RestaurantOrdersTab(),
      const RestaurantSettingsTab(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFCF7F4),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              if (index != 1) {
                _itemToEdit = null;
              }
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFC63D00),
          unselectedItemColor: const Color(0xFF756A63),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_outlined),
              activeIcon: Icon(Icons.restaurant_menu),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_rounded),
              activeIcon: Icon(Icons.add_circle_rounded),
              label: 'Add Item',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long_rounded),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
