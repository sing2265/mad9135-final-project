import 'package:final_project/utils/app_state.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({
    super.key,
  });

  @override
  State<MovieSelectionScreen> createState() => _MovieSelectionState();
}

class _MovieSelectionState extends State<MovieSelectionScreen> {
  List<Map<String, dynamic>> movies = [];
  bool isLoading = true;
  int movieShownIndex = 0;
  bool matchFound = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Selection'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Dismissible(
          key: Key(movies[movieShownIndex]['id'].toString()),
          child: ListView(
            children: [
              Image.network(
                  '${HttpHelper.tmdbImageBaseUrl}/${movies[movieShownIndex]['poster_path']}'),
              Text(movies[movieShownIndex]['title']),
              Text(movies[movieShownIndex]['release_date']),
              Text(movies[movieShownIndex]['vote_average'].toString())
            ],
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('No!'), duration: Duration(milliseconds: 1)),
              );
              _voteMovie(movies[movieShownIndex]['id'], false);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Yes!'), duration: Duration(milliseconds: 1)),
              );
              _voteMovie(movies[movieShownIndex]['id'], true);
            }

            setState(() {
              if ((movies.length - 1) == movieShownIndex) {
                _fetchMovies();
              }
              movieShownIndex = movieShownIndex + 1;
            });
          },
        ),
      ),
    );
  }

  Future<void> _fetchMovies() async {
    final response = await HttpHelper.fetchMovies(page);
    final newMovies = (response['results'] as List<dynamic>)
        .map((item) => item as Map<String, dynamic>)
        .toList();

    setState(() {
      movies.addAll(newMovies);
      isLoading = false;
      page = page + 1;
    });

    if (kDebugMode) {
      print(movies);
    }
  }

  Future<void> _voteMovie(int movieId, bool vote) async {
    String? sessionId = Provider.of<AppState>(context, listen: false).sessionId;
    final response = await HttpHelper.voteMovie(sessionId, movieId, vote);

    setState(() {
      matchFound = (response['data']['match']);
    });

    if (kDebugMode) {
      print(matchFound);
    }
  }
}
