import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

class LocationPickerMap extends StatelessWidget {
  final LatLng initialLocation;
  final void Function(GoogleMapController) onMapCreated;
  final void Function(CameraPosition) onCameraMove;
  final VoidCallback onCameraIdle;

  const LocationPickerMap({
    required this.initialLocation,
    required this.onMapCreated,
    required this.onCameraMove,
    required this.onCameraIdle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialLocation,
            zoom: 14,
          ),
          onMapCreated: onMapCreated,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onCameraMove: onCameraMove,
          onCameraIdle: onCameraIdle,
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.xxl),
            child: Icon(Icons.location_on, color: Colors.red, size: 48),
          ),
        ),
      ],
    );
  }
}
