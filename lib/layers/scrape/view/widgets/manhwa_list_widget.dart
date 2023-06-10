import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manhwa_alert/layers/scrape/view/widgets/expandable_manhwa_row_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ManhwaListWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const ManhwaListWidget({
    super.key,
    required this.data,
  });

  @override
  State<ManhwaListWidget> createState() => _ManhwaListWidgetState();
}

class _ManhwaListWidgetState extends State<ManhwaListWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: widget.data.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final website = widget.data[index]['website'];
          final manhwaData = widget.data[index]['manhwa_data'];
          return ExpandableManhwaRowWidget(
              website: website, manhwaData: manhwaData);
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 20,
          );
        },
      ),
    );
  }

  Widget _buildRowOfCovers() {
    return ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          // final website = value['website'];
          final manhwaData = widget.data[index]['manhwa_data'];

          // final title = manhwaData['title'];
          final coverLink = manhwaData['cover_link'];

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            child: Image.network(
              coverLink,
              fit: BoxFit.fitHeight,
              width: MediaQuery.of(context).size.width * 0.30,
              height: 150,
            ),
          );
        });
  }

  
}
