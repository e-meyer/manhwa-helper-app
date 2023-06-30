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

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  Timer? _typingTimer;
  String _inputText = '';
  List<Map<String, String>> _webtoons = [];
  bool _isLoading = false;
  bool _isTyping = false;
  late FocusNode myFocusNode;
  late AnimationController _controller;
  late Animation _colorTween;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _colorTween = ColorTween(
      begin: Color(0xFF3E3E3E),
      end: Color(0xFFFF6812),
    ).animate(_controller);

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _controller.dispose();

    super.dispose();
  }

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
          'http://ec2-3-135-188-213.us-east-2.compute.amazonaws.com/scanlator/${widget.scanlator.name.toLowerCase()}?s=$_inputText';

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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                leading: Container(),
                leadingWidth: 0,
                titleSpacing: 0,
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    autofocus: true,
                    focusNode: myFocusNode,
                    onChanged: (text) {
                      setState(() {
                        _inputText = text;
                        print(_inputText);
                      });
                      onTextChanged(text);
                    },
                    autocorrect: false,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      fillColor: Color(0xFF292929),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search in Asura',
                      hintStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Color(0xFF595959),
                      ),
                      prefixIcon: myFocusNode.hasFocus
                          ? null
                          : InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: SvgPicture.asset(
                                  'assets/icons/arrow-back.svg',
                                  colorFilter: ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                  height: 10,
                                ),
                              ),
                            ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: AnimatedBuilder(
                          animation: _colorTween,
                          builder: (context, _) {
                            return SvgPicture.asset(
                              'assets/icons/search-solid.svg',
                              colorFilter: ColorFilter.mode(
                                _colorTween.value,
                                BlendMode.srcIn,
                              ),
                              height: 10,
                            );
                          },
                        ),
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFBCBCBC),
                      fontSize: 18,
                    ),
                    cursorColor: Color(0xFFFF6812),
                  ),
                ))
          ];
        },
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                if ((_webtoons.isNotEmpty && _inputText != ''))
                  Text(
                    'Results for "${_inputText}"',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                (_webtoons.isEmpty && _inputText == '')
                    ? Container()
                    : GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount:
                            (!_isTyping && !_isLoading && _webtoons.isEmpty)
                                ? 1
                                : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
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
                                    ? [
                                        SvgPicture.asset(
                                            'assets/vectors/404.svg')
                                      ]
                                    : [],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
    // return Scaffold(
    //   backgroundColor: Color(0xFF222222),
    //   appBar: AppBar(
    //     elevation: 0,
    //     backgroundColor: Colors.transparent,
    //     centerTitle: true,
    //     leading: Container(),
    //     leadingWidth: 0,
    //     titleSpacing: 0,
    //     title: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 12.0),
    //       child: TextField(
    //         autofocus: true,
    //         focusNode: myFocusNode,
    //         onChanged: (text) {
    //           setState(() {
    //             _inputText = text;
    //             print(_inputText);
    //           });
    //           onTextChanged(text);
    //         },
    //         autocorrect: false,
    //         decoration: InputDecoration(
    //           isDense: true,
    //           filled: true,
    //           contentPadding: EdgeInsets.symmetric(horizontal: 15),
    //           fillColor: Color(0xFF292929),
    //           border: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: BorderSide.none,
    //           ),
    //           hintText: 'Search in Asura',
    //           hintStyle: GoogleFonts.poppins(
    //             fontWeight: FontWeight.w500,
    //             fontSize: 18,
    //             color: Color(0xFF595959),
    //           ),
    //           prefixIcon: myFocusNode.hasFocus
    //               ? null
    //               : InkWell(
    //                   onTap: () {
    //                     Navigator.of(context).pop();
    //                   },
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(15.0),
    //                     child: SvgPicture.asset(
    //                       'assets/icons/arrow-back.svg',
    //                       colorFilter:
    //                           ColorFilter.mode(Colors.white, BlendMode.srcIn),
    //                       height: 10,
    //                     ),
    //                   ),
    //                 ),
    //           suffixIcon: Padding(
    //             padding: const EdgeInsets.all(14.0),
    //             child: AnimatedBuilder(
    //               animation: _colorTween,
    //               builder: (context, _) {
    //                 return SvgPicture.asset(
    //                   'assets/icons/search-solid.svg',
    //                   colorFilter: ColorFilter.mode(
    //                     _colorTween.value,
    //                     BlendMode.srcIn,
    //                   ),
    //                   height: 10,
    //                 );
    //               },
    //             ),
    //           ),
    //         ),
    //         style: GoogleFonts.poppins(
    //           fontWeight: FontWeight.w500,
    //           color: Color(0xFFBCBCBC),
    //           fontSize: 18,
    //         ),
    //         cursorColor: Color(0xFFFF6812),
    //       ),
    //     ),
    //   ),
    //   body: SingleChildScrollView(
    //     physics: BouncingScrollPhysics(),
    //     child: Padding(
    //       padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           SizedBox(
    //             height: 10,
    //           ),
    //           if ((_webtoons.isNotEmpty && _inputText != ''))
    //             Text(
    //               'Results for "${_inputText}"',
    //               maxLines: 1,
    //               overflow: TextOverflow.ellipsis,
    //               style: GoogleFonts.poppins(
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.w600,
    //                 fontSize: 18,
    //               ),
    //             ),
    //           SizedBox(
    //             height: 10,
    //           ),
    //           (_webtoons.isEmpty && _inputText == '')
    //               ? Container()
    //               : GridView.count(
    //                   physics: NeverScrollableScrollPhysics(),
    //                   crossAxisCount:
    //                       (!_isTyping && !_isLoading && _webtoons.isEmpty)
    //                           ? 1
    //                           : 2,
    //                   crossAxisSpacing: 12,
    //                   mainAxisSpacing: 12,
    //                   shrinkWrap: true,
    //                   childAspectRatio: (1 / 1.45),
    //                   children: _webtoons.isNotEmpty
    //                       ? List.generate(
    //                           _webtoons.length,
    //                           (index) {
    //                             final webtoon = _webtoons[index];
    //                             return ManhwaSearchResultListBuilder(
    //                               webtoon: webtoon,
    //                             );
    //                           },
    //                         )
    //                       : _isLoading || _isTyping
    //                           ? List.generate(
    //                               6,
    //                               (index) {
    //                                 return Shimmer.fromColors(
    //                                   baseColor: Color(0xFF292929),
    //                                   highlightColor: Color(0xFF333333),
    //                                   child: Container(
    //                                     color: Color(0xFF292929),
    //                                   ),
    //                                 );
    //                               },
    //                             )
    //                           : !_isTyping && !_isLoading
    //                               ? [SvgPicture.asset('assets/vectors/404.svg')]
    //                               : [],
    //                 ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
