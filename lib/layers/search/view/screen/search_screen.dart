import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final String scanlatorName;
  final String scanlatorLogoUrl;

  const SearchScreen({
    super.key,
    required this.scanlatorName,
    required this.scanlatorLogoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.network(
            //   scanlatorLogoUrl,
            //   height: 150,
            //   width: 150,
            // ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'AIDNFIDAHNFGIADNHGOIDA',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('Add search functionality here'),
          ],
        ),
      ),
    );
  }
}
