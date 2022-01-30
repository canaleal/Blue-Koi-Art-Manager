import 'package:flutter/material.dart';
import 'package:flutter_test_bed/domain/general_image.dart';
import 'package:flutter_test_bed/size_config.dart';

class ImageContainer extends StatefulWidget {
  const ImageContainer({Key? key, required GeneralImage generalImage, required Function navigationHandler})
      : _generalImage = generalImage,
        _navigationHandler = navigationHandler,
        super(key: key);

  final GeneralImage _generalImage;
  final Function _navigationHandler;

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  late GeneralImage generalImage;
  late Function navigationHandler;

  @override
  void initState() {
    navigationHandler = widget._navigationHandler;
    generalImage = widget._generalImage;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(2),
          horizontal: getProportionateScreenWidth(2)),
      child: InkWell(
          onTap: () {
            navigationHandler(generalImage);
          },
          child: Image.network(
            generalImage.urlThumb,
            fit: BoxFit.cover,
          )),
    );
  }
}
