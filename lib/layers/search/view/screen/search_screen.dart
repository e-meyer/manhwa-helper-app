import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:manhwa_alert/layers/search/models/scanlator_model.dart';
import 'package:manhwa_alert/layers/search/view/widgets/search_screen/manhwa_search_result_list_builder.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  final ScanlatorModel scanlator;

  const SearchScreen({
    Key? key,
    required this.scanlator,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? _typingTimer;
  String _inputText = '';
  List<Map<String, String>> _webtoons = [];
  bool _isLoading = false;
  bool _isTyping = false;

  void onTextChanged(String input) {
    _webtoons = [];
    _typingTimer?.cancel();

    _typingTimer = Timer(const Duration(milliseconds: 1000), () {
      _isTyping = false;
      if (_inputText.isEmpty) {
        setState(() {
          _webtoons = [];
          _isLoading = false;
        });
        return;
      }
      _isLoading = true;

      final website =
          'http://10.0.2.2:5500/scanlator/${widget.scanlator.name.toLowerCase()}?s=$_inputText';

      getScanlatorQueriedData(website).then((webtoons) {
        setState(() {
          for (var item in webtoons) {
            print(item);
            _webtoons.add(Map<String, String>.from(item));
          }
          _isLoading = false;
        });
      }).catchError((error) {
        print('Error: $error');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred: $error'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    });
    _isTyping = true;
  }

  Future<List<Map<String, dynamic>>> getScanlatorQueriedData(
      String website) async {
    final response = await http.get(Uri.parse(website));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Searching in ${widget.scanlator.name}',
          style: GoogleFonts.overpass(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (text) {
                  setState(() {
                    _inputText = text;
                    print(_inputText);
                  });
                  onTextChanged(text);
                },
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  contentPadding: EdgeInsets.all(0),
                  fillColor: Color(0xFF292929),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none, // Remove the bottom outline
                  ),
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/icons/search.svg',
                      colorFilter: ColorFilter.mode(
                        Color(0xFF3E3E3E),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                style: GoogleFonts.overpass(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFBCBCBC),
                ),
                cursorColor: Color(0xFFFF6812),
              ),
              SizedBox(
                height: 20,
              ),
              (_webtoons.isEmpty && _inputText == '')
                  ? Center(
                      child: Text(
                      'ASD ASD ASD ASD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ))
                  : GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      shrinkWrap: true,
                      childAspectRatio: (1 / 1.45),
                      children: _webtoons.isNotEmpty
                          ? List.generate(
                              _webtoons.length,
                              (index) {
                                final webtoon = _webtoons[index];
                                return ManhwaSearchResultListBuilder(
                                  webtoon: webtoon,
                                );
                              },
                            )
                          : _isLoading || _isTyping
                              ? List.generate(
                                  6,
                                  (index) {
                                    return Shimmer.fromColors(
                                      baseColor: Color(0xFF292929),
                                      highlightColor: Color(0xFF333333),
                                      child: Container(
                                        color: Color(0xFF292929),
                                      ),
                                    );
                                  },
                                )
                              : !_isTyping && !_isLoading
                                  ? [Center(child: Text('Nothing found'))]
                                  : [],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
