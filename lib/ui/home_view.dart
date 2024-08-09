import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_kursi/ui/monitor_view.dart';
import 'package:frontend_kursi/ui/riwayat_view.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _mqttMessage = 'No message received';

  final String broker = 'mqtt.iot.asmat.app';
  final int port = 1883;
  final String username = 'SENSOR_KURSI_IGNITE';
  final String password = 'your_password';
  final String clientIdentifier = 'mqtt.iot.asmat.app';
  final String topic = 'Sensor_Kursi_Alvin';

  MqttServerClient? _client;
  Function(String)? onMessageReceived;
  @override
  void initState() {
    super.initState();
    // _mqttService.onMessageReceived = (String message) {
    //   setState(() {
    //     _mqttMessage = message;
    //   });
    // };
    // connectMqtt();
    title = "Monitor";
    selectedIndex = 0;
  }

  void connectMqtt() {
    try {
      connect();
    } catch (e) {
      log("done error $e");
    }
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  int selectedIndex = 0;
  String title = "";

  final WidgetOptions = [const MonitorView(), const RiwayatView()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              // <-- SEE HERE
              decoration: BoxDecoration(color: const Color(0xff764abc)),
              accountName: Text(
                "Deral Alvin",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                "deral@ earth@gmail.com",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentAccountPicture: FlutterLogo(),
            ),
            ListTile(
              leading: const Icon(
                Icons.event_seat_rounded,
              ),
              title: const Text('Monitor'),
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                  title = "Monitor";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.history,
              ),
              title: const Text('Riwayat'),
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                  title = "Riwayat";
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: WidgetOptions.elementAt(selectedIndex),
    );
  }

  Future<void> connect() async {
    _client = MqttServerClient(broker, clientIdentifier);
    _client!.port = port;
    _client!.logging(on: true);

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean()
        .authenticateAs(username, password);

    _client!.connectionMessage = connMessage;

    try {
      await _client!.connect();
    } catch (e) {
      print('Exception: $e');
      _client!.disconnect();
    }

    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final String message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      if (onMessageReceived != null) {
        onMessageReceived!(message);
      }
    });

    _client!.subscribe(topic, MqttQos.atMostOnce);
  }

  void disconnect() {
    _client!.disconnect();
  }
}
