import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';

class VideoNewsDetails extends StatefulWidget {

  final videoNews;
  VideoNewsDetails(this.videoNews);

  @override
  _VideoNewsDetailsState createState() => _VideoNewsDetailsState(this.videoNews);
}

class _VideoNewsDetailsState extends State<VideoNewsDetails> {

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  String imageLink = 'https://news.raushanjha.in/upload/video/';
  String videoLink = 'https://news.raushanjha.in/upload/video/';

  final videoNews;

  _VideoNewsDetailsState(this.videoNews);

  @override
  void initState() {
    setState(() {

      String videoUrl = videoLink + videoNews['video_url'];
      print("videoUrl: $videoUrl");

      this._videoPlayerController = VideoPlayerController.network(videoUrl);

      this._chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: false,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    this._videoPlayerController.dispose();
    this._chewieController.dispose();
    super.dispose();
  }

  Future shareArticle() async => await Share.share(this.videoNews['news_title']);

  String getDate(String utcDate)
  {
    var date = DateTime.parse(utcDate);
    return "${date.day}-${date.month}-${date.year}" ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                          child: Image(
                            height: 200,
                            width: double.infinity,
                            image: NetworkImage(imageLink +
                              videoNews['news_image'] 
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
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          ),
                        ),
                        // bg image blur end

                        // video player container start
                        Container(
                          height: 200,
                          width: double.infinity,
                          child: Chewie(
                            controller: _chewieController,
                          ),
                        ),
                        // video player container start
                      ],
                    ),
                    // article image end
                    
                    Row(
                      children: <Widget>[
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
                      ],
                    ),
                    // back btn end

                  ],
                ),
                // article image end
                
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // article title start
                      Flexible(
                        child: Text(
                          videoNews['news_title'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // article title end

                      // share btn start
                      InkWell(
                        customBorder: CircleBorder(),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Icon(
                            Icons.share
                          ),
                        ),
                        onTap: shareArticle,
                      ),
                      // share btn end

                    ],
                  ),
                ),

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
                              " ${this.getDate(videoNews['news_date'])}",
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
                      videoNews['news_description'] == null?
                      Container() :
                      Container(
                        child: Html(
                          data: videoNews['news_description']
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
        ),
      ),
    );
  }
}