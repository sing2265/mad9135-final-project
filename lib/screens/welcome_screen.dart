import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:final_project/screens/enter_code_screen.dart';
import 'package:final_project/screens/share_code_screen.dart';
import 'package:final_project/utils/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Night'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShareCodeScreen(),
                    ));
              },
              child: const Text('Start Session'),
            ),
            const Text("Choose an option to begin"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EnterCodeScreen(),
                    ));
              },
              child: const Text('Enter Code'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initializeDeviceId() async {
    String deviceId = await _fetchDeviceId();
    Provider.of<AppState>(context, listen: false).setDeviceId(deviceId);
  }

  Future<String> _fetchDeviceId() async {
    String deviceId = "";

    try {
      if (Platform.isAndroid) {
        const androidPlugin = AndroidId();
        deviceId = await androidPlugin.getId() ?? 'Unknown ID';
      } else if (Platform.isIOS) {
        var deviceInfoPlugin = DeviceInfoPlugin();
        var iOSInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iOSInfo.identifierForVendor ?? 'Unknown ID';
      } else {
        deviceId = 'Unsupported platform';
      }
    } catch (e) {
      deviceId = 'Error: $e';
    }
    return deviceId;
  }
}
