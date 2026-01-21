import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/service/model/service_list_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../main.dart';
import '../../../utils/common_base.dart';
import '../../category/model/all_category_model.dart';
import 'service_apis.dart';

class AddServiceController extends GetxController {
  TextEditingController serviceCont = TextEditingController();
  TextEditingController durationCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();
  TextEditingController categoryCont = TextEditingController();
  TextEditingController searchCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode serviceNameFocus = FocusNode();
  FocusNode serviceDurationFocus = FocusNode();
  FocusNode defaultPriceFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  Rx<ServiceElement> serviceData = ServiceElement(status: false.obs).obs;

  RxBool isLoading = false.obs;
  RxBool hasErrorFetchingCategory = false.obs;
  RxBool isEdit = false.obs;

  RxString errorMessageCategory = "".obs;
  RxString serviceImage = "".obs;

  RxList<PlatformFile> serviceFiles = RxList();

  //Category
  Rx<CategoryElement> selectedCategoryType = CategoryElement().obs;
  RxList<CategoryElement> categoryList = RxList();
  RxList<CategoryElement> categoryFilterList = RxList();

  // RxList<XFile> pickedFile = RxList();
  Rx<File> imageFile = File("").obs;
  XFile? pickedFile;

  final GlobalKey<FormState> addClinicformKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    if (Get.arguments is ServiceElement) {
      serviceData(Get.arguments as ServiceElement);
      isEdit(true);
      serviceCont.text = serviceData.value.name;
      durationCont.text = serviceData.value.duration.toString();
      priceCont.text = serviceData.value.charges.toString();
      descriptionCont.text = serviceData.value.description;
      categoryCont.text = serviceData.value.name;
      // selectedCategoryType.value.categoryImage = serviceData.value.serviceImage;
      selectedCategoryType.value.id = serviceData.value.categoryId;
      serviceImage(serviceData.value.serviceImage);
    }

    super.onInit();
  }

  Future<void> handleFilesPickerClick() async {
    final pickedFiles = await pickFiles();
    final Set<String> filePathsSet = serviceFiles.map((file) => file.name.trim().toLowerCase()).toSet();
    for (var i = 0; i < pickedFiles.length; i++) {
      if (!filePathsSet.contains(pickedFiles[i].name.trim().toLowerCase())) {
        serviceFiles.add(pickedFiles[i]);
      }
    }
  }

  //Get Category List
  void getCategory() {
    isLoading(true);
    ServiceFormApis.getCategory().then((value) {
      isLoading(false);
      categoryList(value.data);
      hasErrorFetchingCategory(false);
    }).onError((error, stackTrace) {
      hasErrorFetchingCategory(true);
      errorMessageCategory(error.toString());
      isLoading(false);
      // toast(error.toString());
    });
  }

  void searchCategoryFunc({
    required String searchtext,
    required RxList<CategoryElement> categoryFilterList,
    required RxList<CategoryElement> categorySList,
  }) {
    categoryFilterList.value = List.from(categorySList.where((element) => element.name.toLowerCase().contains(searchtext.toLowerCase())));
    for (var i = 0; i < categoryFilterList.length; i++) {}
  }

  void onCategorySearchChange(String searchtext) {
    searchCategoryFunc(
      searchtext: searchtext,
      categoryFilterList: categoryFilterList,
      categorySList: categoryList,
    );
  }

  bool get isShowFullList => categoryFilterList.isEmpty && searchCont.text.trim().isEmpty;

  /*String serviceRole({loginUserData}) {
     if (loginUserData.value.userRole.contains(EmployeeKeyConst.veterinary)) {
      return ServicesKeyConst.veterinary;
    } else if (loginUserData.value.userRole.contains(EmployeeKeyConst.grooming)) {
      return ServicesKeyConst.grooming;
    } else if (loginUserData.value.userRole.contains(EmployeeKeyConst.training)) {
      return ServicesKeyConst.training;
    } else {
      return "";
    }
    return "";
  }*/

  Future<void> updateServicesStatus({required int id, required int status}) async {
    isLoading(true);
    hideKeyBoardWithoutContext();

    ServiceFormApis.updateServicesStatus(serviceId: id, request: {"status": status}).then((value) {
      Get.back(result: true);
      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString());
    });
  }

  Future<void> _handleGalleryClick() async {
    Get.back();
    pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      serviceImage('');
      imageFile(File(pickedFile!.path));
    }
  }

  Future<void> _handleCameraClick() async {
    Get.back();
    pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      serviceImage('');
      imageFile(File(pickedFile!.path));
    }
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
}
