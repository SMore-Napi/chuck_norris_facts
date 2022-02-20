import 'package:json_annotation/json_annotation.dart';

part 'fact_model.g.dart';

@JsonSerializable()
class FactResponseModel {
  final String url, value;

  FactResponseModel({required this.url, required this.value});

  factory FactResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FactResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$FactResponseModelToJson(this);
}
