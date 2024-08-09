import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_kursi/const/const.dart';
import 'package:frontend_kursi/service/mqtt_service.dart';
import 'package:frontend_kursi/widget/list_seat_widget.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MonitorView extends StatefulWidget {
  const MonitorView({super.key});

  @override
  State<MonitorView> createState() => _MonitorViewState();
}

class _MonitorViewState extends State<MonitorView> {
  Map<String, dynamic> dataMsg = {};
  final WebSocketChannel channel =
      HtmlWebSocketChannel.connect('ws://202.10.40.176:8080');
  String message = 'No message received yet';

  @override
  void initState() {
    super.initState();
    channel.stream.listen((msg) {
      setState(() {
        message = msg;
        fetchData(msg);
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void fetchData(String msg) async {
    print("data oncheck");

    List data = [];
    final value = jsonDecode(msg);
    data = value['sensor'].toString().split('').map(int.parse).toList();
    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < dataLayout.length; j++) {
        if (dataLayout[j]['type'] == "p" &&
            dataLayout[j]['value'] == (i + 1).toString()) {
          setState(() {
            dataLayout[j]['isseat'] = data[i];
            print("dans $dataLayout");
          });
        }
      }
    }
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("Sensor Kursi Baraya"),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        SizedBox(
                          width: 500,
                          child: GridView(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                            ),
                            padding: const EdgeInsets.all(50),
                            children: dataLayout.map((e) {
                              return ListSeatWidget(seat: e);
                            }).toList(),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Keterangan"),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: yellowDark,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text("Terisi"),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text("Kosong"),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Text("Data Terdeteksi ${message}")
            ],
          ),
        ),
      ),
    );
  }
}
