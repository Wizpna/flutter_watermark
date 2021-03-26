import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stamp_image/stamp_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stamp Image',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final picker = ImagePicker();
  File image;

  void takePicture() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await resetImage();
      StampImage.create(
          context: context,
          image: File(pickedFile.path),
          child: [
            Positioned(
              bottom: 0,
              right: 0,
              child: _watermarkItem(),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: _logoFlutter(),
            )
          ],
          onSuccess: (file) {
            resultStamp(file);
          });
    }
  }

  ///Resetting an image file
  Future resetImage() async {
    setState(() {
      image = null;
    });
  }

  ///Handler when stamp image complete
  void resultStamp(File file) {
    print(file?.path);
    setState(() {
      image = file;
    });
  }

  Widget _watermarkItem() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            DateTime.now().toString(),
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          SizedBox(height: 5),
          Text(
            "Made By Stamp Image",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _logoFlutter() {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: FlutterLogo(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stamp Imager"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Tap on Take Picture button to choose an image you want to add watermark',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SizedBox(),
            _imageWidget(),
            SizedBox(height: 10),
            _buttonTakePicture(),
            SizedBox(height: 10),
            image == null ? SizedBox() : _buttonSavePicture()
          ],
        ),
      ),
    );
  }

  Widget _buttonTakePicture() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: ElevatedButton(
          onPressed: () => takePicture(),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: Text(
            "Take Picture",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )),
    );
  }

  Widget _buttonSavePicture() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: ElevatedButton(
          onPressed: () async {
            print(image);
            if (image != null) {
              GallerySaver.saveImage(
                image.path,
              ).then((bool success) {
                setState(() {
                  print('image saved!');
                  final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              });
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: Text(
            "Download Picture",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )),
    );
  }

  Widget _imageWidget() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      child: image != null ? Image.file(image) : SizedBox(),
    );
  }
}
