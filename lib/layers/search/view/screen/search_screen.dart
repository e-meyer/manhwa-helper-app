import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('scanlators')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error retrieving data');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final scanlators = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: scanlators.length,
                  itemBuilder: (context, index) {
                    final scanlator = scanlators[index];
                    final scanlatorData =
                        scanlator.data() as Map<String, dynamic>;

                    return ListTile(
                      leading: Image.network(scanlatorData['logo_url']),
                      title: Text(scanlatorData['name']),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
