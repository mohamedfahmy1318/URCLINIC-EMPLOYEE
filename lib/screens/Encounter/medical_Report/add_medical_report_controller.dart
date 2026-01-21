import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/medical_Report/medical_reports_controller.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../api/core_apis.dart';
import '../../../main.dart';
import '../../../utils/common_base.dart';
import '../../../utils/getImage.dart';
import '../model/add_medical_report_req.dart';
import '../model/medical_reports_res_model.dart';

class AddMedicalReportController extends GetxController {
  RxBool isEdit = false.obs;

  Rx<MedicalReport> medicalReport = MedicalReport().obs;

  RxBool isLoading = false.obs;

  RxString medicalReportImage = "".obs;
  RxList<PlatformFile> medicalFiles = RxList();
  Rx<File> imageFile = File("").obs;
  XFile? pickedFile;

  //TextFiled Controller
  final GlobalKey<FormState> medicalReportsFormKey = GlobalKey();
  TextEditingController nameCont = TextEditingController();
  RxBool isNameNotEmpty = false.obs;
  TextEditingController dateCont = TextEditingController();
  RxBool isDateNotEmpty = false.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    if (Get.arguments is MedicalReport) {
      medicalReport(Get.arguments as MedicalReport);
      isEdit(true);
      nameCont.text = medicalReport.value.name;
      dateCont.text = medicalReport.value.date;
      if (nameCont.text.isNotEmpty) isNameNotEmpty(true);
      if (dateCont.text.isNotEmpty) isDateNotEmpty(true);
      medicalReportImage(medicalReport.value.fileUrl);
    } else {
      try {
        final MedicalReportsController medReportsCont = Get.find();
        medicalReport(
          MedicalReport(
            encounterId: medReportsCont.encounterData.value.id,
            userId: medReportsCont.encounterData.value.userId,
          ),
        );
      } catch (e) {
        log('medReportsCont = Get.find() E: $e');
      }
    }
    super.onInit();
  }

  void clearMedReportData() {
    nameCont.text = "";
    dateCont.text = "";
    medicalReportImage("");
    imageFile(File(""));
    medicalFiles = RxList();
  }

  Future<void> _handleCameraClick() async {
    Get.back();
    GetImage(
      ImageSource.camera,
      path: (path, name, xFile) async {
        medicalReportImage('');
        imageFile(File(xFile.path));
      },
    );
  }

  Future<void> _handleDocumentClick() async {
    isLoading(true);
    Get.back();
    await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'doc', 'docx', 'pdf'],
    ).then((pickedfiles) async {
      if (pickedfiles != null && pickedfiles.files.isNotEmpty && pickedfiles.files.first.path != null) {
        medicalReportImage('');
        bool isValid = await isImageSmallerThan5MB(pickedfiles.files);
        if (!isValid) {
          toast(locale.value.selectedFileShouldBeLessThan5MB);
          return;
        }
        pickedFile = XFile(pickedfiles.files.first.path!);
        imageFile(File(pickedfiles.files.first.path!));
      } else {
        toast(locale.value.noFileSelected);
      }
    }).catchError((e) {
      toast('File picking failed: $e');
      return;
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
              title: locale.value.file,
              leading: const Icon(Icons.image, color: appColorPrimary),
              onTap: () async {
                _handleDocumentClick();
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

  Future<void> addEditMedicalReport() async {
    isLoading(true);
    final AddMedicalReportReq addMedicalReportReq = AddMedicalReportReq(
      date: dateCont.text.dateInyyyyMMddFormat.formatDateYYYYmmdd(),
      encounterId: medicalReport.value.encounterId.toString(),
      name: nameCont.text.trim(),
      userId: medicalReport.value.userId.toString(),
    );
    CoreServiceApis.saveMedicalReport(
      reportId: isEdit.value && !medicalReport.value.id.isNegative ? medicalReport.value.id : null,
      isEdit: isEdit.value,
      request: addMedicalReportReq.toJson(),
      files: imageFile.value.path.isNotEmpty ? [imageFile.value] : null,
    ).then((value) {
      Get.back(result: true);
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() => isLoading(false));
  }

  Future<bool> isImageSmallerThan5MB(List<PlatformFile> images) async {
    if (images.isEmpty) return false;

    const int maxSizeInBytes = 5 * 1024 * 1024;

    for (final image in images) {
      if (image.size > maxSizeInBytes) {
        return false;
      }
    }
    return true;
  }
}
