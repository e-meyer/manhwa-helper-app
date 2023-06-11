import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manhwa_alert/layers/search/view/screen/search_screen.dart';

class ScanlatorSelectionScreen extends StatelessWidget {
  const ScanlatorSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select the scanlator',
                style: GoogleFonts.overpass(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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

                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, 'search', arguments: {
                            'name': scanlatorData['name'],
                            'logo_url': scanlatorData['logo_url'],
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // color: Color(int.parse(
                            //     '0xFF${scanlatorData['card_bg_color']}')),
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
