import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class CrewMembersScreen extends StatelessWidget {
  final int crewId;

  CrewMembersScreen({Key? key, required this.crewId}) : super(key: key);

  Future<List<dynamic>> fetchCrewMembers() async {
    final response = await http.get(Uri.parse('https://api.api-onepiece.com/v2/characters/fr/crew/$crewId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load crew members');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membres de l\'équipage'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchCrewMembers(),
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
              var member = snapshot.data![index];
              String name = member['name'] ?? 'Nom inconnu';
              String job = member['job'] ?? 'Rôle inconnu';
              return ListTile(
                title: Text(name),
                subtitle: Text(job),
              );
            },
          );
        },
      ),
    );
  }
}
