import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessageHandler {
  static FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static StreamController<Map<String, dynamic>> _messageStreamController =
      StreamController.broadcast();

  static Stream<Map<String, dynamic>> get messageStream =>
      _messageStreamController.stream;

  static Future<void> initialize() async {
    // Solicitar permiso para recibir mensajes
    await requestPermission();

    // Configurar manejo de mensajes en primer plano
    configureForegroundMessageHandling();

    // Configurar manejo de mensajes en segundo plano
    configureBackgroundMessageHandling();

    // Obtener y mostrar el token
    String? token = await _firebaseMessaging.getToken();
    print('Token: $token');

    // Suscribirse al topic "myapp"
    _firebaseMessaging.subscribeToTopic('myapp');
  }

  static Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  static void configureForegroundMessageHandling() {
    // Manejar mensajes mientras la aplicación está en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      // Emitir el mensaje al Stream
      _messageStreamController.add(message.data);
    });
  }

  static void configureBackgroundMessageHandling() {
    // Manejar mensajes mientras la aplicación está en segundo plano o terminada
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // Si planeas usar otros servicios de Firebase en segundo plano, como Firestore,
    // asegúrate de llamar a `initializeApp` antes de usar otros servicios de Firebase.
    // await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");

    // Emitir el mensaje al Stream
    _messageStreamController.add(message.data);
  }
}
