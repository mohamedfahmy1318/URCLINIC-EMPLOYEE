import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'app_scaffold.dart';
import 'loader_widget.dart';

class ZoomImageScreen extends StatefulWidget {
  final int index;
  final List<String>? galleryImages;

  const ZoomImageScreen({super.key, required this.index, this.galleryImages});

  @override
  State<ZoomImageScreen> createState() => _ZoomImageScreenState();
}

class _ZoomImageScreenState extends State<ZoomImageScreen> {
  bool showAppBar = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    // enterFullScreen();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (canPop, res) {
        exitFullScreen();
      },
      child: AppScaffoldNew(
        appBartitleText: locale.value.gallery,
        appBarVerticalSize: Get.height * 0.12,
        body: GestureDetector(
          onTap: () {
            showAppBar = !showAppBar;

            if (showAppBar) {
              exitFullScreen();
            } else {
              enterFullScreen();
            }

            setState(() {});
          },
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(color: white),
            pageController: PageController(initialPage: widget.index),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(widget.galleryImages![index]),
                //imageProvider: Image.network(widget.galleryImages![index], errorBuilder: (context, error, stackTrace) => PlaceHolderWidget()).image,
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                errorBuilder: (context, error, stackTrace) => const PlaceHolderWidget(),
                heroAttributes: PhotoViewHeroAttributes(tag: widget.galleryImages![index]),
              );
            },
            itemCount: widget.galleryImages!.length,
            loadingBuilder: (context, event) => const LoaderWidget(),
          ),
        ),
      ),
    );
  }
}

class ZoomSingleImg extends StatelessWidget {
  final String url;

  const ZoomSingleImg({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          child: url.startsWith("http")
              ? PhotoView(
                  imageProvider: NetworkImage(url),
                  // Replace this with your image path
                  initialScale: PhotoViewComputedScale.contained,
                  minScale: PhotoViewComputedScale.contained,
                  errorBuilder: (context, error, stackTrace) => const PlaceHolderWidget(),
                  heroAttributes: PhotoViewHeroAttributes(tag: url),
                )
              : url.startsWith("assets/")
                  ? PhotoView(
                      imageProvider: AssetImage(url),
                      // Replace this with your image path
                      initialScale: PhotoViewComputedScale.contained,
                      minScale: PhotoViewComputedScale.contained,
                      errorBuilder: (context, error, stackTrace) => const PlaceHolderWidget(),
                      heroAttributes: PhotoViewHeroAttributes(tag: url),
                    )
                  : PhotoView(
                      imageProvider: FileImage(File(url)),
                      // Replace this with your image path
                      initialScale: PhotoViewComputedScale.contained,
                      minScale: PhotoViewComputedScale.contained,
                      errorBuilder: (context, error, stackTrace) => const PlaceHolderWidget(),
                      heroAttributes: PhotoViewHeroAttributes(tag: url),
                    ),
        ),
      ),
    );
  }
}
