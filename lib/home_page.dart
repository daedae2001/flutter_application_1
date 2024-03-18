import 'package:flutter/material.dart';
import 'firebase_message_handler.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Messaging Demo'),
      ),
      body: Center(
        child: StreamBuilder<Map<String, dynamic>>(
          stream: FirebaseMessageHandler.messageStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final messageData = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mensaje recibido:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Título: ${messageData['notification']['title']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Cuerpo: ${messageData['notification']['body']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  // Aquí puedes agregar más widgets para mostrar otros datos del mensaje si los hay
                ],
              );
            } else {
              return Text(
                'Esperando mensaje...',
                style: TextStyle(fontSize: 20),
              );
            }
          },
        ),
      ),
    );
  }
}
