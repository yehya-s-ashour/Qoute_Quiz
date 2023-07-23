import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:quiz/data/network.dart';
import 'package:quiz/views/loading_page/loading_page.dart';
import 'package:quiz/views/qoute_page/widgets/author_card.dart';
import 'package:share_plus/share_plus.dart';

import 'widgets/qoute_card.dart';

class QoutePage extends StatefulWidget {
  const QoutePage({super.key});

  @override
  State<QoutePage> createState() => _QoutePageState();
}

class _QoutePageState extends State<QoutePage> {
  String? imageLink = '';
  String? quote = '';
  String? author = '';
  GlobalKey globalKey = GlobalKey();
  Uint8List? pngBytes;
  Future<void> fetchData() async {
    try {
      imageLink = await QuoteService.getImage();
      print(imageLink);
      Map<String, String> quoteData = await QuoteService.getQuoteAuthor();
      quote = quoteData['quote'];
      author = quoteData['author'];
      setState(() {});
    } catch (e) {
      print("Something went wrong: $e");
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> _capturePng() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    // if (boundary.debugNeedsPaint) {
    if (kDebugMode) {
      print("Waiting for boundary to be painted.");
    }
    await Future.delayed(const Duration(milliseconds: 20));
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    pngBytes = byteData!.buffer.asUint8List();
    if (kDebugMode) {
      print(pngBytes);
    }
    if (mounted) {
      _onShareXFileFromAssets(context, byteData);
    }
    // }
  }

  void _onShareXFileFromAssets(BuildContext context, ByteData? data) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // final data = await rootBundle.load('assets/flutter_logo.png');
    final buffer = data!.buffer;
    final shareResult = await Share.shareXFiles(
      [
        XFile.fromData(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          name: 'screen_shot.png',
          mimeType: 'image/png',
        ),
      ],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
  }

  SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Share result: ${result.status}"),
          if (result.status == ShareResultStatus.success)
            Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return imageLink!.isEmpty
        ? const LoadingPage()
        : Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: _capturePng,
              label: const Text('Take screenshot'),
              icon: const Icon(Icons.share_rounded),
            ),
            body: RepaintBoundary(
                key: globalKey,
                child: Scaffold(
                  body: Stack(
                    children: [
                      Positioned(
                          child: imageLink == ''
                              ? const Center(child: CircularProgressIndicator())
                              : Opacity(
                                  opacity: 0.6,
                                  child: Image.network(
                                    '$imageLink',
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                  ),
                                )),
                      Positioned(
                        left: MediaQuery.of(context).size.width - 70,
                        child: Container(
                          margin: EdgeInsetsDirectional.only(end: 40, top: 40),
                          padding: EdgeInsetsDirectional.only(
                              start: 5, end: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: Colors.white30, shape: BoxShape.circle),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                fetchData();
                              });
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.amber,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      quote!.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : QouteCard(quote: quote!),
                      author!.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : AuthorCard(author: author!),
                    ],
                  ),
                )),
          );
  }
}
