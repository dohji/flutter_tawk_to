import 'dart:async';
import 'package:mefita/utils/constants.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TripTrackingController extends GetxController {
  late IO.Socket _socket;
  StreamSubscription<Position>? _positionStream;
  bool _isTracking = false;

  void startTripTracking(String tripId) {
    _socket = IO.io(
      // 'http://192.168.100.28:3000',
      URLs.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      print('✅ Socket connected');
      _socket.emit('join-trip-room', {'tripId': tripId});
      _isTracking = true;

      _startLocationStream(tripId);
    });

    _socket.onDisconnect((_) {
      print('⚠️ Socket disconnected');
      _isTracking = false;
    });
  }

  void _startLocationStream(String tripId) {
    _positionStream?.cancel();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 2,
      ),
    ).listen((Position position) {
      final payload = {
        'tripId': tripId,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': DateTime.now().toIso8601String(),
        'speed': position.speed,
        'heading': position.heading,
        'accuracy': position.accuracy,
      };

      print('📡 Sending location: $payload');
      _socket.emit('location-update', payload);
    });
  }

  void endTripTracking(String tripId) async {
    if (_isTracking) {
      _socket.emit('leave-trip-room', {'tripId': tripId});
      _positionStream?.cancel();
      _socket.dispose();
      _isTracking = false;
      print('🛑 Trip tracking ended.');
    }
  }

  @override
  void onClose() {
    endTripTracking(''); // safe shutdown
    super.onClose();
  }
}