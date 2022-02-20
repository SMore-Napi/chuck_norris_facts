import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'fact_model.dart';
import 'home_body/categories.dart';
import 'home_body/current_fact.dart';
import 'home_body/search_query.dart';
import 'home_body/previous_facts.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  final String _baseURL = 'https://api.chucknorris.io/jokes/';
  FactResponseModel _currentFact = FactResponseModel(url: '', value: '');
  final List<FactResponseModel> _factsHistory = [];
  String _currentCategory = "random";
  final List<String> _categoriesList = ["random"];
  String _imageName = 'default';
  ScrollController controller = ScrollController();

  Future<FactResponseModel> _requestFact() async {
    String urlTrailing = _currentCategory != 'random'
        ? "random?category=$_currentCategory"
        : "random";
    final response = await get(Uri.parse('$_baseURL$urlTrailing'));
    return FactResponseModel.fromJson(
        jsonDecode(response.body) as Map<String, Object?>);
  }

  Future<List<String>> _requestCategoriesList() async {
    String urlTrailing = "categories";
    final response = await get(Uri.parse('$_baseURL$urlTrailing'));
    return (jsonDecode(response.body) as List<dynamic>).cast<String>();
  }

  void _getNewFact() {
    setState(() {
      if (_currentFact.value != "") {
        if (!_factsHistory
            .map((e) => e.value)
            .toList()
            .contains(_currentFact.value)) {
          _factsHistory.add(_currentFact);
        }
      }
      _requestFact().then((response) => _currentFact =
          FactResponseModel(url: response.url, value: response.value));
      controller.animateTo(
        controller.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 100),
      );
    });
  }

  void _updateCategory(String category) {
    const availableImages = [
      "animal",
      "career",
      "celebrity",
      "dev",
      "explicit",
      "fashion",
      "food",
      "history",
      "money",
      "movie",
      "music",
      "political",
      "religion",
      "science",
      "sport",
      "travel"
    ];
    setState(() {
      _currentCategory = category;
      _imageName = availableImages.contains(category) ? category : "default";
    });
    _getNewFact();
  }

  @override
  initState() {
    super.initState();
    _requestCategoriesList().then((value) => _categoriesList.addAll(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Free text search',
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SearchPage())),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'About',
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationVersion: '1.0.0',
                  applicationName: 'Chuck Norris Facts',
                  children: [
                    const Text("Assignment 1"),
                    const Text("Flutter course. Innopolis University",
                        style: TextStyle(fontStyle: FontStyle.italic)),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "Roman Soldatov",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              PreviousFacts(_factsHistory, controller),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 8.0),
                child: CurrentFact(_currentFact, _imageName),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                child: Text("Category: $_currentCategory"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _getNewFact();
                  },
                  child: const Text('New fact'),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.edit),
          tooltip: 'Change category',
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Categories(_updateCategory, _categoriesList);
              },
            );
          },
        ));
  }
}
