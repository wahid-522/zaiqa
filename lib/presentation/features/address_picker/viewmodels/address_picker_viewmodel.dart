import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../domain/entities/delivery_address.dart';
import '../../../../domain/entities/delivery_route.dart';
import '../../../../domain/repositories/directions_repository.dart';

class AddressPickerState {
  final LatLng selectedPosition;
  final DeliveryAddress currentAddress;
  final DeliveryRoute? route;
  final bool isLoading;
  final bool isRouteLoading;
  final String? errorMessage;

  const AddressPickerState({
    required this.selectedPosition,
    required this.currentAddress,
    this.route,
    this.isLoading = false,
    this.isRouteLoading = false,
    this.errorMessage,
  });

  AddressPickerState copyWith({
    LatLng? selectedPosition,
    DeliveryAddress? currentAddress,
    DeliveryRoute? route,
    bool? isLoading,
    bool? isRouteLoading,
    String? errorMessage,
  }) {
    return AddressPickerState(
      selectedPosition: selectedPosition ?? this.selectedPosition,
      currentAddress: currentAddress ?? this.currentAddress,
      route: route ?? this.route,
      isLoading: isLoading ?? this.isLoading,
      isRouteLoading: isRouteLoading ?? this.isRouteLoading,
      errorMessage: errorMessage,
    );
  }
}

class AddressPickerViewModel extends StateNotifier<AddressPickerState> {
  final DirectionsRepository directionsRepository;
  static const LatLng defaultRestaurantLoc = LatLng(24.8719, 67.0593); // Gulshan-e-Iqbal

  AddressPickerViewModel({
    required this.directionsRepository,
    LatLng? initialPos,
  }) : super(
          AddressPickerState(
            selectedPosition: initialPos ?? const LatLng(24.8607, 67.0011),
            currentAddress: DeliveryAddress(
              latitude: initialPos?.latitude ?? 24.8607,
              longitude: initialPos?.longitude ?? 67.0011,
              formattedAddress: 'Fetching location address...',
              city: 'Karachi',
            ),
          ),
        ) {
    onCameraIdle(state.selectedPosition, defaultRestaurantLoc);
  }

  Future<void> onCameraIdle(LatLng newPos, LatLng restaurantPos) async {
    state = state.copyWith(
      selectedPosition: newPos,
      isLoading: true,
      isRouteLoading: true,
    );

    // 1. Reverse geocoding for address text
    String formattedAddress = 'Custom Map Pin Location';
    String street = '';
    String city = 'Karachi';
    String postalCode = '';

    try {
      final placemarks = await placemarkFromCoordinates(
        newPos.latitude,
        newPos.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        street = [place.street, place.subLocality].where((s) => s != null && s.isNotEmpty).join(', ');
        city = place.locality ?? 'Karachi';
        postalCode = place.postalCode ?? '';
        formattedAddress = [
          if (street.isNotEmpty) street,
          if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) place.subAdministrativeArea,
          city,
        ].join(', ');
      }
    } catch (_) {
      formattedAddress = '${newPos.latitude.toStringAsFixed(4)}, ${newPos.longitude.toStringAsFixed(4)}';
    }

    final newAddress = DeliveryAddress(
      latitude: newPos.latitude,
      longitude: newPos.longitude,
      formattedAddress: formattedAddress,
      street: street,
      city: city,
      postalCode: postalCode,
    );

    state = state.copyWith(
      currentAddress: newAddress,
      isLoading: false,
    );

    // 2. Directions API Route calculation
    final result = await directionsRepository.getDeliveryRoute(
      origin: LatLngPoint(restaurantPos.latitude, restaurantPos.longitude),
      destination: LatLngPoint(newPos.latitude, newPos.longitude),
    );

    result.when(
      success: (route) {
        state = state.copyWith(
          route: route,
          isRouteLoading: false,
        );
      },
      failure: (failure) {
        state = state.copyWith(
          isRouteLoading: false,
        );
      },
    );
  }

  Future<LatLng?> fetchCurrentGPSLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      final userPos = LatLng(position.latitude, position.longitude);
      await onCameraIdle(userPos, defaultRestaurantLoc);
      return userPos;
    } catch (_) {
      return null;
    }
  }
}
