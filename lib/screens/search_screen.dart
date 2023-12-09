import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:trendtrack/components/hotnews.dart';
import 'package:trendtrack/screens/details_screen.dart';

class searchscreen extends StatefulWidget {
  @override
  _searchscreenState createState() => _searchscreenState();
}

class _searchscreenState extends State<searchscreen> {
  String _searchQuery = '';
  List<Map<String, dynamic>> _searchResults = [];
  // var data;
  var hotNewsData = [];
  final Dio _dio = Dio();
  TextEditingController searchController = TextEditingController();
  bool isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final responseHotNews = await http.get(
      Uri.parse(
          'https://trendtrack-28fbc-default-rtdb.firebaseio.com/hotNewsData.json'),
    );

    if (responseHotNews.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(responseHotNews.body);
      data.forEach((key, value) {
        hotNewsData.add(value);
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
        elevation: 0.0,
        backgroundColor: Colors.white, // Change background color
        centerTitle: true,
        title: Text(
          "TrendTrack",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w700, // Increase font size
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.transparent, // Add a background color
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController, // Use TextEditingController() here
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey, // Input field background color
                hintText: 'Search',
                prefixIcon: Icon(Icons.search,
                    color: isSearchFocused
                        ? Colors.black
                        : Colors.black), // Change color based on focus
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded border
                ),
              ),
              onChanged: (value) {
                // Update nilai pencarian saat bidang pencarian berubah
                setState(() {
                  _searchQuery = value;
                  _fetchSearchResults();
                });
              },
              onTap: () {
                setState(() {
                  isSearchFocused = true;
                });
              },
              onSubmitted: (value) {
                setState(() {
                  isSearchFocused = false;
                });
              },
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchSearchResults() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://trendtrack-28fbc-default-rtdb.firebaseio.com/allNewsData.json?title=$_searchQuery',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        setState(() {
          _searchResults =
              responseData.values.toList().cast<Map<String, dynamic>>();
          print(_searchResults);
        });
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (error) {
      print('Error: $error');
      // Handle error
    }
  }

  List<Map<String, dynamic>> _performSearch() {
    String trimmedQuery = _searchQuery.toLowerCase().trim();

    if (trimmedQuery.isEmpty) {
      // Tampilkan container kosong jika tidak ada kunci pencarian
      return [];
    }

    return _searchResults
        .where((newsData) =>
            (newsData["title"] as String).toLowerCase().contains(trimmedQuery))
        .toList();
  }

  Widget _buildSearchResults() {
    final searchResults = _performSearch();

    return searchResults.isNotEmpty
        ? ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> allNewsData = searchResults[index];
              int number = index + 1;

              return _buildListItem(context, allNewsData, number);
            },
          )
        : Column(
            children: [
              Center(
                child: Text(
                  "No results found",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey, // Change text color
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Hot News",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children:
                            hotNewsData.map((e) => NewHotList(e)).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Widget _buildListItem(
      BuildContext context, Map<String, dynamic> allNewsData, int number) {
    // Your existing _buildListItem logic
    if (allNewsData["UrlToImage"] != null &&
        allNewsData["author"] != null &&
        allNewsData["category"] != null &&
        allNewsData["content"] != null &&
        allNewsData["date"] != null &&
        allNewsData["title"] != null) {
      return ListV(
        context,
        number,
        allNewsData,
        allNewsData["UrlToImage"],
        allNewsData["author"],
        allNewsData["category"],
        allNewsData["content"],
        allNewsData["date"],
        allNewsData["title"],
      );
    } else {
      return Container();
    }
  }

  Widget ListV(
      BuildContext context,
      int number,
      Map<String, dynamic> allNewsData,
      String UrlToImage,
      String author,
      String category,
      String content,
      String date,
      String title) {
    // Your existing ListV logic
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(allNewsData),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          // margin: EdgeInsets.only(bottom: 20.0),
          padding: EdgeInsets.all(12.0),
          height: 130,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(26.0),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 3,
                child: Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(UrlToImage),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Flexible(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        author,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
