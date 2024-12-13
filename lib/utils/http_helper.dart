import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  static String movieNightBaseUrl = 'https://movie-night-api.onrender.com';
  static String tmdbBaseUrl = 'https://api.themoviedb.org/3/movie/popular';
  static String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  static startSession(String? deviceId) async {
    var response = await http
        .get(Uri.parse('$movieNightBaseUrl/start-session?device_id=$deviceId'));
    return jsonDecode(response.body);
  }

  static joinSession(String? deviceId, int code) async {
    var response = await http.get(Uri.parse(
        '$movieNightBaseUrl/join-session?device_id=$deviceId&code=$code'));
    return jsonDecode(response.body);
  }

  static fetchMovies(int page) async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    final response =
        await http.get(Uri.parse('$tmdbBaseUrl?api_key=$apiKey&page=$page'));

    return jsonDecode(response.body);
  }

  static voteMovie(String? sessionId, int movieId, bool vote) async {
    var response = await http.get(Uri.parse(
        '$movieNightBaseUrl/vote-movie?session_id=$sessionId&movie_id=$movieId&vote=$vote'));
    return jsonDecode(response.body);
  }
}
