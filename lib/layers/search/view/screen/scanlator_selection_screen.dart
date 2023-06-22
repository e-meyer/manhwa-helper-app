import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manhwa_alert/layers/search/models/scanlator_model.dart';
import 'package:manhwa_alert/layers/search/view/screen/search_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ScanlatorSelectionScreen extends StatelessWidget {
  const ScanlatorSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select the scanlator',
          style: GoogleFonts.overpass(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF222222),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          final scanlator =
                              ScanlatorModel.fromMap(scanlatorData);
                          PersistentNavBarNavigator
                              .pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: '/search'),
                            screen: SearchScreen(scanlator: scanlator),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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
