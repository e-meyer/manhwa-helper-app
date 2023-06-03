import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScrapeScreen extends StatefulWidget {
  const ScrapeScreen({super.key});

  @override
  State<ScrapeScreen> createState() => _ScrapeScreenState();
}

class _ScrapeScreenState extends State<ScrapeScreen> {
  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/scrape'));

    List<dynamic> decodedData = jsonDecode(response.body);
    if (decodedData is List<dynamic>) {
      return decodedData.cast<Map<String, dynamic>>();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manhwa Titles'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Map<String, dynamic>> manhwaData = snapshot.data!;
            return ListView.builder(
              itemCount: manhwaData.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> item = manhwaData[index];
                String website = item['website'];
                List<dynamic> manhwaTitles = item['manhwa_titles'];

                return ListTile(
                  title: Text(website),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: manhwaTitles.map((title) {
                      return Text(title);
                    }).toList(),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
