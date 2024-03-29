import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manhwa_alert/core/injector/service_locator.dart';
import 'package:manhwa_alert/layers/search/view/widgets/scanlator_selection_screen/custom_scanlator_item.dart';

import '../../../common/widgets/arc/two_rotating_arc.dart';

class ScanlatorSelectionScreen extends StatelessWidget {
  ScanlatorSelectionScreen({super.key});
  final FirebaseFirestore _db = serviceLocator.get<FirebaseFirestore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select the scanlator',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _db.collection('scanlators').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error retrieving data');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 50.0),
                      child: Center(
                        child: TwoRotatingArc(
                          size: 40,
                          color: Color(0xFFFF6812),
                        ),
                      ),
                    );
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

                      return CustomScanlatorItem(
                        scanlatorData: scanlatorData,
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
