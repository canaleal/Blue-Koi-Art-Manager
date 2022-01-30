import 'package:flutter/material.dart';

class UploadDialog {
  showAlertDialog(BuildContext context, String alertTitle, String alertMessage,
      Function _uploadHandler) {
    // set up the buttons

    Widget cancelButton = TextButton(
      child: const Text('No'),
      onPressed: () => Navigator.pop(context, 'Cancel'),
    );
    Widget uploadButton = TextButton(
      onPressed: () => {_uploadHandler(), Navigator.pop(context, 'OK')},
      child: const Text('Yes'),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        title: Text(alertTitle),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[Text(alertMessage)],
          ),
        ),
        actions: [
          cancelButton,
          uploadButton,
        ]);

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  UploadDialog();
}
