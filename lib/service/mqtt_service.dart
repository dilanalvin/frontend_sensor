import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

class MQTTService {
  final String serverMqtt = "ws://mqtt.iot.asmat.app";
  final String userMqtt = "SENSOR_KURSI_IGNITE";
  final String passwordMqtt = "";
  final String topicMqtt = "Sensor_Kursi_Alvin";

  late MqttBrowserClient client;
  Function(String)? onMessageReceived;

  MQTTService({this.onMessageReceived}) {
    client = MqttBrowserClient.withPort(serverMqtt, '', 443);

    client.port = 443; // Port WebSocket
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean() // Non-persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;
  }

  Future<void> connect() async {
    try {
      await client.connect(userMqtt, passwordMqtt);
    } on Exception catch (e) {
      print('Exception failed: $e');
      client.disconnect();
    }

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      if (onMessageReceived != null) {
        onMessageReceived!(pt);
      }

      print('Received message: $pt from topic: ${c[0].topic}>');
    });
  }

  void onConnected() {
    print('Connected');
    client.subscribe(topicMqtt, MqttQos.atMostOnce);
  }

  void onDisconnected() {
    print('Disconnected');
  }

  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');
  }

  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

  void pong() {
    print('Ping response client callback invoked');
  }
}
