import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing a Map Delivery Location Address.
class DeliveryAddress extends Equatable {
  final double latitude;
  final double longitude;
  final String formattedAddress;
  final String street;
  final String city;
  final String postalCode;

  const DeliveryAddress({
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
    this.street = '',
    this.city = '',
    this.postalCode = '',
  });

  DeliveryAddress copyWith({
    double? latitude,
    double? longitude,
    String? formattedAddress,
    String? street,
    String? city,
    String? postalCode,
  }) {
    return DeliveryAddress(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      street: street ?? this.street,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        formattedAddress,
        street,
        city,
        postalCode,
      ];
}
