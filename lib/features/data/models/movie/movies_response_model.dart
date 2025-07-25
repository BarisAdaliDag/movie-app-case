import 'package:json_annotation/json_annotation.dart';
import 'package:movieapp/features/data/models/movie/movie_model.dart';
import 'package:movieapp/features/data/models/movie/pagination_model.dart';

part 'movies_response_model.g.dart';

@JsonSerializable()
class MoviesResponseModel {
  @JsonKey(name: 'movies')
  final List<MovieModel> movies;
  @JsonKey(name: 'pagination')
  final PaginationModel pagination;

  MoviesResponseModel({required this.movies, required this.pagination});

  factory MoviesResponseModel.fromJson(Map<String, dynamic> json) => _$MoviesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MoviesResponseModelToJson(this);
}
