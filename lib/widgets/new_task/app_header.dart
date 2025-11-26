import 'package:flutter/material.dart';
import 'package:tmbi/config/extension_file.dart';
import '../../config/converts.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateTime.now().getGreeting(),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                Text(DateTime.now().toFormattedString(),
                    style: TextStyle(
                      fontSize: Converts.c16 - 2,
                    )),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))
        ],
      ),
    );
  }
}
