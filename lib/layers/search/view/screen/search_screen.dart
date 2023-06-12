import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;

class SearchScreen extends StatefulWidget {
  final String scanlatorName;
  final String scanlatorLogoUrl;

  const SearchScreen({
    Key? key,
    required this.scanlatorName,
    required this.scanlatorLogoUrl,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? _typingTimer;
  String _inputText = '';
  List<Map<String, String>> _webtoons = [];

  void onTextChanged(String input) {
    _typingTimer?.cancel();

    _typingTimer = Timer(const Duration(milliseconds: 500), () {
      if (_inputText.isEmpty) {
        setState(() {
          _webtoons = [];
        });
        return;
      }

      final website = 'https://asurascans.com/?s=$_inputText';
      scrapeWebsite(website).then((webtoons) {
        setState(() {
          _webtoons = webtoons;
        });
      }).catchError((error) {
        print('Error: $error');
      });
    });
  }

  Future<List<Map<String, String>>> scrapeWebsite(String website) async {
    final response = await http.get(Uri.parse(website));
    if (response.statusCode == 200) {
      final document = htmlParser.parse(response.body);

      final covers = document.querySelectorAll('div.limit img');
      final titles = document.querySelectorAll('div.bigor div.tt');

      final webtoons = <Map<String, String>>[];
      for (int i = 0; i < covers.length; i++) {
        final coverUrl = covers[i].attributes['src'];
        final title = titles[i].text;
        webtoons.add({'cover': coverUrl!, 'title': title});
      }

      return webtoons;
    } else {
      throw Exception('Failed to scrape website: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Searching in ${widget.scanlatorName}',
          style: GoogleFonts.overpass(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                onChanged: (text) {
                  setState(() {
                    _inputText = text;
                  });
                  onTextChanged(text);
                },
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
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
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                shrinkWrap: true,
                childAspectRatio: (1 / 1.45),
                children: List.generate(
                  _webtoons.length,
                  (index) {
                    final webtoon = _webtoons[index];
                    return Stack(
                      children: [
                        Image.network(
                          webtoon['cover']!,
                          // height: 150,
                          height: 300,
                          fit: BoxFit.fitHeight,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color.fromARGB(230, 0, 0, 0),
                                Color(0x00000000),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 4.0,
                            ),
                            child: Text(
                              webtoon['title']!,
                              style: GoogleFonts.overpass(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';

// class SearchScreen extends StatelessWidget {
//   final String scanlatorName;
//   final String scanlatorLogoUrl;

//   const SearchScreen({
//     super.key,
//     required this.scanlatorName,
//     required this.scanlatorLogoUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search Screen'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Image.network(
//             //   scanlatorLogoUrl,
//             //   height: 150,
//             //   width: 150,
//             // ),
//             const SizedBox(
//               height: 10,
//             ),
//             Text(
//               'AIDNFIDAHNFGIADNHGOIDA',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Text('Add search functionality here'),
//           ],
//         ),
//       ),
//     );
//   }
// }
