import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../fact_model.dart';

class CurrentFact extends StatelessWidget {
  final FactResponseModel _fact;
  final String _imageName;

  const CurrentFact(this._fact, this._imageName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Some strange formulas to fit image inside the screen and have enough space
    final double _factImageSizeHeight =
        (MediaQuery.of(context).size.height * 45) / 100;
    final double _factImageSizeWidth =
        (MediaQuery.of(context).size.width * 95) / 100;

    final double _factTextSizeHeight = (_factImageSizeHeight * 95) / 100;
    final double _factTextSizeWidth = (_factImageSizeWidth * 95) / 100;

    const double _fontSize = 28;

    return Column(
      children: <Widget>[
        Stack(children: <Widget>[
          Center(
            child: Image.asset(
              'assets/$_imageName.jpg',
              width: _factImageSizeWidth,
              height: _factImageSizeHeight,
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: SizedBox(
              height: _factTextSizeHeight,
              width: _factTextSizeWidth,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    children: <Widget>[
                      AutoSizeText(
                        _fact.value,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: _fontSize,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 4
                            ..color = Colors.black,
                        ),
                      ),
                      AutoSizeText(
                        _fact.value,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: _fontSize,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ]),
      ],
    );
  }
}
