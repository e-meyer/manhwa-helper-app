import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
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

                  var size = MediaQuery.of(context).size;

                  /*24 is for notification bar on Android*/
                  final double itemHeight =
                      (size.height - kToolbarHeight - 24) / 2;
                  final double itemWidth = size.width / 2;
                  final scanlators = snapshot.data!.docs;

                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                    shrinkWrap: true,
                    childAspectRatio: (1 / 1.25),
                    children: List.generate(scanlators.length, (index) {
                      final scanlator = scanlators[index];
                      final scanlatorData =
                          scanlator.data() as Map<String, dynamic>;

                      return Container(
                        height: 1000,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(int.parse(
                              '0xFF${scanlatorData['card_bg_color']}')),
                        ),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Image.network(
                                  scanlatorData['logo_url'],
                                  height: 150,
                                  width: 150,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  scanlatorData['name'],
                                  style: GoogleFonts.overpass(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
