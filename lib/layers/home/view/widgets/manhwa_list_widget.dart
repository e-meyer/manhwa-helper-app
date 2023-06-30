import 'package:flutter/material.dart';
import 'package:manhwa_alert/layers/home/view/widgets/expandable_manhwa_row_widget.dart';

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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.data.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final website = widget.data[index]['website'];
          final manhwaData = widget.data[index]['manhwa_data'];
          return ExpandableManhwaRowWidget(
              website: website, manhwaData: manhwaData);
        },
      ),
    );
  }
}
