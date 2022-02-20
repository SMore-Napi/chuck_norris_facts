import 'package:flutter/material.dart';
import 'home.dart';

class MaterialDesignApplication extends StatelessWidget {
  const MaterialDesignApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chuck Norris Facts',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const Home(title: 'Chuck Norris Facts'),
      //home: HomePage(),
    );
  }
}
