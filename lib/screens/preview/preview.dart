import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test_bed/constants.dart';
import 'package:flutter_test_bed/domain/general_image.dart';
import 'package:flutter_test_bed/infrastructure/google/google_auth_client.dart';
import 'package:flutter_test_bed/components/alert_dialog.dart';
import 'package:flutter_test_bed/screens/preview/component/upload_diaglog.dart';
import 'package:flutter_test_bed/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as sign_in;

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

class Preview extends StatefulWidget {
  const Preview(
      {Key? key, required User user, required GeneralImage generalImage})
      : _user = user,
        _generalImage = generalImage,
        super(key: key);

  final User _user;
  final GeneralImage _generalImage;

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  late User user;
  late GeneralImage generalImage;
  late File file;

  bool isUploading = false;
  double _progressValue = 0.0;

  @override
  void initState() {
    user = widget._user;
    generalImage = widget._generalImage;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateProgress() {
    setState(() {
      _progressValue += 0.25;
    });
  }

  Future<void> saveImage() async {
    UploadDialog upload = UploadDialog();
    upload.showAlertDialog(context, 'Attention', uploadQuestion, uploadManager);
  }

  Future<void> uploadManager() async {
    UtilityDialog utility = UtilityDialog();
    bool isSuccessful = false;
    try {
      setState(() {
        isUploading = true;
      });

       _updateProgress();
      isSuccessful = await saveToLocal();
      if (isSuccessful == false) {
        throw Exception;
      }
       _updateProgress();


      
      isSuccessful = await uploadToDrive();
      if (isSuccessful == false) {
        throw Exception;
      }

    
      utility.showAlertDialog(context, 'Success',
          uploadSuccess);
    } on Exception {
      utility.showAlertDialog(
          context, 'Error', uploadFail);
    } finally {
      setState(() {
        isUploading = false;
        _progressValue = 0.0;
      });
    }
  }

  Future<bool> saveToLocal() async {
    try {
      var _url = Uri.parse(generalImage.urlFull);

      
      final response = await http.get(_url);
      final imageName = path.basename(_url.toString());
      final tempDir = await path_provider.getTemporaryDirectory();

      final localPath = path.join(tempDir.path, imageName);
      final imageFile = File(localPath);
      await imageFile.writeAsBytes(response.bodyBytes);

      setState(() {
        file = imageFile;
      });

     
      return true;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> uploadToDrive() async {
    final googleSignIn =
        sign_in.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    final sign_in.GoogleSignInAccount? account = await googleSignIn.signIn();

    final authHeaders = await account!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    bool success = await driveApi.files
        .create(drive.File()..name = generalImage.urlFull.toString(),
            uploadMedia: drive.Media(file.openRead(), file.lengthSync()))
        .then((response) async {

      _updateProgress();
      drive.Permission request = drive.Permission();
      request.role = "commenter";
      request.type = "anyone";
      return await driveApi.permissions
          .create(request, response.id!)
          .then((resp) async {
        if (resp.id != null) {
          //var link = "https://drive.google.com/file/d/" +
          response.id! + "/view?usp=sharing";
          //print(link);

          return true;
        }

        _updateProgress();
        return false;
      });
    });

    return success;
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
            child: isUploading
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Uploading Image, please wait.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      LinearProgressIndicator(
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.black),
                          value: _progressValue),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Text(
                        '${ _progressValue * 100} %',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        generalImage.urlThumb.toString(),
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
                        'Creator : ${generalImage.author}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Updated at : ${generalImage.date.toString()}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )
        ),
      ),
    );
  }
}
