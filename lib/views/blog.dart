import 'dart:io';

import 'package:blog/services/crud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateYourBlog extends StatefulWidget {
  const CreateYourBlog({Key? key}) : super(key: key);

  @override
  _CreateYourBlogState createState() => _CreateYourBlogState();
}

class _CreateYourBlogState extends State<CreateYourBlog> {
  File? image;
  String? authorName, tittle, desc;
  bool _isLoading = false;
  CrudMethods crudMethods = CrudMethods();

  Future pickImage() async {
    try {
      final pic = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pic == null) return;
      final imgTemp = File(pic.path);
      setState(() {
        image = imgTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick Image:$e');
    }
  }

  addBlog() async {
    if (image != null) {
      setState(() {
        _isLoading = true;
      });
      Reference firebaseReference = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");

      final UploadTask task = firebaseReference.putFile(image!);

      var downloadUrl = await (await task).ref.getDownloadURL();

      Map<String, String> blogMap = {
        "imgUrl": downloadUrl,
        "authorName": authorName!,
        "tittle": tittle!,
        "desc": desc!,
      };
      crudMethods.addData(blogMap).then((value) => Navigator.pop(context));
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Blog'),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              addBlog();
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: const Icon(Icons.file_upload)),
          )
        ],
      ),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: image != null
                        ? Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.file(image!, fit: BoxFit.cover)),
                          )
                        : Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: const Icon(
                              Icons.add_photo_alternate_outlined,
                              color: Colors.black,
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Column(
                      children: [
                        TextField(
                          decoration:
                              const InputDecoration(hintText: "Author Name"),
                          onChanged: (val) {
                            authorName = val;
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(hintText: "Tittle"),
                          onChanged: (val) {
                            tittle = val;
                          },
                        ),
                        TextField(
                          decoration:
                              const InputDecoration(hintText: "Description"),
                          onChanged: (val) {
                            desc = val;
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
