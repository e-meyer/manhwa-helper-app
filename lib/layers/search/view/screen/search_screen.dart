import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      begin: const Color(0xFF3E3E3E),
      end: const Color(0xFFFF6812),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SvgPicture.asset(
                    'assets/icons/arrow-back.svg',
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    height: 10,
                  ),
                ),
              ),
              leadingWidth: 60,
              titleSpacing: 0,
              title: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: TextField(
                  autofocus: true,
                  focusNode: myFocusNode,
                  onChanged: (text) {
                    setState(() {
                      _inputText = text;
                    });
                    onTextChanged(text);
                  },
                  autocorrect: false,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    fillColor: Theme.of(context).highlightColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Search in ${widget.scanlator.name}',
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      child: AnimatedBuilder(
                        animation: _colorTween,
                        builder: (context, _) {
                          return SvgPicture.asset(
                            'assets/icons/search-solid.svg',
                            colorFilter: ColorFilter.mode(
                              _colorTween.value,
                              BlendMode.srcIn,
                            ),
                            width: 17,
                            height: 17,
                          );
                        },
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    // height: 1.6,
                    fontFamily: 'Poppins',
                    color: Color(0xFFBCBCBC),
                    fontSize: 16,
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (_webtoons.isEmpty && _inputText == '')
                    ? Container()
                    : GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
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
                                    scanlator: widget.scanlator,
                                  );
                                },
                              )
                            : _isLoading || _isTyping
                                ? List.generate(
                                    6,
                                    (index) {
                                      return Shimmer.fromColors(
                                        baseColor: const Color(0xFF292929),
                                        highlightColor: const Color(0xFF333333),
                                        child: Container(
                                          color: const Color(0xFF292929),
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
  }
}
