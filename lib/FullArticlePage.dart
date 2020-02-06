import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:share/share.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:ui';

class FullArticlePage extends StatefulWidget {

  final List articles;
  final int index;        // current open article index

  FullArticlePage(this.articles, this.index);

  @override
  _FullArticlePageState createState() => _FullArticlePageState(this.articles, this.index);
}

class _FullArticlePageState extends State<FullArticlePage> {

  String imageLink = 'https://news.raushanjha.in/upload/';

  final List articles;
  int index;

  SwiperController _swiperController;

  _FullArticlePageState(this.articles, this.index);

  @override
  void initState() {
    this._swiperController = SwiperController();

    super.initState();
  }

  Future shareArticle() async => await Share.share(this.articles[index]['news_title']);

  String getDate(String utcDate)
  {
    var date = DateTime.parse(utcDate);
    return "${date.day}-${date.month}-${date.year}" ;
  }

  @override
  void dispose() {
    this._swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Swiper(
          itemCount: articles.length,
          index: this.index,
          controller: this._swiperController,
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[

                    // article image start
                    Stack(
                      children: <Widget>[

                        // article image start
                        Stack(
                          children: <Widget>[
                            // bg image start
                            Container(
                              height: 200,
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 16),
                              child: Image(
                                height: 200,
                                width: double.infinity,
                                image: NetworkImage(imageLink +
                                  articles[index]['news_image'] 
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            // bg image end

                            // bg image blur start
                            Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.black38,
                              margin: EdgeInsets.only(bottom: 16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              ),
                            ),
                            // bg image blur end

                            // image start
                            Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.black38,
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.only(bottom: 16),
                              alignment: Alignment.center,
                              child: Image(
                                image: NetworkImage( 
                                  imageLink +
                                  articles[index]['news_image'] 
                                ),
                                loadingBuilder: (context, child, progress) => 
                                progress == null
                                ? child 
                                : Container(
                                  height: 100,
                                  width: 100,
                                  padding: EdgeInsets.all(40),
                                  child: CircularProgressIndicator()
                                ),
                              ),
                            ),
                            // image end
                          ],
                        ),
                        // article image end

                        // share btn start
                        Container(
                          height: 232,
                          padding: EdgeInsets.only(right: 8),    
                          alignment: Alignment.bottomRight,                
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)
                            ),
                            color: Theme.of(context).accentColor,
                            child: InkWell(
                              customBorder: CircleBorder(),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: Icon(
                                  Icons.share,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: shareArticle,
                            ),
                          ),
                        ),
                        // share btn end

                        // back btn start
                        Container(
                          padding: EdgeInsets.all(16),                    
                          child: InkWell(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                        // back btn end

                      ],
                    ),
                    // article image end

                    // article title start
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        articles[index]['news_title'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // article title end

                    // article details start
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[

                      // article published time start
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                ),

                                Text(
                                  " ${this.getDate(articles[index]['news_date'])}",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // article published time end

                          Divider(),

                          Container(height: 16,),

                          // article description start
                          articles[index]['news_description'] == null?
                          Container() :
                          Container(
                            child: Html(
                              data: articles[index]['news_description']
                            ),
                          ),
                          // article description end

                          Container(height: 16,),

                        ],
                      ),
                    ),
                    // article details end

                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}