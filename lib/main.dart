import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_app/take_picture.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Camera App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _path;
  void _showPhotoLibrary() async {
    // ignore: deprecated_member_use
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _path = file.path;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SafeArea(
            child: Column(children: <Widget>[
            _path == null ? Image.asset("images/place-holder.png") :
             Image.file(File(_path)),
            FlatButton(
               child: Text("Take Picture", style: TextStyle(color: Colors.white)),
               color: Colors.green,
               onPressed: () {
              _showOptions(context);
               },
            )
    ]),
      // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }




  void _showCamera() async {

    final cameras = await availableCameras();
    final camera = cameras.first;

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePicturePage(camera: camera)));

    setState(() {
      _path = result;
    });

  }

  void _showOptions(BuildContext context) {

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: 150,
              child: Column(children: <Widget>[
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _showCamera();
                    },
                    leading: Icon(Icons.photo_camera),
                    title: Text("Take a picture from camera")
                ),
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _showPhotoLibrary();
                    },
                    leading: Icon(Icons.photo_library),
                    title: Text("Choose from photo library")
                )
              ])
          );
        }
    );

  }

}
