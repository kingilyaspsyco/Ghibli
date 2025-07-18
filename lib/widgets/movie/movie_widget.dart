
import 'package:flutter/material.dart';
import 'package:ghibli/models/movie.dart';
import 'package:ghibli/services/movies_api_service.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class MovieWidget extends StatelessWidget {
  final String? id;

  const MovieWidget({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: MoviesApiService().getMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur de chargement des données'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('Aucun film trouvé'));
        }

        final movies = snapshot.data!;
        final movie = movies.firstWhere((m) => m.id == id, orElse: () => Movie(
          id: '',
          title: 'Non trouvé',
          original_title: '',
          original_title_romanised: '',
          image: '',
          movie_banner: '',
          description: '',
          director: '',
          producer: '',
          release_date: '',
          running_time: '',
          rt_score: '0',
        ));

        if (movie.id == '') {
          return Center(child: Text('Film non trouvé'));
        }

        double rating = 0;
        try {
          rating = double.parse(movie.rt_score ?? '0') / 20.0;
        } catch (_) {}

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: movie.image != null && movie.image!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(movie.image!, fit: BoxFit.cover),
                      )
                    : Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.image_not_supported)),
                      ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title ?? '',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if ((movie.original_title ?? '').isNotEmpty)
                      Text('Titre original : ${movie.original_title}'),
                    if ((movie.original_title_romanised ?? '').isNotEmpty)
                      Text('Romanisé : ${movie.original_title_romanised}'),
                    const SizedBox(height: 12),
                    if ((movie.description ?? '').isNotEmpty)
                      Text(movie.description ?? ''),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 18),
                        const SizedBox(width: 4),
                        Text('Réalisateur : ${movie.director ?? ''}'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.business, size: 18),
                        const SizedBox(width: 4),
                        Text('Producteur : ${movie.producer ?? ''}'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18),
                        const SizedBox(width: 4),
                        Text('Sortie : ${movie.release_date ?? ''}'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 18),
                        const SizedBox(width: 4),
                        Text('Durée : ${movie.running_time ?? ''} min'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Note : ', style: TextStyle(fontSize: 14)),
                        RatingStars(
                          value: rating,
                          starCount: 5,
                          starSize: 24,
                          valueLabelVisibility: false,
                          maxValue: 5,
                          starColor: Colors.amber,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            '(${movie.rt_score ?? '0'}/100)',
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
