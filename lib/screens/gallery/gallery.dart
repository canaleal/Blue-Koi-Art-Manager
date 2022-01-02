// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter_test_bed/components/default_button.dart';
import 'package:flutter_test_bed/screens/gallery/preview.dart';
import 'package:flutter_test_bed/size_config.dart';
import 'package:unsplash_client/unsplash_client.dart';

import '../../constants.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key, required String search, required String count, required String searchType})
      : _search = search,
        _count = count,
        _searchType = searchType,
        super(key: key);

  final String _search;
  final String _count;
  final String _searchType;
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late String search;
  late String count;
  late String searchType;

  late List<Photo> photolist;
  bool isLoaded = false;
  bool isSearchable = false;

  @override
  void initState() {
    search = widget._search;
    count = widget._count;
    searchType = widget._searchType;

    unsplashLoader();
    super.initState();
  }

  void unsplashLoader() async {
    try {
      final UnsplashClient client = UnsplashClient(
        settings: const ClientSettings(
            credentials: AppCredentials(
          accessKey: 'byVpt0dHXyzvmAM-HixXGw_1TGQOxS4ViH1hIhNEanY',
          secretKey: 'coq98aPMtqIjOJrxZqkfaFEhFyV8vycPvbJZrK2M2cM',
        )),
      );

      // Call `goAndGet` to execute the [Request] returned from `random`
      // and throw an exception if the [Response] is not ok.
      

      final List<Photo> photos;
      if(searchType == 'User'){
          photos = await client.photos
          .random(username: search, count: int.parse(count))
          .goAndGet();
      }
      else{
          photos = await client.photos
          .random(query: search, count: int.parse(count))
          .goAndGet();
      }

      setState(() {
        isLoaded = true;
        isSearchable = true;
        photolist = photos;
      });
    } catch (error) {
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
                '${search} - #${count}',
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
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Preview(photo: photo),
                                      ),
                                    );
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
