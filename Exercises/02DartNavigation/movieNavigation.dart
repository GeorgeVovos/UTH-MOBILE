import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(home: MovieTitlePage()));

class MovieTitlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Επιλογές')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Επιλογές', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            _buildNavigationTile(context, 'Περίληψη ταινίας', MovieDataType.overview, 'Λήψη περίληψης'),
            _buildNavigationTile(context, 'Λεπτομέρειες ταινίας', MovieDataType.details, 'Λήψη λεπτομερειών'),
          ],
        ),
      ),
      body: const Center(child: Text('Επιλέξτε μια επιλογή από το μενού')),
    );
  }

  ListTile _buildNavigationTile(BuildContext context, String title, MovieDataType dataType, String buttonText) {
    return ListTile(
      title: Text(title),
      onTap:
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => MoviePage(title: title, dataType: dataType, buttonText: buttonText))),
    );
  }
}

enum MovieDataType { overview, details }

class MovieService {
  static const String apiKey = 'XXXXXXXXXXXX';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static Future<String> getMovieData(String movieName, MovieDataType type) async {
    final url = '$baseUrl/search/movie?api_key=$apiKey&query=$movieName';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isEmpty) return 'Η ταινία δεν βρέθηκε.';

        final movie = data['results'][0];
        return type == MovieDataType.overview
            ? movie['overview'] ?? 'Δεν υπάρχει περίληψη.'
            : 'Popularity: ${movie['popularity']}\nVote Average: ${movie['vote_average']}\nVote Count: ${movie['vote_count']}';
      }
      return 'Αποτυχία λήψης δεδομένων.';
    } catch (e) {
      return 'Συνέβη κάποιο λάθος: $e';
    }
  }
}

class MoviePage extends StatefulWidget {
  final String title;
  final MovieDataType dataType;
  final String buttonText;
  const MoviePage({required this.title, required this.dataType, required this.buttonText});

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Εισάγετε το όνομα της ταινίας', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_controller.text.isEmpty) {
                  setState(() => _result = 'Εισάγετε το όνομα της ταινίας');
                  return;
                }
                final result = await MovieService.getMovieData(_controller.text, widget.dataType);
                setState(() => _result = result);
              },
              child: Text(widget.buttonText),
            ),
            const SizedBox(height: 16),
            Expanded(child: SingleChildScrollView(child: Text(_result))),
          ],
        ),
      ),
    );
  }
}
