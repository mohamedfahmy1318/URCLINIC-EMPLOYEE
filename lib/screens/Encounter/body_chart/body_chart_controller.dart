import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import '../../../api/core_apis.dart';
import '../../../main.dart';
import '../model/encounters_list_model.dart';
import 'model/body_chart_resp.dart';
import 'package:http/http.dart' as http;

class BodyChartController extends GetxController {
  Rx<Future<RxList<BodyChartModel>>> bodyChartListFuture = Future(() => RxList<BodyChartModel>()).obs; //To-do Change Models
  RxBool isLoading = false.obs;
  RxList<BodyChartModel> bodyChartList = RxList(); //To-do Change Models
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  RxBool isSaveLogin = false.obs;
  RxBool isEdit = false.obs;

  Rx<EncounterElement> encounter = EncounterElement().obs;

  //TextField Controller
  final GlobalKey<FormState> addBodyChartFormKey = GlobalKey();
  TextEditingController imageTitleCont = TextEditingController();
  RxBool isTitleNotEmpty = false.obs;
  TextEditingController imageDescCont = TextEditingController();
  RxBool isImageDescNotEmpty = false.obs;

  FocusNode imageTitleFocus = FocusNode();
  FocusNode imageDecrFocus = FocusNode();
  Rx<BodyChartModel> selectedChartDet = BodyChartModel().obs;

  RxString bodyImage = "".obs;
  Rx<File> imageFile = File("").obs;
  XFile? pickedFile;
  Rx<File> editedImg = File("").obs;

  @override
  void onInit() {
    if (Get.arguments is EncounterElement) {
      encounter(Get.arguments);
    }
    getAllBodyChart();
    super.onInit();
  }

  void setChartDetails({required BodyChartModel chartDet}) {
    isEdit(true);
    selectedChartDet(chartDet);
    imageTitleCont.text = chartDet.name;
    imageDescCont.text = chartDet.description;
    bodyImage(chartDet.fileUrl);
    if (imageTitleCont.text.isNotEmpty) isTitleNotEmpty(true);
    if (imageDescCont.text.isNotEmpty) isImageDescNotEmpty(true);
  }

  Future<void> getAllBodyChart({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await bodyChartListFuture(
      CoreServiceApis.getBodyChartLists(
        page: page.value,
        encounterId: encounter.value.id,
        bodyChartList: bodyChartList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getAllBodyChart Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> _handleGalleryClick() async {
    Get.back();
    pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      imageFile(File(pickedFile!.path));
      editImage();
    }
  }

  Future<void> _handleCameraClick() async {
    Get.back();
    pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      imageFile(File(pickedFile!.path));
      editImage();
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

  //Show
  Future<bool?> removeImageDialog() {
    return showConfirmDialogCustom(
      Get.context!,
      primaryColor: Get.context!.primaryColor,
      title: "${locale.value.doYouWantToRemoveImage}?",
      positiveText: locale.value.yes,
      negativeText: locale.value.cancel,
      onAccept: (ctx) async {
        editedImg(File(""));
        imageFile(File(""));
        bodyImage("");
      },
    );
  }

  // Image Editor
  Future<void> editImage() async {
    if (pickedFile != null) {
      Get.to(
        () => ProImageEditor.file(
          File(pickedFile!.path),
          callbacks: ProImageEditorCallbacks(
            onImageEditingComplete: (Uint8List bytes) async {
              try {
                // Get the temporary directory of the device
                final tempDir = await getTemporaryDirectory();
                final tempFile = File('${tempDir.path}/edited_image.jpg');

                // Write the bytes to the file
                await tempFile.writeAsBytes(bytes);
                editedImg(tempFile);
              } catch (e) {
                log('Error saving file: $e');
              }
              Get.back();
            },
          ),
        ),
      );
    }
  }

  Future<void> cropNetWorkImage() async {
    if (bodyImage.isNotEmpty) {
      File cropped = File("");
      final response = await http.get(Uri.parse(bodyImage.value));
      final documentDirectory = await getApplicationDocumentsDirectory();
      cropped = File('${documentDirectory.path}temp_image.jpg');
      cropped.writeAsBytesSync(response.bodyBytes);
      pickedFile = XFile(cropped.path);
      editImage();
    }
  }

  void clearBodyChatData() {
    imageTitleCont.text = "";
    imageDescCont.text = "";
    editedImg(File(""));
    imageFile(File(""));
  }

  Future<void> saveBodyChart() async {
    isLoading(true);
    final Map<String, dynamic> req = {
      'name': imageTitleCont.text.trim(),
      'description': imageDescCont.text.trim(),
      'encounter_id': encounter.value.id,
    };

    CoreServiceApis.saveBodyChart(
      request: req,
      id: selectedChartDet.value.id,
      files: editedImg.value.path.isNotEmpty ? [File(editedImg.value.path)] : null,
      isEdit: isEdit.value,
    ).then((value) async {
      clearBodyChatData();
      Get.back();
      getAllBodyChart();
    }).catchError((e) {
      toast(e.toString(), print: true);
    }).whenComplete(() => isLoading(false));
  }

  //Delete Encounter
  Future<void> deleteBodyChart({required int id, required int index}) async {
    isLoading(true);
    CoreServiceApis.deleteBodyChart(chartId: id).then((value) {
      bodyChartList.removeAt(index);
      toast(value.message.trim().isEmpty ? locale.value.bodyChartDeleteSuccessfully : value.message.trim());
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() => isLoading(false));
  }
}
