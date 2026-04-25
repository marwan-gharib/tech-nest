import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tech_nest/features/checkout/presentation/widgets/address_selection_card.dart';
import 'package:tech_nest/features/checkout/presentation/widgets/location_picker_map.dart';
import 'package:tech_nest/features/checkout/presentation/widgets/my_location_button.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;

  LatLng _selectedLocation = const LatLng(30.0444, 31.2357);

  late final ValueNotifier<bool> _isLoadingNotifier;
  late final ValueNotifier<String> _selectedAddressNotifier;

  @override
  void initState() {
    super.initState();
    _isLoadingNotifier = ValueNotifier<bool>(false);
    _selectedAddressNotifier = ValueNotifier<String>(
      t.checkout.detectingLocation,
    );
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    _isLoadingNotifier.value = true;

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if ([
        LocationPermission.denied,
        LocationPermission.deniedForever,
      ].contains(permission)) {
        _isLoadingNotifier.value = false;
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final newLocation = LatLng(position.latitude, position.longitude);

      _selectedLocation = newLocation;

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(newLocation, 19),
      );

      await _getAddressFromLatLng(newLocation);
    } catch (e) {
      debugPrint('Error getting location: $e');
    } finally {
      _isLoadingNotifier.value = false;
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _selectedAddressNotifier.value =
            '${place.street}, ${place.subLocality}, ${place.locality}';
      }
    } catch (e) {
      if (mounted) {
        _selectedAddressNotifier.value = context.t.checkout.locationError;
      }
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _isLoadingNotifier.dispose();
    _selectedAddressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.checkout.selectLocation)),
      body: Stack(
        children: [
          LocationPickerMap(
            initialLocation: _selectedLocation,
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: (position) {
              _selectedLocation = position.target;
            },
            onCameraIdle: () async {
              await _getAddressFromLatLng(_selectedLocation);
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MyLocationButton(
                  onPressed: _getCurrentLocation,
                  isLoadingNotifier: _isLoadingNotifier,
                ),
                AddressSelectionCard(
                  addressNotifier: _selectedAddressNotifier,
                  onConfirm: () =>
                      context.pop<String>(_selectedAddressNotifier.value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
