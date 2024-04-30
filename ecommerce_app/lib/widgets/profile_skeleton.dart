import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';

Widget profileSkeleton() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SkeletonItem(
        child: Column(
      children: [
        const SizedBox(
          height: 35,
        ),
        Row(
          children: [
            SkeletonAvatar(
              
              style: SkeletonAvatarStyle(
                
                  shape: BoxShape.circle, width: 50, height: 50),
            ),
            SizedBox(width: 8),
            Expanded(
              child: SkeletonParagraph(
                style: SkeletonParagraphStyle(
                    lines: 2,
                    spacing: 6,
                    lineStyle: SkeletonLineStyle(
                      randomLength: true,
                      height: 10,
                      borderRadius: BorderRadius.circular(8),
                      minLength: Get.width / 6,
                      maxLength: Get.width / 2,
                    )),
              ),
            )
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SkeletonAvatar(
                style:
                    SkeletonAvatarStyle(width: Get.width / 3.2, height: 100)),
            SkeletonAvatar(
                style:
                    SkeletonAvatarStyle(width: Get.width / 3.2, height: 100)),
            SkeletonAvatar(
                style:
                    SkeletonAvatarStyle(width: Get.width / 3.2, height: 100)),
          ],
        ),
        SizedBox(height: 12),
        SkeletonAvatar(
          style: SkeletonAvatarStyle(
            height: Get.height / 3,
            width: double.infinity,
          ),
        ),
      ],
    )),
  );
}
