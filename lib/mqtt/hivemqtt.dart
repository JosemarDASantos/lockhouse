import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

main() async {
  MQTTClientWrapper newclient = new MQTTClientWrapper();
  newclient.prepareMqttClient();
}
Future<void> getMqtt() async {
  print("Resgistrando mqtt...");

  await Future.delayed(Duration(milliseconds: 2000));

  MQTTClientWrapper newclient = new MQTTClientWrapper();
  newclient.prepareMqttClient();
}

// connection states for easy identification
enum MqttCurrentConnectionState {
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING
}

enum MqttSubscriptionState { IDLE, SUBSCRIBED }

class MQTTClientWrapper {
  MqttServerClient client;
  var _teste1;
  var _teste2;
  var _teste3;
  var _teste4;
  var _teste5;
  var _teste6;
  var _teste7;
  var _teste8;
  var _teste9;
  var _teste10;

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  // using async tasks, so the connection won't hinder the code flow
  void prepareMqttClient() async {
    _setupMqttClient();
    await _connectClient();
    _subscribeToTopic('topic/lockhouseIN');
    _publishMessage('1');
  }

  // waiting for the connection, if an error occurs, print it and disconnect
  Future<void> _connectClient() async {
    try {
      _teste2 = 'client connecting....';
      print(_teste2);
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client.connect('josemar', 'password');
    } on Exception catch (e) {
      _teste3 = 'client exception - $e';
      print(_teste3);
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }

    // when connected, print a confirmation, else print an error
    if (client.connectionStatus.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      _teste4 = 'client connected';
      print(_teste4);
    } else {
      _teste5 =
          'ERROR client connection failed - disconnecting, status is ${client.connectionStatus}';
      print(_teste5);
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }
  }

  void _setupMqttClient() {
    client = MqttServerClient.withPort(
        'broker.mqttdashboard.com', 'clientId-ulet4FYSbj', 1883);
    // the next 2 lines are necessary to connect with tls, which is used by HiveMQ Cloud
    client.secure = false;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  void _subscribeToTopic(String topicName) {
    _teste1 = 'Subscribing to the $topicName topic';
    print(_teste1);
    client.subscribe(topicName, MqttQos.atMostOnce);

    // print the message when it is received
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      var message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      _teste6 = 'Você enviou a mensagem "$message" para o tópico:';
      print(_teste6);
      client.disconnect();
    });
  }

  void _publishMessage(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    _teste7 = 'Publishing message "$message" to topic ${'topic/lockhouseIN'}';
    print(_teste7);
    client.publishMessage(
        'topic/lockhouseIN', MqttQos.exactlyOnce, builder.payload);
  }

  // callbacks for different events
  void _onSubscribed(String topic) {
    _teste8 = 'Subscription confirmed for topic $topic';
    print(_teste8);
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    _teste9 = 'OnDisconnected client callback - Client disconnection';
    print(_teste9);
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
    _teste10 = 'OnConnected client callback - Client connection was sucessful';
    print(_teste10);
  }
}
