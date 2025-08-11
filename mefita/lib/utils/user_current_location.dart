import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mefita/ui/global/components/buttons.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ndialog/ndialog.dart';

typedef OnLocationEnabledCallback = void Function(bool locationEnabled, Position? currentPosition);
typedef OnBackgroundLocationUpdate = void Function(Position position);

class UserCurrentLocation {
  UserCurrentLocation();

  BuildContext? context = Get.overlayContext;

  Position? currentPosition;
  StreamSubscription<Position>? _backgroundStream;

  /// Entry point to get current location once
  Future<void> getUserLocation({
    bool forceEnableLocation = false,
    OnLocationEnabledCallback? onLocationEnabled,
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration? timeout,
  }) async {
    try {
      final hasPermission = await _handlePermission(forceEnable: forceEnableLocation);
      if (!hasPermission) {
        onLocationEnabled?.call(false, null);
        return;
      }

      currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: timeout,
        ),
      );

      onLocationEnabled?.call(true, currentPosition);
    } catch (e) {
      debugPrint('Error getting user location: $e');
      onLocationEnabled?.call(false, null);
    }
  }

  /// Start background location tracking
  Future<void> startBackgroundTracking({
    required OnBackgroundLocationUpdate onUpdate,
    LocationAccuracy accuracy = LocationAccuracy.bestForNavigation,
    int distanceFilter = 10,
    bool forceEnable = true,
  }) async {
    final hasPermission = await _handlePermission(forceEnable: forceEnable);
    if (!hasPermission) return;

    _backgroundStream?.cancel(); // Prevent multiple streams

    _backgroundStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    ).listen(
          (Position position) {
        currentPosition = position;
        onUpdate(position);
      },
      onError: (e) => debugPrint("Background tracking error: $e"),
      cancelOnError: false,
    );
  }

  /// Stop background location tracking
  Future<void> stopBackgroundTracking() async {
    await _backgroundStream?.cancel();
    _backgroundStream = null;
  }

  /// Check permissions and service availability
  Future<bool> _handlePermission({bool forceEnable = false}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (serviceEnabled && (permission == LocationPermission.always || permission == LocationPermission.whileInUse)) {
      return true;
    }

    if (forceEnable) {
      await _showLocationRequestPopup();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      permission = await Geolocator.checkPermission();
      return serviceEnabled && (permission == LocationPermission.always || permission == LocationPermission.whileInUse);
    }

    return false;
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> _showLocationRequestPopup() async {
    if (context == null) return;

    await AlertDialog(
      elevation: 0,
      backgroundColor: Colors.white,
      scrollable: false,
      insetPadding: const EdgeInsets.all(20.0),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      content: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  // color: Colors.green,
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle
                ),
                child: SvgPicture.asset(
                    "assets/svg/location-street.svg",
                    height: 40
                )
                // child: Icon(Icons.location_on_rounded, size: 40)
            ),
            const SizedBox(height: 15),
            Text('Location Services',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Your location is required to proceed",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 25),
            PrimaryButton(
              label: 'Okay',
              foregroundColor: Get.theme.colorScheme.onPrimary,
              backgroundColor: Get.theme.colorScheme.primary,
              isFullWidth: true,
              onTap: () async {
                Get.back();

                bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                if (!serviceEnabled) {
                  await openLocationSettings();
                }

                LocationPermission permission = await Geolocator.checkPermission();
                if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
                  permission = await Geolocator.requestPermission();
                }

                if (permission == LocationPermission.deniedForever) {
                  await openAppSettings();
                }
              },
            ),
            // const SizedBox(height: 15),
            // PrimaryButton(
            //   label: 'Not now',
            //   foregroundColor: Get.theme.colorScheme.primary,
            //   backgroundColor: Get.theme.colorScheme.primaryContainer,
            //   isFullWidth: true,
            //   onTap: () => Get.back(),
            // ),
          ],
        ),
      ),
    ).show(
      context!,
      dialogTransitionType: DialogTransitionType.BottomToTop,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.8),
    );
  }

  Future<Position?> getCurrentPositionDirect({LocationAccuracy accuracy = LocationAccuracy.high}) async {
    final isAllowed = await _handlePermission(forceEnable: false);
    if (!isAllowed) return null;
    return await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: accuracy));
  }

  Stream<Position> locationStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    );
  }
}