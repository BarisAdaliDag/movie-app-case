// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
  id: json['_id'] as String,
  title: json['title'] as String,
  year: json['year'] as String,
  rated: json['rated'] as String,
  released: json['released'] as String,
  runtime: json['runtime'] as String,
  genre: json['genre'] as String,
  director: json['director'] as String,
  writer: json['writer'] as String,
  actors: json['actors'] as String,
  plot: json['plot'] as String,
  language: json['language'] as String,
  country: json['country'] as String,
  awards: json['awards'] as String,
  poster: json['poster'] as String,
  metascore: json['metascore'] as String,
  imdbRating: json['imdbRating'] as String,
  imdbVotes: json['imdbVotes'] as String,
  imdbID: json['imdbID'] as String,
  type: json['type'] as String,
  response: json['response'] as String,
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  comingSoon: json['comingSoon'] as bool,
  isFavorite: json['isFavorite'] as bool,
);

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'year': instance.year,
      'rated': instance.rated,
      'released': instance.released,
      'runtime': instance.runtime,
      'genre': instance.genre,
      'director': instance.director,
      'writer': instance.writer,
      'actors': instance.actors,
      'plot': instance.plot,
      'language': instance.language,
      'country': instance.country,
      'awards': instance.awards,
      'poster': instance.poster,
      'metascore': instance.metascore,
      'imdbRating': instance.imdbRating,
      'imdbVotes': instance.imdbVotes,
      'imdbID': instance.imdbID,
      'type': instance.type,
      'response': instance.response,
      'images': instance.images,
      'comingSoon': instance.comingSoon,
      'isFavorite': instance.isFavorite,
    };
