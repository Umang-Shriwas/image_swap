import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';

class ApiService {
  static const String swapUrl =
      'https://web-production-27e6.up.railway.app/swap-clothes';
  static const String createUrl =
      'https://web-production-27e6.up.railway.app/create';

  final Dio _dio = Dio();
  final Logger _logger = Logger();

  Future<String?> swapClothes(
      String category, List<int> personImage, List<int> clothesImage) async {
    try {
      FormData formData = FormData.fromMap({
        'category': category,
        'person_image': MultipartFile.fromBytes(personImage,
            filename: 'base_image.png', contentType: MediaType('image', 'png')),
        'clothes_design': MultipartFile.fromBytes(clothesImage,
            filename: 'clothes_image.png',
            contentType: MediaType('image', 'png')),
      });

      Response response = await _dio.post(swapUrl, data: formData);

      if (response.statusCode == 200) {
        var responseData = response.data;

        if (responseData is String) {
          return responseData;
        } else if (responseData is Map<String, dynamic>) {
          return responseData['url'];
        } else {
          _logger.e('Unexpected response format');
          return null;
        }
      } else {
        _logger.e('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _logger.e('Error: $e');
      return null;
    }
  }

  Future<String?> createClothes(
      String category, String textPrompt, List<int> personImage) async {
    try {
      FormData formData = FormData.fromMap({
        'category': category,
        'text_prompt': textPrompt,
        'file': MultipartFile.fromBytes(personImage,
            filename: 'base_image.png', contentType: MediaType('image', 'png')),
      });

      Response response = await _dio.post(createUrl, data: formData);

      if (response.statusCode == 200) {
        var responseData = response.data;

        if (responseData is String) {
          return responseData;
        } else if (responseData is Map<String, dynamic>) {
          return responseData['url'];
        } else {
          _logger.e('Unexpected response format');
          return null;
        }
      } else {
        _logger.e('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _logger.e('Error: $e');
      return null;
    }
  }
}
