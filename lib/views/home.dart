import 'package:blog/blogstyle/tile.dart';
import 'package:blog/services/crud.dart';
import 'package:blog/views/blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = CrudMethods();
  Stream? blogStream;

  Widget blogList() {
    return Container(
        child: blogStream != null
            ? SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder(
                      stream: blogStream,
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                shrinkWrap: true,
                                itemCount: (snapshot.data as QuerySnapshot)
                                    .docs
                                    .length,
                                itemBuilder: (context, index) {
                                  return BlogsTile(
                                      imgUrl: (snapshot.data as QuerySnapshot)
                                          .docs[index]['imgUrl'],
                                      tittle: (snapshot.data as QuerySnapshot)
                                          .docs[index]['tittle'],
                                      authorName:
                                          (snapshot.data as QuerySnapshot)
                                              .docs[index]['authorName'],
                                      description:
                                          (snapshot.data as QuerySnapshot)
                                              .docs[index]['desc']);
                                })
                            : Container();
                      })
                ],
              ),
            )
            : Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ));
  }

  @override
  void initState() {
    crudMethods.getData().then((result) {
      setState(() {
        blogStream = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Blog',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Get.to(() => const CreateYourBlog());
            },
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: blogList(),
    );
  }
}
