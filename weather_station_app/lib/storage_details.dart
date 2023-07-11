import 'package:flutter/material.dart';

import '../../../constants.dart';
// import 'chart.dart';
import 'storage_info_card.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Capteurs",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          // SizedBox(height: defaultPadding),
          // Chart(),
          StorageInfoCard(
            svgSrc: " ",
            title: "Capteur humidité",
            amountOfFiles: " ",
            numOfFiles: 1,
          ),
          StorageInfoCard(
            svgSrc: " ",
            title: "Capteur temperature",
            amountOfFiles: " ",
            numOfFiles: 1,
          ),
        ],
      ),
    );
  }
}
