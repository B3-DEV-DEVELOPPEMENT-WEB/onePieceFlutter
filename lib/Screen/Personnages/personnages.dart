import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Crews/CrewMembersScreen.dart';

class Crew {
  final int id;
  final String name;
  final String description;  // Nouveau champ pour la description

  Crew({required this.id, required this.name, required this.description});

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? 'No description available', // Utilisation de ?? pour gérer les valeurs null
    );
  }
}


class CrewsScreen extends StatefulWidget {
  const CrewsScreen({Key? key}) : super(key: key);

  @override
  _CrewsScreenState createState() => _CrewsScreenState();
}

class _CrewsScreenState extends State<CrewsScreen> {
  late Future<List<Crew>> futureCrews;

  @override
  void initState() {
    super.initState();
    futureCrews = fetchCrews();
  }

  Future<List<Crew>> fetchCrews() async {
    final response = await http.get(Uri.parse('https://api.api-onepiece.com/v2/crews/fr'));
    if (response.statusCode == 200) {
      List<dynamic> crewsJson = jsonDecode(response.body);
      return crewsJson.map((json) => Crew.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load crews');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Crew>>(
      future: futureCrews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            Crew crew = snapshot.data![index];
            return ListTile(
              title: Text(crew.name),
              subtitle: Text(crew.description),  // Afficher la description ici
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CrewMembersScreen(crewId: crew.id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
