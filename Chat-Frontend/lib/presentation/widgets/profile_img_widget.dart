import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/core/app_assets.dart';
import 'package:flutter/material.dart';

import '../../core/api.dart';

class ProfileImgWidget extends StatelessWidget {
  final String imgUrl;
  final void Function()? onTap;
  final double? imgSize;
  final double? imgWid;
  const ProfileImgWidget({
    super.key,
    this.onTap,
    this.imgSize,
    this.imgWid,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: imgSize ?? MediaQuery.sizeOf(context).height * 0.06,
        child: imgUrl.isEmpty
            ? Image.asset(
                AppAssets.placeholder,
                height: 90,
              )
            : ClipOval(
                child: CachedNetworkImage(
                  placeholder: (context, String imge) {
                    return Image.asset(
                      AppAssets.placeholder,
                      height: MediaQuery.sizeOf(context).height * 0.058,
                    );
                  },
                  imageUrl: "$ImgBaseUrl$imgUrl",
                  width: imgWid ?? MediaQuery.sizeOf(context).height * 0.14,
                  fit: BoxFit.fitWidth,
                ),
              ),
      ),
    );
  }
}
