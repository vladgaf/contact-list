import 'package:flutter/foundation.dart';

class Contact {
  String name;
  String surname;
  String photo;
  String phoneNumber;
  String country;
  String city;
  String street;

  Contact(
      {required this.photo,
      required this.name,
      required this.surname,
      required this.phoneNumber,
      required this.country,
      required this.city,
      required this.street});

  factory Contact.fromJson(Map<String, dynamic> parsedJson) {
    return Contact(
        photo: Picture.fromJson(parsedJson['picture']).large,
        name: Name.fromJson(parsedJson['name']).first,
        surname: Name.fromJson(parsedJson['name']).last,
        phoneNumber: parsedJson['phone'],
        country: Location.fromJson(parsedJson['location']).country,
        city: Location.fromJson(parsedJson['location']).city,
        street: Location.fromJson(parsedJson['location']).street);
  }
}

class Picture {
  String medium;
  String large;

  Picture({required this.medium, required this.large});

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      medium: json["medium"] as String,
      large: json["large"] as String,
    );
  }
}

class Name {
  String first;
  String last;

  Name({required this.first, required this.last});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      first: json["first"] as String,
      last: json["last"] as String,
    );
  }
}

class Location {
  String country;
  String city;
  String street;

  Location({required this.country, required this.city, required this.street});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        country: json["country"] as String,
        city: json["city"] as String,
        street: Street.fromJson(json["street"]).name);
  }
}

class Street {
  String name;

  Street({required this.name});

  factory Street.fromJson(Map<String, dynamic> json) {
    return Street(
      name: json["name"] as String,
    );
  }
}
