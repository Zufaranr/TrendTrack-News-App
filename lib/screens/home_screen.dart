import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:trendtrack/components/breaking_news_card.dart';
import 'package:trendtrack/components/new_list_tile.dart';
import 'package:trendtrack/screens/login_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var breakingNewsData = [];
  var recentNewsData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final responseBreakingNews = await http.get(
      Uri.parse(
          'https://trendtrack-28fbc-default-rtdb.firebaseio.com/breakingNewsData.json'),
    );

    final responseRecentNews = await http.get(
      Uri.parse(
          'https://trendtrack-28fbc-default-rtdb.firebaseio.com/recentNewsData.json'),
    );

    if (responseBreakingNews.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(responseBreakingNews.body);
      data.forEach((key, value) {
        breakingNewsData.add(value);
      });

      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }

    if (responseRecentNews.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(responseRecentNews.body);
      data.forEach((key, value) {
        recentNewsData.add(value);
      });

      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "TrendTrack",
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            icon: Icon(
              Icons.logout, // Use the appropriate logout icon
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Breaking News",
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              CarouselSlider.builder(
                itemCount: breakingNewsData.length,
                itemBuilder: (context, index, id) =>
                    BreakingNewsCard(breakingNewsData[index]),
                options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                "Recent News",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Column(
                children: recentNewsData.map((e) => NewListTile(e)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
