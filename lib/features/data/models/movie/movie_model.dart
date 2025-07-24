import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'Title')
  final String title;
  @JsonKey(name: 'Year')
  final String year;
  @JsonKey(name: 'Rated')
  final String rated;
  @JsonKey(name: 'Released')
  final String released;
  @JsonKey(name: 'Runtime')
  final String runtime;
  @JsonKey(name: 'Genre')
  final String genre;
  @JsonKey(name: 'Director')
  final String director;
  @JsonKey(name: 'Writer')
  final String writer;
  @JsonKey(name: 'Actors')
  final String actors;
  @JsonKey(name: 'Plot')
  final String plot;
  @JsonKey(name: 'Language')
  final String language;
  @JsonKey(name: 'Country')
  final String country;
  @JsonKey(name: 'Awards')
  final String awards;
  @JsonKey(name: 'Poster')
  final String poster;
  @JsonKey(name: 'Metascore')
  final String metascore;
  @JsonKey(name: 'imdbRating')
  final String imdbRating;
  @JsonKey(name: 'imdbVotes')
  final String imdbVotes;
  @JsonKey(name: 'imdbID')
  final String imdbID;
  @JsonKey(name: 'Type')
  final String type;
  @JsonKey(name: 'Response')
  final String response;
  @JsonKey(name: 'Images', defaultValue: <String>[])
  final List<String> images;
  @JsonKey(name: 'comingSoon', defaultValue: false)
  final bool comingSoon;
  @JsonKey(name: 'isFavorite', defaultValue: false)
  final bool isFavorite;

  MovieModel({
    required this.id,
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.writer,
    required this.actors,
    required this.plot,
    required this.language,
    required this.country,
    required this.awards,
    required this.poster,
    required this.metascore,
    required this.imdbRating,
    required this.imdbVotes,
    required this.imdbID,
    required this.type,
    required this.response,
    required this.images,
    required this.comingSoon,
    required this.isFavorite,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);
}
