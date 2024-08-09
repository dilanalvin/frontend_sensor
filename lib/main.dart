import 'package:flutter/material.dart';
import 'package:frontend_kursi/ui/home_view.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/html.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeView());
  }
}
