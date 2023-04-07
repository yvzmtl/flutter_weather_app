import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ForeCastTileWidget extends StatelessWidget {
  String? temp;
  String? imageUrl;
  String? time;

  ForeCastTileWidget(
      {super.key,
      required this.temp,
      required this.time,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                temp ?? '',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 15,
              ),
              CachedNetworkImage(
                imageUrl: imageUrl ?? '',
                // 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Weather-rain-thunderstorm.svg/431px-Weather-rain-thunderstorm.svg.png',
                //imageUrl:
                //   'https://www.pngitem.com/pimgs/m/233-2334556_cloud-with-lightning-and-rain-icon-temporale-emoji.png',
                height: 35,
                width: 35,
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, err) => const Icon(
                  Icons.image,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                time ?? '',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
