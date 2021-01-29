import 'package:flutter/material.dart';

class StatsPage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(8),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              buildPadding("Games Played", "0", color: true),
              buildPadding("Wins", "0"),
              buildPadding("Highest Point Table", "0", color: true),
              buildPadding("HRs", "0"),
              buildPadding("Triples", "0", color: true),
              buildPadding("RBIs", "0"),
              buildPadding("Most Productive Player", "0", color: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPadding(String key, String value, { bool color = false}) {
    var textStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    var textStyle2 = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    return Container(
      color: color?Colors.grey[100]:Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              key,
              style: textStyle,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              value,
              style: textStyle2,
            )
          ],
        ),
      ),
    );
  }

  Text buildGroup() => Text(
        "Screen Name:",
        style: TextStyle(
          fontSize: 16,
        ),
      );
}
