import 'dart:convert';
import 'package:chess_viewer/Classes/PlayerProfile.dart';
import 'package:http/http.dart' as http;

class ChessApiService {

  static final ChessApiService _instance = ChessApiService._internal();
  
  ChessApiService._internal();

  factory ChessApiService() => _instance;

  static const String baseUrl = 'https://api.chess.com/pub';

  Future<PlayerProfile> getPlayerProfile(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/player/$username'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return PlayerProfile.fromJson(jsonData);
      } else {
        throw Exception('There is not kinda user such as given one: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Please, try again in time: $e');
    }
  }
}