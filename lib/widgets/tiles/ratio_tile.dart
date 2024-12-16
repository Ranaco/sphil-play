import 'dart:developer';

import 'package:flutter/material.dart';

class RatioTile extends StatelessWidget {
  final Map<String, dynamic> appUsage;

  const RatioTile({super.key, required this.appUsage});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final totalUsage = appUsage.values
        .map((value) => int.parse(value.toString()))
        .reduce((a, b) => a + b);

    final colors = [
      const Color(0xffF9DA44),
      const Color(0xff80E8FF),
    ];

    final appKeys = appUsage.keys.toList();

    return appUsage.isNotEmpty
        ? Container(
            width: size.width,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              children: appUsage.entries.map((entry) {
                final index = appUsage.keys.toList().indexOf(entry.key);
                final usage = int.parse(entry.value.toString());
                final percentage = usage / totalUsage;
                log("Color for $index: $colors");

                return Flexible(
                  flex: (percentage * 1000).toInt(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors[index],
                      borderRadius: _getBorderRadius(entry.key, appKeys),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _getAppName(entry.key),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        : SizedBox();
  }

  String _getAppName(String packageName) {
    final nameMapping = {
      "com.yidflicks.app": "YidFlicks",
      "com.toveedo.tablet": "Toveedo",
    };
    return nameMapping[packageName] ?? packageName;
  }

  BorderRadius _getBorderRadius(String key, List<String> appKeys) {
    if (key == appKeys.first) {
      return const BorderRadius.only(
        topLeft: Radius.circular(40),
        bottomLeft: Radius.circular(40),
      );
    } else if (key == appKeys.last) {
      return const BorderRadius.only(
        topRight: Radius.circular(40),
        bottomRight: Radius.circular(40),
      );
    }
    return BorderRadius.zero;
  }
}
