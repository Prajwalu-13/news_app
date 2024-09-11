import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../services/Themeconstants.dart';

class NewsDetailsScreen extends StatefulWidget {
  const NewsDetailsScreen({
    required this.newsImage,
    required this.newsTitle,
    required this.author,
    required this.newsDate,
    required this.description,
    required this.content,
    required this.source,
    super.key,
  });

  final String newsImage,
      newsTitle,
      newsDate,
      author,
      description,
      content,
      source;

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height * 1;
    final format = DateFormat('MMMM dd yyyy');
    DateTime dateTime = DateTime.parse(widget.newsDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: h * .45,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(40),
              ),
              child: widget.newsImage.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.newsImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: SpinKitFadingCircle(
                          size: 50,
                          color: Themeconstants.primaryColor,
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/Splash/no-image-available.png', // Fallback image path
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      'assets/Splash/no-image-available.png', // Fallback image path
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Container(
            height: h * .6,
            margin: EdgeInsets.only(top: h * .4),
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            decoration: BoxDecoration(
              color: Themeconstants.getCardColor(context),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(40),
              ),
            ),
            child: ListView(
              children: [
                Text(
                  widget.newsTitle,
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Themeconstants.getPrimaryTextColor(context),
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: h * .02,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.source,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Themeconstants.getPrimaryTextColor(context),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      format.format(dateTime),
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Themeconstants.getPrimaryTextColor(context),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: h * .03,
                ),
                Text(
                  widget.description,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Themeconstants.getPrimaryTextColor(context),
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
