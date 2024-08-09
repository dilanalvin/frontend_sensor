import 'package:flutter/material.dart';
import 'package:frontend_kursi/const/const.dart';

class ListSeatWidget extends StatelessWidget {
  final Map<String, dynamic> seat;
  const ListSeatWidget({super.key, required this.seat});

  @override
  Widget build(BuildContext context) {
    if (seat['type'] == "p") {
      return Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: seat['isseat'] == 0 ? Colors.transparent : yellowDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: seat['isseat'] == 0 ? Colors.grey : Colors.transparent,
          ),
        ),
        child: Text("${seat['value']}"),
      );
    } else if (seat['type'] == "s") {
      return Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: const Text("Supir"),
      );
    } else if (seat['type'] == "x") {
      return Container();
    } else {
      return Container();
    }
  }
}
