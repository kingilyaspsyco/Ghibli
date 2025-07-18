import 'package:flutter/material.dart';
import 'package:ghibli/models/movie.dart';
import 'package:ghibli/services/movies_api_service.dart';
import 'package:go_router/go_router.dart';

class MoviesListWidget extends StatelessWidget {
  const MoviesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    /*
      débogage :
        print : déboguer des données simples
        inspect : déboguer des données complexes (Map et List)
    */
    // inspect(MoviesApiService().getMovies());

    return Column(
      children: [
        Text('Movies', style: Theme.of(context).textTheme.titleMedium),

        FutureBuilder(
          future: MoviesApiService().getMovies(),
          builder: (context, snapshot) {

            if (snapshot.hasData) {
              List<Movie> movies = snapshot.requireData;

              return ListView.builder(
                shrinkWrap: true,

                itemCount: movies.length,


                physics: NeverScrollableScrollPhysics(),

                itemBuilder: (context, index) {

                  return ListTile(
                    leading: Image.network(
                      movies[index].movie_banner!,
                      width: 80,
                    ),
                    title: Text(movies[index].title!),
                    subtitle: Text(movies[index].original_title!),
                    trailing: Icon(Icons.chevron_right),


                    onTap: () => context.push('/movie/${movies[index].id}'),
                  );
                },
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ],
    );
  }
}
