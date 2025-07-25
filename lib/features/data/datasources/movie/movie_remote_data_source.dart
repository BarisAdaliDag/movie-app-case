import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/api_constants.dart';
import 'package:movieapp/core/network/network_client.dart';
import 'package:movieapp/features/data/datasources/movie/movie_datasource.dart';
import 'package:movieapp/features/data/models/movie/movie_model.dart';
import 'package:movieapp/features/data/models/movie/movies_response_model.dart';
import 'package:movieapp/features/data/models/movie/movies_with_pagination_model.dart';

class MovieRemoteDatasource implements MovieDatasource {
  final NetworkClient networkClient;

  MovieRemoteDatasource({required this.networkClient});

  @override
  Future<MoviesWithPaginationModel> getMovies({required String token, int page = 1}) async {
    final response = await networkClient.get(
      endpoint: '${ApiConstants.movieList}?page=$page',
      headers: {ApiConstants.authorization: token, 'accept': 'application/json'},
    );
    debugPrint(response.toString());

    final moviesResponseData = MoviesResponseModel.fromJson(response['data']);

    return MoviesWithPaginationModel(movies: moviesResponseData.movies, pagination: moviesResponseData.pagination);
  }

  @override
  Future<List<MovieModel>> getFavorites({required String token}) async {
    final response = await networkClient.get(
      endpoint: ApiConstants.movieFavorites,
      headers: {ApiConstants.authorization: token, 'accept': 'application/json'},
    );
    final favoritesJson = response['data'] as List;
    return favoritesJson.map((e) => MovieModel.fromJson(e)).toList();
  }

  @override
  Future<MovieModel> addFavorite({required String token, required String movieId}) async {
    final response = await networkClient.post(
      endpoint: '${ApiConstants.movieFavorite}/$movieId',
      headers: {ApiConstants.authorization: token, 'accept': 'application/json'},
      body: {}, // POST body boş
    );
    final movieJson = response['data']['movie'];
    return MovieModel.fromJson(movieJson);
  }
}
