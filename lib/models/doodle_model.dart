class DoodleModel {
  String? username;
  String? doodleVectors;
  String? location;
  String? description;

  DoodleModel(
      {this.username, this.doodleVectors, this.location, this.description});

  // receiving data from server
  factory DoodleModel.fromMap(map) {
    return DoodleModel(
      username: map['username'],
      location: map['location'],
      description: map['description'],
      doodleVectors: map['doodleVectors'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'desciption': description,
      'doodleVectors': doodleVectors,
      'username': username,
    };
  }
}
