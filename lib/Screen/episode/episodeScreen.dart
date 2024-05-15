import 'package:flutter/material.dart';

import '../saga/sagaScreen.dart';

class Episode {
  final int id;
  final String number;
  final String title;
  final String description;
  final String chapter;
  final String releaseDate;
  final int arcId;
  final int sagaId;
  final Saga saga;
  final Arc arc;

  Episode({
    required this.id,
    required this.number,
    required this.title,
    required this.description,
    required this.chapter,
    required this.releaseDate,
    required this.arcId,
    required this.sagaId,
    required this.saga,
    required this.arc,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] ?? 0,
      number: json['number'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      chapter: json['chapter'] ?? '',
      releaseDate: json['release_date'] ?? '',
      arcId: json['arcId'] ?? 0,
      sagaId: json['sagaId'] ?? 0,
      saga: json.containsKey('saga') ? Saga.fromJson(json['saga']) : Saga(
        id: 0,
        title: '',
        sagaNumber: '',
        sagaChapter: '',
        sagaVolume: '',
        sagaEpisode: '',
      ),
      arc: json.containsKey('arc') ? Arc.fromJson(json['arc']) : Arc(
        id: 0,
        arcTitle: '',
        arcDescription: '',
        sagaId: 0,
      ),
    );
  }
}

class Arc {
  final int id;
  final String arcTitle;
  final String arcDescription;
  final int sagaId;

  Arc({
    required this.id,
    required this.arcTitle,
    required this.arcDescription,
    required this.sagaId,
  });

  factory Arc.fromJson(Map<String, dynamic> json) {
    return Arc(
      id: json['id'] ?? 0,
      arcTitle: json['arc_title'] ?? '',
      arcDescription: json['arc_description'] ?? '',
      sagaId: json['sagaId'] ?? 0,
    );
  }
}

class EpisodeScreen extends StatelessWidget {
  final Saga saga;
  final List<Episode> episodes;

  const EpisodeScreen({super.key, required this.saga, required this.episodes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(saga.title),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: episodes.length,
        itemBuilder: (context, index) {
          Episode episode = episodes[index];
          return ListTile(
            title: Text('Épisode ${episode.number} : ${episode.title}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(episode.description),
                Text('Chapitre : ${episode.chapter}'),
                Text('Date de sortie : ${episode.releaseDate}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
