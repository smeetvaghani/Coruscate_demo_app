import 'dart:math';

import 'package:demo_app/helpers/imageprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isInit = true;
  bool _isLoad = false;
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    try {
      if (_isInit) {
        setState(() {
          _isLoad = true;
        });
        await Provider.of<ImagesProvider>(context, listen: false).getImages();
        await Provider.of<ImagesProvider>(context, listen: false).getImagesUrl();
        setState(() {
          _isLoad = false;
        });
      }
      _isInit = false;
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageData = Provider.of<ImagesProvider>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo App"),
      ),
      body: _isLoad
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(8),
              child: GridView.builder(
                itemCount: imageData.length * 100,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    childAspectRatio: 1 / 0.73),
                itemBuilder: (context, i) => Container(
                  height: 3,
                  width: 3,
                  color: Colors.black,
                  child: Container(
                    child: Image.network(
                      imageData[Random().nextInt(imageData.length)].imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
