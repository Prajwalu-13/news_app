import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app/services/Themeconstants.dart';

import '../services/news_service.dart';
import 'news_details_screen.dart';

class SearchScreen extends StatelessWidget {
  final String query;
  NewsService newsService = NewsService();

  SearchScreen({required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Results')),
      body: FutureBuilder(
        future: newsService.searchNews(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitFadingCircle(
                size: 50,
                color: Themeconstants.primaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading search results'));
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(child: Text('No results found'));
          } else {
            final articles = snapshot.data as List<dynamic>;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Themeconstants.primaryTextColor,
                    ),
                    child: ListTile(
                      title: Text(
                        article['title'] ?? 'No title available',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailsScreen(
                              newsImage: article['urlToImage'] ??
                                  'assets/Splash/no-image-available.png',
                              newsTitle:
                                  article['title'] ?? 'No title available',
                              author: article['author'] ?? 'Unknown Author',
                              newsDate: article['publishedAt'] ??
                                  'Unknown Date', // Use 'publishedAt' for news date
                              description: article['description'] ??
                                  'No description available',
                              content:
                                  article['content'] ?? 'No content available',
                              source:
                                  article['source']['name'] ?? 'Unknown Source',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
