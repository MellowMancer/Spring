import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TriviaPage extends StatefulWidget {
  const TriviaPage({Key? key}) : super(key: key);

  static const String routeName = '/triviapage';

  @override
  State<TriviaPage> createState() => _TriviaPageState();
}

class _TriviaPageState extends State<TriviaPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _words = [];
  Map<String, String> _wordInfo = {};
  Map<String, String> _wordSource = {};
  List<String> _filteredWords = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchDataFromFirestore();
  }

  void _fetchDataFromFirestore() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('glossary').get();
    setState(() {
      _words = querySnapshot.docs.map((doc) => doc['qst'] as String).toList();
      _wordInfo = querySnapshot.docs.fold<Map<String, String>>({},
          (previousValue, element) {
        previousValue[element['qst']] = element['ans'] as String;
        return previousValue;
      });
      _wordSource = querySnapshot.docs.fold<Map<String, String>>({},
          (previousValue, element) {
        previousValue[element['qst']] = element['src'] as String;
        return previousValue;
      });
      _filteredWords = _words;
    });
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
            .where(
                (word) => word.toLowerCase().contains(searchText.toLowerCase()))
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
            height: 40,
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      children: [
                        Text(_wordInfo[_filteredWords[index]] ?? '', textAlign: TextAlign.justify,),
                        const SizedBox(height: 5),
                        Text(_wordSource[_filteredWords[index]] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.left,),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
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
