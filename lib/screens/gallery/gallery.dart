// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter_test_bed/components/default_button.dart';
import 'package:flutter_test_bed/screens/gallery/preview.dart';
import 'package:flutter_test_bed/size_config.dart';
import 'package:unsplash_client/unsplash_client.dart';

import '../../constants.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key, required String search, required String count})
      : _search = search,
        _count = count,
        super(key: key);

  final String _search;
  final String _count;
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late String search;
  late String count;

  late List<Photo> photolist;
  bool isLoaded = false;

  @override
  void initState() {
    search = widget._search;
    count = widget._count;

    loader();
    super.initState();
  }

  void loader() async {
    final client = UnsplashClient(
      settings: const ClientSettings(
          credentials: AppCredentials(
        accessKey: 'byVpt0dHXyzvmAM-HixXGw_1TGQOxS4ViH1hIhNEanY',
        secretKey: 'coq98aPMtqIjOJrxZqkfaFEhFyV8vycPvbJZrK2M2cM',
      )),
    );

    // Call `goAndGet` to execute the [Request] returned from `random`
    // and throw an exception if the [Response] is not ok.
    final photos = await client.photos
        .random(query: search, count: int.parse(count))
        .goAndGet();

    setState(() {
      isLoaded = true;
      photolist = photos;
    });
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
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              isLoaded
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
                                    builder: (context) => Preview(photo: photo),
                                  ),
                                );
                              },
                              child: _container(photo.urls.thumb.toString()),
                            ),
                          ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator())
            ],
          ),
        ),
      ),
    );
  }
}
