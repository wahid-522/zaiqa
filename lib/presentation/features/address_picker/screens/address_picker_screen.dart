import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/zaiqa_button.dart';
import '../../../shared_providers.dart';
import '../viewmodels/address_picker_viewmodel.dart';

class AddressPickerScreen extends ConsumerStatefulWidget {
  const AddressPickerScreen({super.key});

  @override
  ConsumerState<AddressPickerScreen> createState() => _AddressPickerScreenState();
}

class _AddressPickerScreenState extends ConsumerState<AddressPickerScreen> {
  GoogleMapController? _mapController;
  LatLng _cameraPosition = const LatLng(24.8607, 67.0011);

  static const LatLng _restaurantLoc = AddressPickerViewModel.defaultRestaurantLoc;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addressPickerViewModelProvider);
    final viewModel = ref.read(addressPickerViewModelProvider.notifier);

    final Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('restaurant'),
        position: _restaurantLoc,
        infoWindow: const InfoWindow(title: 'Zaiqa Partner Restaurant'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
      Marker(
        markerId: const MarkerId('delivery_destination'),
        position: state.selectedPosition,
        infoWindow: InfoWindow(title: 'Delivery Address', snippet: state.currentAddress.formattedAddress),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    final Set<Polyline> polylines = {};
    if (state.route != null && state.route!.polylinePoints.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('delivery_route'),
          color: AppColors.primary,
          width: 5,
          points: state.route!.polylinePoints
              .map((p) => LatLng(p.latitude, p.longitude))
              .toList(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Delivery Location'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: state.selectedPosition,
              zoom: 14.5,
            ),
            markers: markers,
            polylines: polylines,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onCameraMove: (position) {
              _cameraPosition = position.target;
            },
            onCameraIdle: () {
              viewModel.onCameraIdle(_cameraPosition, _restaurantLoc);
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          // Center Pin Indicator
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Move map to adjust pin',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Icon(
                    Icons.location_on,
                    size: 42,
                    color: AppColors.primaryDark,
                  ),
                ],
              ),
            ),
          ),

          // My Location Button
          Positioned(
            right: 16,
            bottom: 220,
            child: FloatingActionButton.small(
              heroTag: 'my_location_fab',
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryDark,
              onPressed: () async {
                final userPos = await viewModel.fetchCurrentGPSLocation();
                if (userPos != null && _mapController != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(userPos, 15.5),
                  );
                }
              },
              child: const Icon(Icons.my_location),
            ),
          ),

          // Bottom Address & Route Info Sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.location_on, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.currentAddress.street.isNotEmpty
                                    ? state.currentAddress.street
                                    : 'Selected Location',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                state.isLoading
                                    ? 'Updating address...'
                                    : state.currentAddress.formattedAddress,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Distance & Directions API Route Badge
                    if (state.route != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.route, size: 18, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(
                                  'Distance: ${state.route!.distanceText}',
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                              ],
                            ),
                            Container(height: 16, width: 1, color: Colors.grey.shade300),
                            Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 18, color: AppColors.secondary),
                                const SizedBox(width: 6),
                                Text(
                                  'Est. Delivery: ${state.route!.durationText}',
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 16),

                    ZaiqaButton(
                      text: 'Confirm Delivery Location',
                      isLoading: state.isLoading,
                      onPressed: () {
                        context.pop(state.currentAddress);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
