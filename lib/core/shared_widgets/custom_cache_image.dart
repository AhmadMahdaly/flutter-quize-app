import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCacheImageWidget extends StatelessWidget {
  const CustomCacheImageWidget({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
  });
  final String imageUrl;
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageUrl,
      // height: height ?? 74.h,
      width: double.infinity,
      placeholder: (context, url) => const LinearProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.image),
    );
  }
}
