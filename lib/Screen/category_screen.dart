import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/news_category_model.dart';
import 'package:news_app/services/Themeconstants.dart';

import '../view_model/headline_view_model.dart';
import 'home_screen.dart';
import 'news_details_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  HeadlineViewModel headlineViewModel = HeadlineViewModel();

  final format = DateFormat('MMMM dd yyyy');
  String categoryName = 'General';
  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Bussiness',
    'Technology',
  ];
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height * 1;
    final w = MediaQuery.sizeOf(context).width * 1;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              SizedBox(
                height: 38,
                child: ListView.builder(
                    itemCount: categoriesList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          categoryName = categoriesList[index];
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Container(
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: categoryName == categoriesList[index]
                                  ? Themeconstants.primaryTextColor
                                  : Colors.grey,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text(
                                  categoriesList[index].toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: FutureBuilder<NewsCategoryModel>(
                  future: headlineViewModel.fetchCategories(
                    categoryName,
                  ),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                      return ListView.builder(
                          itemCount: snapshot.data!.articles!.length,
                          itemBuilder: (context, index) {
                            DateTime dateTime = DateTime.parse(snapshot
                                .data!.articles![index].publishedAt
                                .toString());
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDetailsScreen(
                                        newsImage: snapshot.data!
                                                .articles![index].urlToImage ??
                                            'assets/Splash/no-image-available.png', // Handle null URL by providing a fallback image
                                        newsTitle: snapshot
                                            .data!.articles![index].title
                                            .toString(),
                                        author: snapshot
                                                .data!.articles![index].author
                                                ?.toString() ??
                                            'Unknown Author', // Handle null author
                                        newsDate: dateTime.toString(),
                                        description: snapshot.data!
                                                .articles![index].description
                                                ?.toString() ??
                                            'No description available', // Handle null description
                                        content: snapshot
                                                .data!.articles![index].content
                                                ?.toString() ??
                                            'No content available', // Handle null content
                                        source: snapshot.data!.articles![index]
                                                .source?.name
                                                ?.toString() ??
                                            'Unknown Source', // Handle null source
                                      ),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: h * .18,
                                      width: w *
                                          .4, // Ensure image has a fixed width
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot
                                                      .data!
                                                      .articles![index]
                                                      .urlToImage
                                                      ?.isNotEmpty ==
                                                  true
                                              ? snapshot.data!.articles![index]
                                                  .urlToImage!
                                              : 'assets/Splash/no-image-available.png', // Fallback image path
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            child: spinkit2,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            'assets/Splash/no-image-available.png', // Fallback image path
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            10), // Add spacing between image and text
                                    Expanded(
                                      // Wrap the text content in Expanded
                                      child: Container(
                                        height: h * .18,
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start, // Align text to start
                                          children: [
                                            Text(
                                              snapshot
                                                  .data!.articles![index].title
                                                  .toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow
                                                  .ellipsis, // Prevent text overflow
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Themeconstants
                                                    .getPrimaryTextColor(
                                                        context),
                                                fontWeight: FontWeight.w700,
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
                                                        .articles![index]
                                                        .source!
                                                        .name
                                                        .toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: Themeconstants
                                                          .getPrimaryTextColor(
                                                              context),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    overflow: TextOverflow
                                                        .ellipsis, // Prevent overflow in source name
                                                  ),
                                                ),
                                                Text(
                                                  format.format(dateTime),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: Themeconstants
                                                        .getPrimaryTextColor(
                                                            context),
                                                    fontWeight: FontWeight.w500,
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
                          });
                    }
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
