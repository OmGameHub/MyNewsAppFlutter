import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'FullArticlePage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String topHeadlinesApi = 'http://news.raushanjha.in/flutterapi/public/index.php/getnewsall';
  String categorysApi = 'http://news.raushanjha.in/flutterapi/category';
  String categoryNewsApi = 'http://news.raushanjha.in/flutterapi/categorynews.php?cat_id=';
  String imageLink = 'https://news.raushanjha.in/upload/';

  List articles;
  List categorys;
  List liveNews;

  int _selectedIndex = 0;
  bool isInternetConn = true;
  bool isCategoryLoading = false;

  @override
  void initState() 
  {
    getHeadlines();
    getCategorys();
    super.initState();
  }

  Future getHeadlines() async 
  {
    setState(() => this.isInternetConn = true);

    try 
    {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) 
      {

        var url = topHeadlinesApi;
        var respones = await http.get(Uri.encodeFull(url));
        var jsonRespones = json.decode(respones.body);

        setState(() => articles = jsonRespones);
      }
      else
      {
        setState(() => this.isInternetConn = false);
      }
    } 
    on SocketException catch (_) 
    {
      print('not connected');
      setState(() => this.isInternetConn = false);
    }
  }

  Future getCategorys() async 
  {
    setState(() => this.isInternetConn = true);

    try 
    {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) 
      {

        var url = categorysApi;
        var respones = await http.get(Uri.encodeFull(url));
        setState(() => categorys = json.decode(respones.body));
      }
      else
      {
        setState(() => this.isInternetConn = false);
      }
    } 
    on SocketException catch (_) 
    {
      print('not connected');
      setState(() => this.isInternetConn = false);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void openFullArticle(int intdex) 
  {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (BuildContext context) => FullArticlePage(articles, intdex)
      )
    );
  }

  Future _onTapCategory(String catId) async
  {
    setState(() {
      this.isInternetConn = true;
      this.isCategoryLoading = true;
    });

    try 
    {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) 
      {

        var url = this.categoryNewsApi + catId;
        print("url: $url");
        var respones = await http.get(Uri.encodeFull(url));
        
        List categoryNewsList = json.decode(respones.body);

        if (categoryNewsList.length > 0) 
        { 
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (BuildContext context) => FullArticlePage(categoryNewsList, 0)
            )
          ); 
        } 
        else 
        {
          final snackBar = SnackBar(
            content: Text("No news found"),
            backgroundColor: Theme.of(context).accentColor,
          );

          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }
      else
      {
        setState(() => this.isInternetConn = false);
      }
    } 
    on SocketException catch (_) 
    {
      print('not connected');
      setState(() => this.isInternetConn = false);
    } 

    setState(() => this.isCategoryLoading = false);
  }

  
  // article list item start
  Widget article(int index) => 
  Card(
    child: InkWell(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[

            // article image start
            articles[index]['news_image'] == null?
            Container() :
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageLink + articles[index]['news_image'] ,
                loadingBuilder: (context, child, progress) => 
                  progress == null? 
                  child : 
                  Container(
                    height: 100,
                    width: 100,
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator()
                  ),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            // article image end  

            // article title start
            Expanded(
              child: Container(
                height: 100,
                margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          articles[index]['news_title'],
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Text(
                      articles[index]['news_date'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textSelectionHandleColor,
                      ),
                    ),

                  ],
                ),
              ),
            ),
            // article title end

          ],
        ),
      ),
      onTap: () => this.openFullArticle(index),
    ),
  );
  // article list item end

  // categorys list item start
  Widget category(int index) =>
  ListTile(
    contentPadding: EdgeInsets.all(8),
    leading: Container(
      child: Image(
        height: 48,
        width: 48,
        image: NetworkImage(
          categorys[index]['category_image']),
          loadingBuilder: (context, child, progress) =>
          progress == null
          ? child
          : Container(
            height: 48,
            width: 48,
            padding: EdgeInsets.all(10),
            child: CircularProgressIndicator()
          ),
        fit: BoxFit.contain,
      ),
    ),
    title: Text(categorys[index]['category_name']),
    onTap: () => this._onTapCategory(categorys[index]['cid']),
  );
  // categorys list item end

  Widget _loadingPage(onPressed) => 
  isInternetConn 
  ? Center(
    child: CircularProgressIndicator(),
  ) 
  : Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Text(
          "Check you internet connection",
          style: TextStyle(
            fontSize: 18,
          ),
        ),

        Container(height: 16,),

        MaterialButton(
          padding: EdgeInsets.symmetric(horizontal: 16),
          color: Theme.of(context).textSelectionHandleColor,
          child: Text(
            "Retry",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onPressed,
        ),

      ],
    ),
  );

  // app body pages start
  Widget _body() 
  {
    switch (this._selectedIndex) {
      case 0: return articles == null
      ? this._loadingPage(getHeadlines)
      : ListView.builder(
        itemCount: articles.length,
        itemBuilder: (BuildContext context, int index) => article(index),
      );

      case 1: return categorys == null
      ? this._loadingPage(getCategorys)
      : Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: categorys.length,
            itemBuilder: (BuildContext context, int index) => category(index),
          ),

          Visibility(
            visible: isCategoryLoading,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black38,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      );
    }
  }
  // app body pages end

  // app bottom navigation bar start
  Widget _bottomNavigationBar() => 
  BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.category),
        title: Text('Category'),
      ),
    ],
    onTap: _onItemTapped,
    currentIndex: _selectedIndex,
    elevation: 5,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Theme.of(context).textSelectionHandleColor,
  );
  // app bottom navigation bar end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("MyNews"),
      ),
      body: this._body(),
      bottomNavigationBar: this._bottomNavigationBar(),
    );
  }
}