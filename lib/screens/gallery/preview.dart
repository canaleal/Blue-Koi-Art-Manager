import 'package:flutter/material.dart';
import 'package:flutter_test_bed/components/default_button.dart';
import 'package:flutter_test_bed/database/database.dart';
import 'package:flutter_test_bed/domain/unimage.dart';
import 'package:flutter_test_bed/size_config.dart';
import 'package:unsplash_client/unsplash_client.dart';
import '../../constants.dart';

class Preview extends StatefulWidget {
  const Preview({Key? key, required Photo photo})
      : _photo = photo,
        super(key: key);

  final Photo _photo;

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  late Photo photo;

  @override
  void initState() {
    photo = widget._photo;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  Future<void> saveImage() async {


      try{
        UnImage unImage = UnImage(id: 0, url: 'tttt', username: photo.user.username.toString());
        database();

      }
      catch(error){
        print(error);
      }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Preview'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () {
              saveImage();
              // do something
            },
          )
        ],
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
              Image.network(
                photo.urls.regular.toString(),
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                fit: BoxFit.cover,
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Text(
                'Creator : ${photo.user.username}',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              Text(
                'Updated at : ${photo.updatedAt.toString()}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
