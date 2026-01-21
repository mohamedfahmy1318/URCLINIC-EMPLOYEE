import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../generated/assets.dart';
import '../main.dart';
import '../screens/Encounter/medical_Report/components/common_file_placeholders.dart';
import '../utils/colors.dart';
import 'app_primary_widget.dart';
import 'cached_image_widget.dart';
import 'loader_widget.dart';

class AddFilesWidget extends StatelessWidget {
  final String? eId;
  final double? width;
  final RxList<FileElement>? eFiles;
  final RxList<PlatformFile> fileList;
  final VoidCallback onFilePick;
  final Function(int)? onFileRemove;
  final Function(int) onFilePathRemove;

  const AddFilesWidget({
    super.key,
    this.eId,
    this.width,
    this.eFiles,
    required this.fileList,
    required this.onFilePick,
    this.onFileRemove,
    required this.onFilePathRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (eId != null)
          SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                AppPrimaryWidget(
                  width: 80,
                  constraints: const BoxConstraints(minHeight: 80),
                  padding: const EdgeInsets.all(8),
                  border: Border.all(color: appColorPrimary),
                  onTap: () {
                    onFilePick;
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_circle_outline_rounded, color: appColorPrimary, size: 24),
                      8.height,
                      Text(
                        locale.value.addFiles,
                        style: boldTextStyle(color: appColorPrimary, size: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                ...List.generate(eFiles
                    .validate()
                    .length, (index) {
                  log('EVENTFILES[INDEX].URL: ${eFiles.validate()[index].url}');
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        const SizedBox(
                          width: 80,
                          height: 80,
                          child: Loader(),
                        ),
                        eFiles.validate()[index].url.isImage
                            ? CachedImageWidget(
                          url: eFiles.validate()[index].url,
                          height: 80,
                          width: 80,
                        )
                            : CommonPdfPlaceHolder(text: eFiles.validate()[index].url
                            .split("/")
                            .last),
                        Positioned(
                          right: -8,
                          top: -8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: appColorPrimary,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 18),
                          ).onTap(() {
                            if (onFileRemove != null) {
                              onFileRemove!.call(index);
                            }
                          }),
                        ),
                      ],
                    ),
                  );
                }),
                ...List.generate(fileList.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        const SizedBox(
                          width: 80,
                          height: 80,
                          child: Loader(),
                        ),
                        fileList[index].path.isImage
                            ? Image.file(
                          File(fileList[index].path.validate()),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(
                            width: 80,
                            height: 80,
                          ),
                        ).cornerRadiusWithClipRRect(defaultRadius)
                            : CommonPdfPlaceHolder(text: fileList[index].name),
                        Positioned(
                          right: -8,
                          top: -8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: appColorPrimary,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 18),
                          ).onTap(() => onFilePathRemove.call(index)),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(
                  () =>
                  Column(
                    children: [
                      AppPrimaryWidget(
                        width: width ?? 80,
                        constraints: const BoxConstraints(minHeight: 85),
                        borderRadius: defaultRadius,
                        backgroundColor: context.cardColor,
                        onTap: onFilePick,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CachedImageWidget(
                              url: Assets.iconsIcImageUpload,
                              height: 20,
                              color: secondaryTextColor,
                              fit: BoxFit.fitHeight,
                            ),
                            10.height,
                            Text(
                              locale.value.addMedicalReport,
                              style: boldTextStyle(size: 14),
                              textAlign: TextAlign.center,
                            ),
                            6.height,
                            Text(
                              '(${locale.value.optional})',
                              style: secondaryTextStyle(size: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: AnimatedListView(
                          itemCount: fileList.length,
                          padding: const EdgeInsets.only(top: 16),
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                if (fileList[index].name.isEmpty)
                                  const SizedBox(
                                    width: 38,
                                    height: 38,
                                    child: LoaderWidget(),
                                  ),
                                SettingItemWidget(
                                  title: fileList[index].name,
                                  titleTextStyle: primaryTextStyle(),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: boxDecorationDefault(borderRadius: const BorderRadius.all(Radius.circular(8))),
                                  leading: Icon(
                                    fileList[index].path.isImage ? Icons.image_outlined : Icons.file_copy_outlined,
                                    color: appColorPrimary,
                                    size: 20,
                                  ),
                                  trailing: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: appColorPrimary),
                                    child: const Icon(Icons.close, color: Colors.white, size: 12),
                                  ).onTap(() => onFilePathRemove.call(index)),
                                ).paddingBottom(16),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
            ),
          ),
      ],
    );
  }
}

class FileElement {
  int id;
  String url;

  FileElement({this.id = -1, this.url = ""});

  factory FileElement.fromJson(Map<String, dynamic> json) =>
      FileElement(
        id: json["id"] is int
            ? json["id"]
            : json["id"] is String
            ? json["id"].toString().toInt(defaultValue: -1)
            : -1,
        url: json['url'] is String ? json['url'] : "",
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "url": url,
      };
}
