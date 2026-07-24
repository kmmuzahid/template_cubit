import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String zip;
  final String country;
  final String profileImage;
  final String coverImage;
  final String bio;
  final String website;
  final String twitter;
  final String linkedin;
  final String instagram;
  final String createdAt;
  final String updatedAt;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
    required this.profileImage,
    required this.coverImage,
    required this.bio,
    required this.website,
    required this.twitter,
    required this.linkedin,
    required this.instagram,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
