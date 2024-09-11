import 'dart:async';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Screen/search_screen.dart';
import 'package:news_app/models/headlins_model.dart';
import 'package:news_app/models/news_category_model.dart';
import 'package:news_app/services/Themeconstants.dart';
import 'package:news_app/view_model/headline_view_model.dart';
import 'package:provider/provider.dart';

import '../provider/theme_changer_notifier.dart';
import 'news_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, indNews, independent, usa, cnn }

class _HomeScreenState extends State<HomeScreen> {
  HeadlineViewModel headlineViewModel = HeadlineViewModel();
  FilterList? selectedMenu;
  PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer; // Initialize _timer as nullable
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // Helper method to get article length
  int _getArticleLength(AsyncSnapshot<Headlinesmodel> snapshot) {
    return snapshot.data?.articles?.length ?? 0;
  }

  // Start or restart the auto scroll with a delay of 3 seconds
  void _startAutoScroll(AsyncSnapshot<Headlinesmodel> snapshot,
      {bool reset = false}) {
    if (reset) {
      _timer?.cancel(); // Cancel the previous timer when reset is true
    }

    _timer = Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _getArticleLength(snapshot) - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  // Method to handle manual scroll with arrow button, then resume automatic scrolling
  void _handleArrowPress(
      AsyncSnapshot<Headlinesmodel> snapshot, bool isForward) {
    _timer?.cancel(); // Stop the timer when arrow is pressed

    // Change the page based on the direction of the arrow
    if (isForward) {
      if (_currentPage < _getArticleLength(snapshot) - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
    } else {
      if (_currentPage > 0) {
        _currentPage--;
      } else {
        _currentPage = _getArticleLength(snapshot) - 1;
      }
    }

    _pageController.animateToPage(
      _currentPage,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    // Restart auto-scrolling after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      _startAutoScroll(snapshot, reset: true);
    });
  }

  final format = DateFormat('dd MMM yyyy');
  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    final h = MediaQuery.sizeOf(context).height * 1;
    final w = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              icon: Icon(
                Icons.menu_sharp,
                color: Themeconstants.getPrimaryTextColor(context),
              ),
              onSelected: (FilterList item) {
                if (FilterList.bbcNews.name == item.name) {
                  name = 'bbc-news';
                }
                if (FilterList.usa.name == item.name) {
                  name = 'new-york-magazine';
                }

                if (FilterList.indNews.name == item.name) {
                  name = 'google-news-in';
                }

                if (FilterList.cnn.name == item.name) {
                  name = 'cnn';
                }
                if (FilterList.independent.name == item.name) {
                  name = 'google-news';
                }
                setState(() {
                  selectedMenu = item;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<FilterList>>[
                const PopupMenuItem<FilterList>(
                    value: FilterList.bbcNews, child: Text('BBC News')),
                // const PopupMenuItem<FilterList>(
                //     value: FilterList.indNews, child: Text('India')),
                const PopupMenuItem<FilterList>(
                  value: FilterList.cnn,
                  child: Text('CNN'),
                ),
                const PopupMenuItem<FilterList>(
                    value: FilterList.usa, child: Text('USA')),
                const PopupMenuItem<FilterList>(
                    value: FilterList.independent, child: Text('GLOBAL')),
              ],
            ),
          ),
          title: Text(
            'Global News',
            style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Themeconstants.getPrimaryTextColor(context)),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: GestureDetector(
                  onTap: () {
                    // Toggle between light and dark theme based on the current theme mode
                    ThemeMode newThemeMode =
                        themeChanger.themeMode == ThemeMode.light
                            ? ThemeMode.dark
                            : ThemeMode.light;
                    themeChanger.setTheme(newThemeMode);
                  },
                  child: Icon(themeChanger.themeMode == ThemeMode.light
                      ? Icons.nights_stay_outlined
                      : Icons.sunny)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 15),
              child: AnimSearchBar(
                autoFocus: true,
                width: 300,
                textController: _textController,
                onSuffixTap: () {
                  setState(() {
                    _textController.clear();
                  });
                },
                onSubmitted: (String value) {
                  print("Submitted value: $value");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(
                        query: value, // Use _textController.text
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Top Headlines',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    // RadioListTile<ThemeMode>(
                    //     title: Text("dark"),
                    //     value: ThemeMode.dark,
                    //     groupValue: themeChanger.themeMode,
                    //     onChanged: themeChanger.setTheme)
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: h * .25,
                          width: w,
                          child: FutureBuilder<Headlinesmodel>(
                            future: headlineViewModel.fetchHeadline(name),
                            builder: (BuildContext context,
                                AsyncSnapshot<Headlinesmodel> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: SpinKitFadingCircle(
                                    size: 50,
                                    color: Themeconstants.primaryColor,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Oops ! : ${snapshot.error}'),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.articles == null ||
                                  snapshot.data!.articles!.isEmpty) {
                                return const Center(
                                  child: Text('No headlines available'),
                                );
                              } else {
                                _startAutoScroll(
                                    snapshot); // Start auto-scroll when data is available

                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    PageView.builder(
                                      controller: _pageController,
                                      itemCount: _getArticleLength(snapshot),
                                      itemBuilder: (context, index) {
                                        DateTime dateTime = DateTime.parse(
                                          snapshot.data!.articles![index]
                                              .publishedAt
                                              .toString(),
                                        );
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NewsDetailsScreen(
                                                  newsImage: snapshot
                                                          .data!
                                                          .articles![index]
                                                          .urlToImage ??
                                                      'assets/Splash/no-image-available.png', // Handle null URL by providing a fallback image
                                                  newsTitle: snapshot.data!
                                                      .articles![index].title
                                                      .toString(),
                                                  author: snapshot
                                                          .data!
                                                          .articles![index]
                                                          .author
                                                          ?.toString() ??
                                                      'Unknown Author', // Handle null author
                                                  newsDate: dateTime.toString(),
                                                  description: snapshot
                                                          .data!
                                                          .articles![index]
                                                          .description
                                                          ?.toString() ??
                                                      'No description available', // Handle null description
                                                  content: snapshot
                                                          .data!
                                                          .articles![index]
                                                          .content
                                                          ?.toString() ??
                                                      'No content available', // Handle null content
                                                  source: snapshot
                                                          .data!
                                                          .articles![index]
                                                          .source
                                                          ?.name
                                                          ?.toString() ??
                                                      'Unknown Source', // Handle null source
                                                ),
                                              ),
                                            );
                                          },
                                          child: SizedBox(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                  child: CachedNetworkImage(
                                                    imageUrl: snapshot
                                                            .data!
                                                            .articles![index]
                                                            .urlToImage ??
                                                        '', // Handle null URLs

                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      child: spinkit2,
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      'assets/Splash/no-image-available.png', // Fallback image path
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 10,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    height: h * .098,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width: w * .7,
                                                          child: Text(
                                                            snapshot
                                                                .data!
                                                                .articles![
                                                                    index]
                                                                .title
                                                                .toString(),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: snapshot
                                                                          .data!
                                                                          .articles![
                                                                              index]
                                                                          .urlToImage ==
                                                                      null
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width: w * .7,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(''),
                                                                Text(
                                                                  format.format(
                                                                      dateTime),
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    // Arrow Buttons for manual movement
                                    Positioned(
                                      left: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(55)),
                                        child: IconButton(
                                          icon: Icon(
                                              Icons.arrow_back_ios_new_outlined,
                                              size: 30),
                                          onPressed: () {
                                            _handleArrowPress(snapshot,
                                                false); // Move left and restart auto-scroll
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(55)),
                                        child: IconButton(
                                          icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              size: 30),
                                          onPressed: () {
                                            _handleArrowPress(snapshot,
                                                true); // Move right and restart auto-scroll
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 05),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Themeconstants.getCardColor(context),
                          ),
                          height: h * .6,
                          width: w * 1.0,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: FutureBuilder<NewsCategoryModel>(
                              future:
                                  headlineViewModel.fetchCategories('General'),
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: SpinKitFadingCircle(
                                      size: 50,
                                      color: Themeconstants.primaryColor,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  // Handle error state
                                  return Center(
                                    child: Text('Oops ! : ${snapshot.error}'),
                                  );
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.articles == null ||
                                    snapshot.data!.articles!.isEmpty) {
                                  // Handle case where there is no data or articles are null/empty
                                  return const Center(
                                    child: Text('No news articles available'),
                                  );
                                } else {
                                  return InkWell(
                                    child: SizedBox(
                                      height: h * .3,
                                      width: w * .3,
                                      child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount:
                                              snapshot.data!.articles!.length,
                                          itemBuilder: (context, index) {
                                            DateTime dateTime = DateTime.parse(
                                                snapshot.data!.articles![index]
                                                    .publishedAt
                                                    .toString());
                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewsDetailsScreen(
                                                      newsImage: snapshot
                                                              .data!
                                                              .articles![index]
                                                              .urlToImage ??
                                                          'assets/Splash/no-image-available.png', // Handle null URL by providing a fallback image
                                                      newsTitle: snapshot
                                                          .data!
                                                          .articles![index]
                                                          .title
                                                          .toString(),
                                                      author: snapshot
                                                              .data!
                                                              .articles![index]
                                                              .author
                                                              ?.toString() ??
                                                          'Unknown Author', // Handle null author
                                                      newsDate:
                                                          dateTime.toString(),
                                                      description: snapshot
                                                              .data!
                                                              .articles![index]
                                                              .description
                                                              ?.toString() ??
                                                          'No description available', // Handle null description
                                                      content: snapshot
                                                              .data!
                                                              .articles![index]
                                                              .content
                                                              ?.toString() ??
                                                          'No content available', // Handle null content
                                                      source: snapshot
                                                              .data!
                                                              .articles![index]
                                                              .source
                                                              ?.name
                                                              ?.toString() ??
                                                          'Unknown Source', // Handle null source
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 15.0),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: CachedNetworkImage(
                                                        height: h * .13,
                                                        width: w * .3,
                                                        imageUrl: snapshot
                                                                .data!
                                                                .articles![
                                                                    index]
                                                                .urlToImage ??
                                                            '', // Handle null URLs

                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(
                                                          child: spinkit2,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          'assets/Splash/no-image-available.png', // Fallback image path
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: w * .05,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        height: h * .1,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 12),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              snapshot
                                                                  .data!
                                                                  .articles![
                                                                      index]
                                                                  .title
                                                                  .toString(),
                                                              maxLines: 3,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 13,
                                                                color: Themeconstants
                                                                    .getPrimaryTextColor(
                                                                        context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    snapshot
                                                                        .data!
                                                                        .articles![
                                                                            index]
                                                                        .source!
                                                                        .name
                                                                        .toString(),
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          14,
                                                                      color: Themeconstants
                                                                          .getPrimaryTextColor(
                                                                              context),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis, // Prevents text overflow
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width:
                                                                        8), // Add some space between texts
                                                                Text(
                                                                  format.format(
                                                                      dateTime),
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        15,
                                                                    color: Themeconstants
                                                                        .getPrimaryTextColor(
                                                                            context),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _textController
        .dispose(); // Dispose of the controller to avoid memory leaks
    _timer?.cancel(); // Cancel the timer only if it's not null
    _pageController.dispose();
    super.dispose();
  }
}

var spinkit2 = SpinKitFadingCircle(
  color: Themeconstants.primaryColor,
  size: 50,
);
