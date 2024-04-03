import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Home'),
    Text('Index 1: Business'),
    Text('Index 2: School'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset('assets/video.png', width: 45, height: 45),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/onepiece.png', width: 45, height: 45),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/characters.png', width: 45, height: 45),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Utilisation d'une couleur spécifique pour la barre de navigation inférieure
        onTap: _onItemTapped,
      ),
    );
  }
}
