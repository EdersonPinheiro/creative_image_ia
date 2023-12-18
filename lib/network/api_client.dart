import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class ApiClient {
  static const _url = 'https://api.openai.com/v1/images/generations';

  static Future<Map<String, dynamic>?> postRequest(
      {required String prompt}) async {
    try {
      final response = await post(Uri.parse(_url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${dotenv.env['API_KEY']}'
          },
          body: jsonEncode({
            "model": "dall-e-3",
            "prompt": prompt,
            "size": "1024x1024",
            "quality": "standard",
            "n": 1,
          }));

      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        debugPrint(response.body);
        final json = jsonDecode(response.body);
        return json['data'][0];
      }

      return null;
    } on HttpException catch (e) {
      print("HttpException: ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }
}
