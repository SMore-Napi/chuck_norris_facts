import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../fact_model.dart';

class PreviousFacts extends StatelessWidget {
  final List<FactResponseModel> _facts;
  final ScrollController _controller;

  const PreviousFacts(this._facts, this._controller, {Key? key})
      : super(key: key);

  void _openJokeInBrowser(index) async {
    String _url = _facts[index].url;
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    final double _heightSize = MediaQuery.of(context).size.height / 5;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Previous facts"),
        ),
        SizedBox(
          height: _heightSize,
          child: ListView.builder(
              itemCount: _facts.length,
              controller: _controller,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    //leading: Icon(Icons.arrow_right),
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
      ],
    );
  }
}
