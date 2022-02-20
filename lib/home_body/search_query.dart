import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import '../fact_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final myController = TextEditingController();
  final String _baseURL = 'https://api.chucknorris.io/jokes/search?query=';
  List<FactResponseModel> _facts = [];

  Future<void> _requestFacts(String query) async {
    String urlTrailing = query.replaceAll(" ", "%20");
    final response = await get(Uri.parse('$_baseURL$urlTrailing'));
    if (response.statusCode == 200) {
      List<FactResponseModel> factsList;
      factsList = (json.decode(response.body)["result"] as List)
          .map((i) => FactResponseModel.fromJson(i))
          .toList();
      setState(() {
        _facts = factsList;
      });
    } else {
      setState(() {
        _facts = [];
      });
    }
  }

  void _openJokeInBrowser(index) async {
    String _url = _facts[index].url;
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              textInputAction: TextInputAction.done,
              controller: myController,
              onSubmitted: (String query) {
                _requestFacts(query);
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send_rounded),
                    onPressed: () {
                      _requestFacts(myController.text);
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
            itemCount: _facts.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  trailing: IconButton(
                    icon: const Icon(Icons.open_in_browser),
                    tooltip: 'Open a single joke page in a browser',
                    onPressed: () {
                      _openJokeInBrowser(index);
                    },
                  ),
                  title: Text(_facts[index].value));
            }),
      ),
    );
  }
}
