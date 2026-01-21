import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/api/clinic_api.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../main.dart';
import 'model/clinic_gallery_model.dart';

class ClinicGalleryListController extends GetxController {
  Rx<Future<RxList<GalleryData>>> galleryListFuture = Future(() => RxList<GalleryData>()).obs;
  RxBool isLoading = false.obs;
  RxList<GalleryData> galleryList = RxList();
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  RxInt clinicId = (-1).obs;
  RxList<GalleryData> deletedGalleryList = RxList();
  RxList<File> imageFile = <File>[].obs;
  XFile? pickedFile;
  RxList<int> deletedId = RxList();

  @override
  void onInit() {
    if (Get.arguments is int) {
      clinicId(Get.arguments as int);
    }
    getGalleryList();
    super.onInit();
  }

  Future<void> getGalleryList({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await galleryListFuture(
      ClinicApis.getClinicGalleryList(
        page: page.value,
        galleryList: galleryList,
        clinicId: clinicId.value,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      isLoading(false);
      log("getClinicGallery error $e");
    }).whenComplete(() => isLoading(false));
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: locale.value.gallery,
              leading: const Icon(Icons.image, color: appColorPrimary),
              onTap: () async {
                _handleGalleryClick();
              },
            ),
            SettingItemWidget(
              title: locale.value.camera,
              leading: const Icon(Icons.camera, color: appColorPrimary),
              onTap: () {
                _handleCameraClick();
              },
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }

  void deleteGalleryList() {
    isLoading(true);
    ClinicApis.deleteClinicGallery(
        request: {'id': clinicId.value, 'remove_image_ids': deletedId},
        onSuccess: (p0) {
          getGalleryList();
          deletedId.clear();
          deletedGalleryList.clear();
          toast(locale.value.clinicGalleryDeleteSuccessfully);
        },).then((value) {}).catchError((e) {
      toast(e.toString());
    }).whenComplete(() => isLoading(false));
  }

  void saveGalleryImages() {
    isLoading(true);
    ClinicApis.saveClinicGallery(
      request: {'id': clinicId.value},
      onSuccess: (p0) {
        log("Gallery $p0");
        imageFile.clear();
        getGalleryList();
      },
      imageFile: imageFile.isNotEmpty ? imageFile : null,
    ).then((value) {
      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString());
    });
  }

  Future<void> _handleGalleryClick() async {
    Get.back();
    List<XFile> pickedFile1;
    pickedFile1 = await ImagePicker().pickMultiImage(limit: 5, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile1.isNotEmpty) {
      for (final element in pickedFile1) {
        imageFile.add(File(element.path));
      }
      saveGalleryImages();
    }
  }

  Future<void> _handleCameraClick() async {
    Get.back();
    pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      imageFile.add(File(pickedFile!.path));
      saveGalleryImages();
    }
  }
}
