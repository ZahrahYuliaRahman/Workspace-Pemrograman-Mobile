import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import 'http_helper.dart';
import 'movie_detail.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  // String result;
  late HttpHelper helper;
  int moviesCount = 0;
  List movies = [];
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  Icon visibleIcon = Icon(Icons.search);
  Widget searchBar = Text('Movies');
  bool isLoading = true;

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return Scaffold(
      appBar: AppBar(
        title: searchBar,
        actions: <Widget>[
          IconButton(
            icon: visibleIcon,
            onPressed: () {
              setState(() {
                if (visibleIcon.icon == Icons.search) {
                  visibleIcon = Icon(Icons.cancel);
                  searchBar = TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: (String text) {
                      search(text);
                    },
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  );
                } else {
                  setState(() {
                    visibleIcon = Icon(Icons.search);
                    searchBar = Text('Movies');
                  });
                }
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: initialize,
        child:
            isLoading
                ? ListView.builder(
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int position) {
                    return Card(
                      color: Colors.white,
                      elevation: 2.0,
                      child: ListTile(
                        leading: Shimmer(
                          child: Container(
                            width: 47.0,
                            height: 47.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        title: Shimmer(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 300,
                              height: 20.0,
                              color: Colors.grey[400],
                              margin: EdgeInsets.only(top: 5.0),
                            ),
                          ),
                        ),
                        subtitle: Shimmer(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 100,
                              height: 20.0,
                              color: Colors.grey[300],
                              margin: EdgeInsets.only(top: 5.0),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
                : ListView.builder(
                  itemCount: moviesCount,
                  itemBuilder: (BuildContext context, int position) {
                    if (movies[position].posterPath != null) {
                      image = NetworkImage(
                        iconBase + movies[position].posterPath,
                      );
                    } else {
                      image = NetworkImage(defaultImage);
                    }
                    return Card(
                      color: Colors.white,
                      elevation: 2.0,
                      child: ListTile(
                        onTap: () {
                          MaterialPageRoute route = MaterialPageRoute(
                            builder: (_) => MovieDetail(movies[position]),
                          );
                          Navigator.push(context, route);
                        },
                        leading: CircleAvatar(backgroundImage: image),
                        title: Text(movies[position].title),
                        subtitle: Text(
                          '${'Released: ' + movies[position].releaseDate} - Vote: ${movies[position].voteAverage}',
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }

  Future search(text) async {
    setState(() {
      isLoading = true;
    });

    movies = await helper.findMovies(text);
    setState(() {
      moviesCount = movies.length;
      movies = movies;
      isLoading = false;
    });
  }

  Future initialize() async {
    setState(() {
      isLoading = true;
    });

    movies = [];
    movies = await helper.getUpcoming();
    setState(() {
      moviesCount = movies.length;
      movies = movies;
      isLoading = false;
    });
  }
}
