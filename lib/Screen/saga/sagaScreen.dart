import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      id: json['id'],
      title: json['title'],
      sagaNumber: json['saga_number'],
      sagaChapter: json['saga_chapitre'],
      sagaVolume: json['saga_volume'],
      sagaEpisode: json['saga_episode'],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sagas'), // Titre de la page
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
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Saga saga = snapshot.data![index];
                return ListTile(
                  title: Text(saga.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Numéro de saga : ${saga.sagaNumber}'),
                      Text('Chapitre de saga : ${saga.sagaChapter}'),
                      Text('Volume de saga : ${saga.sagaVolume}'),
                      Text('Episode de saga : ${saga.sagaEpisode}'),
                    ],
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