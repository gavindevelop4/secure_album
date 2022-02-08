import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_album/constants.dart';

class AlbumGrid extends StatelessWidget {
  const AlbumGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (Get.width - defaultPadding * 6) / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: (Get.width - defaultPadding * 7) / 2,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(defaultBorderRadius),
            ),
            child: const Image(
              image: AssetImage(
                'assets/testImages/test-image-1.jpeg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 4),
            child: Column(
              children: [
                Text(
                  'Test',
                  style: context.textTheme.bodyText1,
                ),
                Text(
                  '123',
                  style: context.textTheme.bodyText2,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
