import 'dart:io';
import 'dart:async';
import 'package:esense_flutter/esense.dart';
import 'package:permission_handler/permission_handler.dart';

/// Handles the connection and sensor data management regarding the eSense device.
class ESenseHandler {
  bool isConnected = false;
  bool incrementDetected = false;
  static const String _eSenseDeviceName = 'eSense-0599';
  final ESenseManager _eSenseManager = ESenseManager(_eSenseDeviceName);
  StreamSubscription? _subscription;

  /// Asks for permission to connect via bluetooth.
  Future<void> _askForPermissions() async {
    if (!(await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted)) {
      print('WARNING - no permission to use Bluetooth granted. Cannot access eSense device.');
    }
    if (Platform.isAndroid) {
      if (!(await Permission.locationWhenInUse.request().isGranted)) {
        print('WARNING - no permission to access location granted. Cannot access eSense device.');
      }
    }
  }

  /// Listens to the connection status.
  Future<void> listenToESense() async {
    await _askForPermissions();

    _eSenseManager.connectionEvents.listen((event) {
      print('CONNECTION event: $event');

      isConnected = false;
      switch (event.type) {
        case ConnectionType.connected:
          isConnected = true;
          break;
        case ConnectionType.unknown:
          _connectToESense();
          break;
        case ConnectionType.disconnected:
          isConnected = false;
          break;
        case ConnectionType.device_found:
        case ConnectionType.device_not_found:
          break;
      }
    });
  }

  /// Connects the eSense device.
  Future<void> _connectToESense() async {
    if (!isConnected) {
      print('Trying to connect to eSense device...');
      await _eSenseManager.connect();
    }
  }

  /// Gathers the sensor data from the accelerator sensor
  /// and computes if the user did a headbang.
  Future<void> startListenToSensorEvents() async {
    const int headbangThreshold = 10000;
    const int relevantAxisIndex = 1;

    _subscription = _eSenseManager.sensorEvents.listen((event) {
      if (event.accel![relevantAxisIndex] > headbangThreshold) {
        print('SENSOR event: ${event.accel![relevantAxisIndex]}');
        incrementDetected = true;
      }
    });
  }

  /// Pauses gathering the sensor data from the eSense device.
  void pauseListenToSensorEvents() async {
    _subscription?.cancel();
  }
}