import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final gemini = Gemini.instance;
  final TextEditingController _promptController = TextEditingController();
  List messages = [];
  String result = "";
  List<Uint8List> images = [];
  bool isBusy = false;
  ImageSource _source = ImageSource.camera;
  bool _cancel = false;

  void newMessage(String text) async {
    setState(() {
      isBusy = true;
    });
    var res = await gemini.textAndImage(text: text, images: images);
    setState(() {
      isBusy = false;
      result = res?.output ?? "No Output";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (images.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Image.memory(images[index]),
                            Align(
                              alignment: Alignment.topRight,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.black,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      images.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              Expanded(
                  child: Center(
                child: isBusy ? const CircularProgressIndicator() : Text(result),
              )),
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Select Image"),
                          content: Text(
                              "Select an image from gallery or take a photo"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _source = ImageSource.gallery;
                                });
                              },
                              child: Text("Gallery"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _source = ImageSource.camera;
                                });
                              },
                              child: Text("Camera"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _cancel = true;
                                });
                              },
                              child: Text("Cancel"),
                            ),
                          ],
                        ),
                      );
                      if (_cancel) {
                        setState(() {
                          _cancel = false;
                        });
                        return;
                      }
                      final image = await ImagePicker().pickImage(
                        source: _source,
                      );
                      if (image != null) {
                        debugPrint(image.path);
                        setState(() {
                          images.add(File(image.path).readAsBytesSync());
                        });
                      }
                    },
                    icon: const Icon(Icons.file_upload_outlined),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _promptController,
                      decoration: const InputDecoration(
                        label: Text("Your prompt"),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      newMessage(_promptController.text);
                      _promptController.clear();
                    },
                    icon: const Icon(Icons.send),
                    enableFeedback: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
