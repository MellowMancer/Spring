import 'package:flutter/material.dart';

class TriviaPage extends StatefulWidget {
  const TriviaPage({Key? key}) : super(key: key);

  static const String routeName = '/triviapage';

  @override
  State<TriviaPage> createState() => _TriviaPageState();
}

class _TriviaPageState extends State<TriviaPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _words = [
    'When is a good time to wake up?',
    'Dart',
    'Android',
    'iOS',
    'React',
    'Swift',
    'Kotlin',
    'Java',
    'C#',
    'JavaScript',
    'Flutter',
    
  ];

  Map<String, String> _wordInfo = {
    'Flutter': 'Flutter is an open-source UI software development kit created by Google.',
    'Dart': 'Dart is a programming language designed for client development, such as for the web and mobile apps.',
    'When is a good time to wake up?':'07 am is a very good time to wake up, KINDLY START IMPLEMENTING IT AND HAVE A GOOD SLEEP SCHEDULE YATHARTH WAZIR !!'
  };

  List<String> _filteredWords = [];

  @override
  void initState() {
    super.initState();
    _filteredWords = _words;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String searchText = _searchController.text;
    if (searchText.isEmpty) {
      setState(() {
        _filteredWords = _words;
      });
    } else {
      setState(() {
        _filteredWords = _words
            .where((word) => word.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
        appBar: AppBar(
        title: Container(
          width: double.infinity,
          height:   40,
          color: Colors.white,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  // Clear the search field
                  _searchController.clear();
                },
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredWords.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(_filteredWords[index]),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_wordInfo[_filteredWords[index]] ?? ''),
              ),
            ],
          );
        },
      ),
    ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}
