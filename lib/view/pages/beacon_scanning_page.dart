import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

class BeaconScanningPage extends StatefulWidget {
  const BeaconScanningPage({Key? key}) : super(key: key);

  @override
  _BeaconScanningPageState createState() => _BeaconScanningPageState();
}

class _BeaconScanningPageState extends State<BeaconScanningPage>
    with WidgetsBindingObserver {
  final StreamController<BluetoothState> streamController = StreamController();
  StreamSubscription<BluetoothState>? _streamBluetooth;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    super.initState();
    listeningState();
  }

  listeningState() async {
    print('Listening to bluetooth state');
    _streamBluetooth = flutterBeacon
        .bluetoothStateChanged()
        .listen((BluetoothState state) async {
      print('BluetoothState = $state');
      streamController.add(state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
        actions: [
          StreamBuilder<BluetoothState>(
            stream: streamController.stream,
            initialData: BluetoothState.stateUnknown,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final state = snapshot.data;

                if (state == BluetoothState.stateOn) {
                  return IconButton(
                    icon: const Icon(Icons.bluetooth_connected),
                    onPressed: () {},
                    color: Colors.lightBlueAccent,
                  );
                }

                if (state == BluetoothState.stateOff) {
                  return IconButton(
                    icon: const Icon(Icons.bluetooth),
                    onPressed: () async {
                      if (Platform.isAndroid) {
                        try {
                          await flutterBeacon.openBluetoothSettings;
                        } on PlatformException catch (e) {
                          print(e);
                        }
                      } else if (Platform.isIOS) {
                        await showDialog(
                          context: 
                          context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Bluetooth is Off'),
                              content: const Text(
                                  'Please enable Bluetooth on Settings > Bluetooth.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    color: Colors.red,
                  );
                }

                return IconButton(
                  icon: const Icon(Icons.bluetooth_disabled),
                  onPressed: () {},
                  color: Colors.grey,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Container(),
    );
  }
}