import 'package:flutter/material.dart';
import 'movie_list.dart';

void main() => runApp(MyMovies());

class MyMovies extends StatelessWidget {
  const MyMovies({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Movies',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Home(),
        debugShowCheckedModeBanner: false,
    );
  }
}
class Home extends StatelessWidget{
const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return MovieList();
  }
}