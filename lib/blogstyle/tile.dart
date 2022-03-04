import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BlogsTile extends StatefulWidget {
  final String imgUrl, tittle, description, authorName;

  const BlogsTile(
      {Key? key,
      required this.imgUrl,
      required this.tittle,
      required this.authorName,
      required this.description})
      : super(key: key);

  @override
  State<BlogsTile> createState() => _BlogsTileState();
}

class _BlogsTileState extends State<BlogsTile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        height: MediaQuery.of(context).size.height * 0.2,
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: widget.imgUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                )),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                  color: Colors.black45.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6)),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.tittle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(widget.description),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(widget.authorName),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
