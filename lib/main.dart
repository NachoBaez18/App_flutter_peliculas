import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/screens/screeens.dart';
import 'package:provider/provider.dart';


void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(create:( _ ) => MoviesProvider(),lazy: false,)
      ],
      child:const MyApp(),
      );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas',
      initialRoute: 'home',
      routes: {
        'home':(_) => HomeScreen(),
        'detail':(_) => DetailScreen()
      },
      theme: ThemeData.light().copyWith(
        appBarTheme:const AppBarTheme(
          color:Colors.indigo
        )
      ),
    );
  }
}