import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_movie_response.dart';

class MoviesProvider extends ChangeNotifier {
  String _apiKey = '418339ac180b7455efd511c186966c35';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Movie> onDisPlayMovie = [];
  List<Movie> popularMovie = [];

  Map<int, List<Cast>> movieCast = {};

  final deboucer = Debouncer(
      duration: const Duration(
    milliseconds: 500,
  ));
  int _popularPage = 0;

  final StreamController<List<Movie>> _suggestionStreamController =
      new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      this._suggestionStreamController.stream;

  MoviesProvider() {
    this.getOnDisplayMovies();
    this.getPopularMovie();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await this._getJsonData('/3/movie/now_playing');
    final nowPlayResponse = NowPlayinResponse.fromJson(jsonData);

    onDisPlayMovie = nowPlayResponse.results;
    notifyListeners();
  }

  getPopularMovie() async {
    _popularPage++;
    final jsonData = await this._getJsonData('/3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);

    popularMovie = [...popularMovie, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    //Todo revisar mapa

    if (movieCast.containsKey(movieId)) return movieCast[movieId]!;

    final jsonData = await this._getJsonData('/3/movie/${movieId}/credits');
    final credisResponse = CreditsResponse.fromJson(jsonData);

    movieCast[movieId] = credisResponse.cast;
    return credisResponse.cast;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String query) {
    deboucer.value = '';
    deboucer.onValue = (value) async {
      final result = await this.searchMovie(query);
      this._suggestionStreamController.add(result);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      deboucer.value = query;
    });
    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
