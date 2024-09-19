class PlacesResponse {
  List<Place> places;
  String? nextPageToken;

  PlacesResponse({
    required this.places,
    required this.nextPageToken,
  });

  factory PlacesResponse.fromJson(Map<String, dynamic> json) {
    return PlacesResponse(
      places:
          (json['places'] as List).map((item) => Place.fromJson(item)).toList(),
      nextPageToken: json['nextPageToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'places': places.map((place) => place.toJson()).toList(),
      'nextPageToken': nextPageToken,
    };
  }
}

class Place {
  final String nationalPhoneNumber;
  final String formattedAddress;
  final Location location;
  final double? rating;
  final int? userRatingCount;
  final String googleMapsUri;
  final RegularOpeningHours? regularOpeningHours;
  final DisplayName displayName;

  Place({
    required this.nationalPhoneNumber,
    required this.formattedAddress,
    required this.location,
    this.rating,
    this.userRatingCount,
    required this.googleMapsUri,
    this.regularOpeningHours,
    required this.displayName,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      nationalPhoneNumber: json['nationalPhoneNumber'],
      formattedAddress: json['formattedAddress'],
      location: Location.fromJson(json['location']),
      rating: json['rating'],
      userRatingCount: json['userRatingCount'],
      googleMapsUri: json['googleMapsUri'],
      regularOpeningHours: json['regularOpeningHours'] != null
          ? RegularOpeningHours.fromJson(json['regularOpeningHours'])
          : null,
      displayName: DisplayName.fromJson(json['displayName']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nationalPhoneNumber': nationalPhoneNumber,
      'formattedAddress': formattedAddress,
      'location': location.toJson(),
      'rating': rating,
      'googleMapsUri': googleMapsUri,
      'regularOpeningHours': regularOpeningHours?.toJson(),
      'displayName': displayName.toJson(),
    };
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class RegularOpeningHours {
  final List<String> weekdayDescriptions;

  RegularOpeningHours({
    required this.weekdayDescriptions,
  });

  factory RegularOpeningHours.fromJson(Map<String, dynamic> json) {
    return RegularOpeningHours(
      weekdayDescriptions: List<String>.from(json['weekdayDescriptions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekdayDescriptions': weekdayDescriptions,
    };
  }
}

class DisplayName {
  final String text;
  final String languageCode;

  DisplayName({
    required this.text,
    required this.languageCode,
  });

  factory DisplayName.fromJson(Map<String, dynamic> json) {
    return DisplayName(
      text: json['text'],
      languageCode: json['languageCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'languageCode': languageCode,
    };
  }
}
