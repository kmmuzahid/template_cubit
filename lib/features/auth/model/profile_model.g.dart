// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  address: json['address'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  zip: json['zip'] as String,
  country: json['country'] as String,
  profileImage: json['profileImage'] as String,
  coverImage: json['coverImage'] as String,
  bio: json['bio'] as String,
  website: json['website'] as String,
  twitter: json['twitter'] as String,
  linkedin: json['linkedin'] as String,
  instagram: json['instagram'] as String,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'zip': instance.zip,
      'country': instance.country,
      'profileImage': instance.profileImage,
      'coverImage': instance.coverImage,
      'bio': instance.bio,
      'website': instance.website,
      'twitter': instance.twitter,
      'linkedin': instance.linkedin,
      'instagram': instance.instagram,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
