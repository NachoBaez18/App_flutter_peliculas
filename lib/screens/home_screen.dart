import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Peliculas en cines'),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () => 
                showSearch(context: context,
                 delegate:MovieSearchDelegate(),
                ) ,
                 icon: const Icon(Icons.search_outlined))
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            //tarjetas principales
            CardSwiper(movies:moviesProvider.onDisPlayMovie),
            //slider peliculas
            MovieSlider(
              movies:moviesProvider.popularMovie,
              title:'Populares',
              onNextPage: () => moviesProvider.getPopularMovie(),
              ),
          ],
        )));
  }
}
