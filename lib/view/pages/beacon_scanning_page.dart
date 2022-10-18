// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:freedom/util/constants.dart';

class BeaconScanningPage extends StatefulWidget {
  const BeaconScanningPage({Key? key}) : super(key: key);

  @override
  _BeaconScanningPageState createState() => _BeaconScanningPageState();
}

class _BeaconScanningPageState extends State<BeaconScanningPage>
    with WidgetsBindingObserver {
  final StreamController<BluetoothState> streamController = StreamController();
  StreamSubscription<BluetoothState>? _streamBluetooth;
  StreamSubscription<RangingResult>? _streamRanging;
  final _beacons = <Beacon>[];
  bool _authorizationStatusOk = false;
  bool _locationServiceEnabled = false;
  bool _bluetoothEnabled = false;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    super.initState();
    listeningState();
  }

  ///
  /// Bluetooth ON/OFF初期化
  ///
  listeningState() async {
    print('Listening to bluetooth state');
    _streamBluetooth = flutterBeacon
        .bluetoothStateChanged()
        .listen((BluetoothState state) async {
      print('BluetoothState = $state');
      streamController.add(state);

      if (state == BluetoothState.stateOn) {
        initScanBeacon();
      } else if (state == BluetoothState.stateOff) {
        await pauseScanBeacon();
        await checkAllRequirements();
      }
    });
  }

  ///
  /// 権限チェック
  ///
  checkAllRequirements() async {
    final bluetoothState = await flutterBeacon.bluetoothState;
    final bluetoothEnabled = bluetoothState == BluetoothState.stateOn;
    final authorizationStatus = await flutterBeacon.authorizationStatus;

    ///
    /// 【iOS】アプリ初回起動時、「このAPPの使用中にみ許可」に設定すると、alwaysとなり、位置情報認証OKとなるが、
    /// そのあと設定画面から「このAPPの使用中にみ許可」に設定すると、whenInUseとなるため注意.
    /// （サンプルコードには、whenInUseの条件は入っていなかった）
    ///
    final authorizationStatusOk =
        authorizationStatus == AuthorizationStatus.allowed ||
            authorizationStatus == AuthorizationStatus.whenInUse ||
            authorizationStatus == AuthorizationStatus.always;
    final locationServiceEnabled =
        await flutterBeacon.checkLocationServicesIfEnabled;

    print('authorizationStatusOk=$authorizationStatusOk, '
        'locationServiceEnabled=$locationServiceEnabled, '
        'bluetoothEnabled=$bluetoothEnabled');

    setState(() {
      _authorizationStatusOk = authorizationStatusOk;
      _locationServiceEnabled = locationServiceEnabled;
      _bluetoothEnabled = bluetoothEnabled;
    });
  }

  ///
  /// ビーコンScan初期化
  ///
  Future<void> initScanBeacon() async {
    await flutterBeacon.initializeScanning;
    await checkAllRequirements();
    if (_bluetoothEnabled &&
        _authorizationStatusOk &&
        _locationServiceEnabled) {
      listeningRanging();
    }
  }

  ///
  /// レンジングによる監視
  ///
  void listeningRanging() {
    final regions = <Region>[
      Region(
        identifier: 'Cubeacon',
        proximityUUID: kProximityUUID,
      ),
    ];

    _streamRanging = flutterBeacon.ranging(regions).listen(
      (RangingResult result) {
        print(result);
        if (mounted) {
          setState(() {
            _beacons.clear();
            _beacons.addAll(result.beacons);
            _beacons.sort(_compareParameters);
          });
        }
      },
    );
  }

  ///
  /// 並べ替え
  ///
  int _compareParameters(Beacon a, Beacon b) {
    int compare = a.proximityUUID.compareTo(b.proximityUUID);

    if (compare == 0) {
      compare = a.major.compareTo(b.major);
    }

    if (compare == 0) {
      compare = a.minor.compareTo(b.minor);
    }

    return compare;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('AppLifecycleState = $state');
    if (state == AppLifecycleState.resumed) {
      if (_streamBluetooth != null) {
        if (_streamBluetooth!.isPaused) {
          _streamBluetooth?.resume();
        }
      }

      await checkAllRequirements();

      if (_bluetoothEnabled) {
        await initScanBeacon();
      }
    } else if (state == AppLifecycleState.paused) {
      _streamBluetooth?.pause();
    }
  }

  pauseScanBeacon() async {
    _streamRanging?.pause();
    if (_beacons.isNotEmpty) {
      setState(() {
        _beacons.clear();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    streamController.close();
    _streamRanging?.cancel();
    _streamBluetooth?.cancel();
    flutterBeacon.close;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
        actions: [
          if (!_authorizationStatusOk && _locationServiceEnabled)
            IconButton(
              icon: const Icon(Icons.portable_wifi_off),
              color: Colors.red,
              onPressed: () async {
                await flutterBeacon.requestAuthorization;
              },
            ),
          if (!_locationServiceEnabled)
            IconButton(
              icon: const Icon(Icons.location_off),
              color: Colors.red,
              onPressed: () async {
                if (Platform.isAndroid) {
                  await flutterBeacon.openLocationSettings;
                } else if (Platform.isIOS) {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Location Services Off'),
                        content: const Text(
                            'Please enable Location Services on Settings > Privacy > Location Services.'),
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
            ),
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
                          context: context,
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
      body: _beacons.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: _beacons.map(
                (beacon) {
                  return ListTile(
                    title: Text(
                      beacon.proximityUUID,
                      style: const TextStyle(fontSize: 15.0),
                    ),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Text(
                            'Major: ${beacon.major}\nMinor: ${beacon.minor}',
                            style: const TextStyle(fontSize: 13.0),
                          ),
                          flex: 1,
                          fit: FlexFit.tight,
                        ),
                        Flexible(
                          child: Text(
                            'Accuracy: ${beacon.accuracy}m\nRSSI: ${beacon.rssi}',
                            style: const TextStyle(fontSize: 13.0),
                          ),
                          flex: 2,
                          fit: FlexFit.tight,
                        )
                      ],
                    ),
                  );
                },
              ),
            ).toList(),
          ),
    );
  }
}