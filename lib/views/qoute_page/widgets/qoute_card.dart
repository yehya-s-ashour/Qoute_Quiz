import 'package:flutter/material.dart';
import 'package:quiz/data/network.dart';

class QouteCard extends StatefulWidget {
  final String quote;
  QouteCard({required this.quote});

  @override
  State<QouteCard> createState() => _QouteCardState();
}

class _QouteCardState extends State<QouteCard> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (MediaQuery.of(context).size.height / 2) - 70,
      left: (MediaQuery.of(context).size.width / 2) - 155,
      child: SizedBox(
        width: 320,
        child: Text(
          widget.quote,
          maxLines: 5,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 35,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
