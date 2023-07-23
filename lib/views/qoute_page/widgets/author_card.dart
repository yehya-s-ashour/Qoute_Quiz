import 'package:flutter/material.dart';

class AuthorCard extends StatefulWidget {
  final String author;

  AuthorCard({required this.author});

  @override
  State<AuthorCard> createState() => _AuthorCardState();
}

class _AuthorCardState extends State<AuthorCard> {
  @override
  @override
  Widget build(BuildContext context) {
    return widget.author.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Positioned(
            top: (MediaQuery.of(context).size.height / 2) + 150,
            left: (MediaQuery.of(context).size.width / 2) - 90,
            child: Container(
              alignment: Alignment.center,
              width: 190,
              height: 40,
              color: Colors.amber,
              child: Text(
                widget.author,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
  }
}
