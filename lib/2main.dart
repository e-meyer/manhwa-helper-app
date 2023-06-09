import 'package:flutter/material.dart';

import 'ignore/example_testing_widgets/expandable_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expandable Widget Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Expandable Widget Demo'),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ExpandableWidget();
            },
          ),
        ),
      ),
    );
  }
}
