// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test_bed/components/default_button.dart';
import 'package:flutter_test_bed/domain/general_image.dart';
import 'package:flutter_test_bed/domain/search.dart';
import 'package:flutter_test_bed/domain/unsplash_image.dart';
import 'package:flutter_test_bed/screens/gallery/preview.dart';
import 'package:flutter_test_bed/size_config.dart';
import 'package:unsplash_client/unsplash_client.dart' as u;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test_bed/domain/artstation_image.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key, required User user, required Search search})
      : 
        _user = user,
        _search = search,

        super(key: key);

  final User _user;
  final Search _search;

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  late User user;
  late Search search;
  
  late List<GeneralImage> imageList;
  late List<u.Photo> photolist;
  bool isLoaded = false;
  bool isSearchable = false;

  @override
  void initState() {
    user = widget._user;
    search = widget._search;

    unsplashLoader();
    
    super.initState();
  }



  
  Future<void> fetchImages() async {
     
      var response = await http.get(Uri.parse('https://bluekoiartstation.azurewebsites.net/api/ArtstationTrigger?code=XDD5yLKJGtvDs4dymRivJjSsoFgdu7LO9jjkufd87lOPWN8ZjR7RxA=='));
      
        if (response.statusCode == 200) {
          // If the server did return a 200 OK response,
          // then parse the JSON.
          var images =jsonDecode(response.body).cast<Map<String, dynamic>>();
         
          List<ArtStationImage> elements = images.map<ArtStationImage>((json) => ArtStationImage.fromMap(json)).toList();

          setState(() {
            imageList = List.from(imageList)..addAll(elements);   
          });
            print(imageList);
        } else {
          // If the server did not return a 200 OK response,
          // then throw an exception.
          throw Exception('Failed to load album');
        }
    }

  Future<void> unsplashLoader() async {
    try {
      final u.UnsplashClient client = u.UnsplashClient(
        settings: const u.ClientSettings(
            credentials: u.AppCredentials(
          accessKey: 'byVpt0dHXyzvmAM-HixXGw_1TGQOxS4ViH1hIhNEanY',
          secretKey: 'coq98aPMtqIjOJrxZqkfaFEhFyV8vycPvbJZrK2M2cM',
        )),
      );


      final List<u.Photo> photos;
      if(search.searchType == 'User'){
          photos = await client.photos
          .random(username: search.searchTopic, count: search.count)
          .goAndGet();
      }
      else{
          photos = await client.photos
          .random(query: search.searchTopic, count: search.count)
          .goAndGet();
      }

      
      List<UnsplashImage> elements = photos.map<UnsplashImage>((photo) => UnsplashImage.fromMap(photo.toJson())).toList();
     

      setState(() {
        imageList = elements;
        isLoaded = true;
        isSearchable = true;
        photolist = photos;
      });

      fetchImages();
      
    } catch (error) {
      print(error);
      setState(() {
        isLoaded = true;
        isSearchable = false;
      });
    }
  }

   

  @override
  void dispose() {
    super.dispose();
  }

  Widget _container(pathUrl) {
    if (pathUrl.contains('.mp4')) {
      return Image.memory(
        pathUrl,
        fit: BoxFit.cover,
      );
    } else if (pathUrl.contains('.jpg')) {
      return Image.network(
        pathUrl,
        fit: BoxFit.cover,
      );
    } else if (pathUrl.contains('image')) {
      return Image.network(
        pathUrl,
        fit: BoxFit.cover,
      );
    } else {
      //showing the path of the file if file is not ".jpg" or ".mp4"
      return Text(pathUrl,
          style: const TextStyle(
            fontSize: 15,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(20),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${search.searchTopic} - #${search.count}',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              isLoaded
                  ? isSearchable
                      ? GridView.count(
                          shrinkWrap: true,
                          //maintaining the size of scrollview whenever the scroll position changes
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,

                          children: [
                            for (var photo in photolist)
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: getProportionateScreenHeight(2),
                                    horizontal: getProportionateScreenWidth(2)),
                                child: InkWell(
                                  onTap: () {
                                   
                                  },
                                  child:
                                      _container(photo.urls.thumb.toString()),
                                ),
                              ),
                          ],
                        )
                      : Text(
                          'Error, no images or videos for ${search} exist.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        )
                  : const Center(child: CircularProgressIndicator())
            ],
          ),
        ),
      ),
    );
  }
}
