import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../episode/episodeScreen.dart';

class Saga {
  final int id;
  final String title;
  final String sagaNumber;
  final String sagaChapter;
  final String sagaVolume;
  final String sagaEpisode;

  Saga({
    required this.id,
    required this.title,
    required this.sagaNumber,
    required this.sagaChapter,
    required this.sagaVolume,
    required this.sagaEpisode,
  });

  factory Saga.fromJson(Map<String, dynamic> json) {
    return Saga(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      sagaNumber: json['saga_number'] ?? '',
      sagaChapter: json['saga_chapitre'] ?? '',
      sagaVolume: json['saga_volume'] ?? '',
      sagaEpisode: json['saga_episode'] ?? '',
    );
  }
}

class SagaScreen extends StatefulWidget {
  const SagaScreen({super.key});

  @override
  _SagaScreenState createState() => _SagaScreenState();
}

class _SagaScreenState extends State<SagaScreen> {
  late Future<List<Saga>> futureSagas;

  @override
  void initState() {
    super.initState();
    futureSagas = fetchSagas();
  }

  Future<List<Saga>> fetchSagas() async {
    final response = await http.get(Uri.parse('https://api.api-onepiece.com/v2/sagas/fr'));
    if (response.statusCode == 200) {
      List<dynamic> sagasJson = jsonDecode(response.body);
      return sagasJson.map((json) => Saga.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sagas');
    }
  }

  Future<List<Episode>> fetchEpisodes(int sagaId) async {
    final response = await http.get(Uri.parse('https://api.api-onepiece.com/v2/episodes/fr/saga/$sagaId'));
    if (response.statusCode == 200) {
      List<dynamic> episodesJson = jsonDecode(response.body);
      return episodesJson.map((json) => Episode.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load episodes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sagas'),
      ),
      body: FutureBuilder<List<Saga>>(
        future: futureSagas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            List<Saga> sagas = snapshot.data!;
            return ListView.builder(
              itemCount: sagas.length,
              itemBuilder: (context, index) {
                Saga saga = sagas[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      saga.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Numéro de saga : ${saga.sagaNumber}'),
                        Text('Chapitre de saga : ${saga.sagaChapter}'),
                        Text('Volume de saga : ${saga.sagaVolume}'),
                        Text('Épisode de saga : ${saga.sagaEpisode}'),
                      ],
                    ),
                    onTap: () async {
                      List<Episode> episodes = await fetchEpisodes(saga.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EpisodeScreen(
                            saga: saga,
                            episodes: episodes,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Aucune saga trouvée'));
        },
      ),
    );
  }
}
