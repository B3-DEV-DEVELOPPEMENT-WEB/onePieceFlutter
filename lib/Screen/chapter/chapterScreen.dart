import 'package:flutter/material.dart';
import 'package:onepieceflutter/Screen/saga/sagaScreen.dart';

class ChapterScreen extends StatelessWidget {
  final Saga saga; // Ajouter un paramètre Saga pour accepter la saga passée

  const ChapterScreen({Key? key, required this.saga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(saga.title), // Utiliser le titre de la saga comme titre de la page
      ),
      body: Center(
        child: Text(
          'Chapitre de saga : ${saga.sagaChapter}\n'
              'Volume de saga : ${saga.sagaVolume}\n'
              'Episode de saga : ${saga.sagaEpisode}\n',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

