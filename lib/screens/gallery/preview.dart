import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test_bed/infrastructure/google/google_auth_client.dart';
import 'package:flutter_test_bed/screens/gallery/component/alert_dialog.dart';
import 'package:flutter_test_bed/size_config.dart';
import 'package:unsplash_client/unsplash_client.dart' as u;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as sign_in;

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

class Preview extends StatefulWidget {
  const Preview({Key? key, required User user, required u.Photo photo})
      : 
        _user = user,
        _photo = photo,
        super(key: key);

  final User _user;
  final u.Photo _photo;

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  late User user;
  late u.Photo photo;
  late File file;
  bool isLoaded = false;
  @override
  void initState() {
    user = widget._user;
    photo = widget._photo;
     _download();
    super.initState();
  }

  @override
  void dispose() {
   
    super.dispose();
  }

  Future<void> _download() async{
    try {
      print('downloading');
      var _url = photo.urls.full;
      final response = await http.get(_url);

      // Get the image name 
      final imageName = path.basename(_url.toString());
      // Get the document directory path 
      final tempDir  = await path_provider.getTemporaryDirectory();

      // This is the saved image path 
      // You can use it to display the saved image later. 
      final localPath = path.join(tempDir .path, imageName);

      // Downloading
      final imageFile = File(localPath);
      await imageFile.writeAsBytes(response.bodyBytes);
      print('Downloaded!');
      file = imageFile;
      
       setState(() {
          isLoaded = true;
        });
      
    } on PlatformException catch (error) {
      print(error);
      
    }

  
  }




  Future<void> saveImage() async {

      return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attention'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to Upload this file to Google Drive?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.pop(context, 'Cancel'),
            ),
            TextButton(
              onPressed: () => {uploadToDrive(), Navigator.pop(context, 'OK')},
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    
  }


  Future<void> uploadToDrive() async {
    final googleSignIn =
        sign_in.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    final sign_in.GoogleSignInAccount? account = await googleSignIn.signIn();

    final authHeaders = await account!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);


   
  /*
    final Stream<List<int>> mediaStream =
    Future.value([104, 105]).asStream().asBroadcastStream();
    var media = new drive.Media(mediaStream, 2);
    var driveFile = new drive.File();
    driveFile.name = "hello_world.txt";
    final result = await driveApi.files.create(driveFile, uploadMedia: media);
    print("Upload result: $result");
    */

    
    bool success = await driveApi.files
        .create(drive.File()..name = photo.urls.full.toString(),
            uploadMedia: drive.Media(file.openRead(), file.lengthSync()))
        .then((response) async {
      drive.Permission request = drive.Permission();
      request.role = "commenter";
      request.type = "anyone";
      return await driveApi.permissions
          .create(request, response.id!)
          .then((resp) async {
        if (resp.id != null) {
          var link = "https://drive.google.com/file/d/" +
              response.id! +
              "/view?usp=sharing";
          print(link);

          return true;
        }
        return false;
      });
    });


    var utility = UtilityDialog();
    if (success) {
      utility.showAlertDialog(context, 'Success',
          'The File was successfully uploaded to Google Drive.');

     
    } else {
      utility.showAlertDialog(
          context, 'Error', 'The file cannot be uploaded to Google Drive.');
      
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
              Icons.upload,
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
          child: isLoaded? Column(
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
          ):  const Center(
                      child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                    ))
        ),
      ),
    );
  }
}
