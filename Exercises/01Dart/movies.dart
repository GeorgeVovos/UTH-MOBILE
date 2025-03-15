class Film {
  String _director;
  List<String> _actors;
  String _title;

  //Minor change from the description so we don't have to maintain a separate "counter" variable.
  List<double> scores = List.empty(growable: true);

  String get director => _director;
  String get title => _title;
  List<String> get actors => _actors;

  Film(this._director, this._title, this._actors);

  void addRating(double rating) {
    if (rating >= 0 && rating <= 5) {
      scores.add(rating);
    }
  }

  double get averageRating => scores.isNotEmpty ? scores.fold(0.0, (previous, current) => previous + current) / scores.length : -1;

  @override
  String toString() {
    return 'Title: $title\nDirector: $director\nScore: ${averageRating == -1 ? "No ratings yet" : averageRating.toStringAsFixed(1)}\nActors:\n\t${actors.join("\n\t")}';
  }
}

void main() {
  Film inferno = Film("Ron Howard", "Inferno", ["Tom Hanks", "Felicity Jones", "Omar Sy"]);
  inferno.addRating(5);
  inferno.addRating(4);
  inferno.addRating(3);

  print(inferno);
}
