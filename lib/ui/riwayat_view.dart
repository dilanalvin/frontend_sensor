import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_kursi/const/const.dart';
import 'package:frontend_kursi/widget/list_seat_widget.dart';

class RiwayatView extends StatefulWidget {
  const RiwayatView({super.key});

  @override
  State<RiwayatView> createState() => _RiwayatViewState();
}

class _RiwayatViewState extends State<RiwayatView> {
  final dio = Dio();
  int page = 1;
  int totalPage = 0;
  List dataSensor = [];
  void request(int page) async {
    try {
      Response response;

      // The below request is the same as above.
      response = await dio.get(
        'http://202.10.40.176/api/sensor',
        queryParameters: {
          'page': page,
        },
      );
      if (response.data['status'] == 200) {
        setState(() {
          dataSensor = response.data['result']['data'];
        });
      }
    } catch (e) {
      log("error endpoint failed $e");
    }
  }

  @override
  void initState() {
    super.initState();

    request(page);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: dataSensor.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Text("${dataSensor[index]['time_sensor']}"),
                      children: dataSensor[index]['data']
                          .map<Widget>(
                            (e) => InkWell(
                              onTap: () {
                                updateLayoutKursi(e);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Text("${e['time_sensor']}"),
                                    Expanded(
                                        child: Text(
                                            "value data : ${e['data_sensor']}"))
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                )),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 60),
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
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void updateLayoutKursi(element) {
    print("data oncheck");

    List data = [];
    final value = element['data_sensor'];
    print(element['data_sensor']);
    data = value.toString().split('').map(int.parse).toList();
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
}
