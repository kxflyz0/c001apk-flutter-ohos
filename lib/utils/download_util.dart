import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

/// From Pilipala
class DownloadUtils {
  // 获取存储权限
  static Future<bool> requestStoragePer() async {
    await Permission.storage.request();
    PermissionStatus status = await Permission.storage.status;
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      SmartDialog.show(
        useSystem: true,
        animationType: SmartAnimationType.centerFade_otherSlide,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('提示'),
            content: const Text('存储权限未授权'),
            actions: [
              TextButton(
                onPressed: () async {
                  openAppSettings();
                },
                child: const Text('去授权'),
              )
            ],
          );
        },
      );
      return false;
    } else {
      return true;
    }
  }

  // 获取相册权限
  static Future<bool> requestPhotoPer() async {
    await Permission.photos.request();
    PermissionStatus status = await Permission.photos.status;
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      SmartDialog.show(
        useSystem: true,
        animationType: SmartAnimationType.centerFade_otherSlide,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('提示'),
            content: const Text('相册权限未授权'),
            actions: [
              TextButton(
                onPressed: () async {
                  openAppSettings();
                },
                child: const Text('去授权'),
              )
            ],
          );
        },
      );
      return false;
    } else {
      return true;
    }
  }

  static Future<void> downloadImg(List<String> urlList) async {
    try {
      if (Platform.isAndroid &&
          (await DeviceInfoPlugin().androidInfo).version.sdkInt <= 32) {
        if (!await requestStoragePer()) {
          return;
        }
      } else {
        if (!Platform.isOhos) {
          if (!await requestPhotoPer()) {
            return;
          }
        }
      }
      SmartDialog.showLoading(msg: '保存中');
      for (int index = 0; index < urlList.length; index++) {
        GallerySaver.saveImage(urlList[index],
                albumName: "Pictures/c001apk-flutter")
            .then((bool? success) {
          if (success != null && !success) {
            SmartDialog.dismiss();
            SmartDialog.showToast(
                '${index + 1}/${urlList.length}: save failed, code $success');
          }
          if (index == urlList.length - 1) {
            SmartDialog.dismiss();
            if (success != null && !success) {
              SmartDialog.showToast('已保存');
            }
          }
        });
        // final SaveResult result = await SaverGallery.saveImage(
        //   Uint8List.fromList(response.data),
        //   name: picName,
        //   androidRelativePath: "Pictures/c001apk-flutter",
        //   androidExistNotSave: true,
        // );
      }
    } catch (err) {
      SmartDialog.dismiss();
      SmartDialog.showToast(err.toString());
    }
  }
}
