import 'package:flutter/material.dart';
import 'package:flutter_test_bed/components/default_button.dart';
import 'package:flutter_test_bed/database/database.dart';
import 'package:flutter_test_bed/domain/unimage.dart';
import 'package:flutter_test_bed/infrastructure/google/google_auth_client.dart';
import 'package:flutter_test_bed/size_config.dart';
import 'package:unsplash_client/unsplash_client.dart' as u;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;


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

  @override
  void initState() {
     user = widget._user;
    photo = widget._photo;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  Future<void> saveImage() async {

      uploadToDrive();
    
  }


  Future<void> uploadToDrive() async {
    final googleSignIn =
        signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    final signIn.GoogleSignInAccount? account = await googleSignIn.signIn();

    final authHeaders = await account!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    final Stream<List<int>> mediaStream =
    Future.value([104, 105]).asStream().asBroadcastStream();
    var media = new drive.Media(mediaStream, 2);
    var driveFile = new drive.File();
    driveFile.name = "hello_world.txt";
    final result = await driveApi.files.create(driveFile, uploadMedia: media);
    print("Upload result: $result");

    /*
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
          'The Video was successfully uploaded to Google Drive.');

      print('success');
    } else {
      utility.showAlertDialog(
          context, 'Error', 'The file cannot be uploaded to Google Drive.');
      print('fail');
    }
    */
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
