import 'package:json_annotation/json_annotation.dart';

part 'pagination_model.g.dart';

@JsonSerializable()
class PaginationModel {
  @JsonKey(name: 'totalCount')
  final int totalCount;
  @JsonKey(name: 'perPage')
  final int perPage;
  @JsonKey(name: 'maxPage')
  final int maxPage;
  @JsonKey(name: 'currentPage')
  final int currentPage;

  PaginationModel({required this.totalCount, required this.perPage, required this.maxPage, required this.currentPage});

  factory PaginationModel.fromJson(Map<String, dynamic> json) => _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
}
