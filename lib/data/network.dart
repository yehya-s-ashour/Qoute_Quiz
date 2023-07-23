import 'dart:convert';

import 'package:http/http.dart' as http;

class QuoteService {
  static Future<String> getImage() async {
    String tag = '';
    String url = 'https://random.imagecdn.app/v1/image?tag=$tag&format=json';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String imageLink = jsonDecode(response.body)['url'];
      return imageLink;
    } else {
      throw Exception("Failed to load image");
    }
  }

  static Future<Map<String, String>> getQuoteAuthor() async {
    String url = 'https://api.quotable.io/random';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String quote = jsonDecode(response.body)['content'];
      String author = jsonDecode(response.body)['author'];
      return {
        'quote': quote,
        'author': author,
      };
    } else {
      throw Exception("Failed to load quote");
    }
  }
}
