import 'dart:io';

import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageUtilities {
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();
  final _cropper = ImageCropper();
  Future<File?> getImage({required bool gallery}) async {
    bool permission = await _requestPermission();

    if (permission) {
      XFile? image = await _picker.pickImage(
          source: gallery ? ImageSource.gallery : ImageSource.camera,
          imageQuality: 40);
      if (image != null) {
        File? croppedFile = await _cropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Edit Image',
            toolbarColor: AppTheme.creamBrown,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          iosUiSettings: const IOSUiSettings(),
        );
        if (croppedFile != null) {
          printIt(croppedFile.path);
          return croppedFile;
        } else {
          return null;
        }
      } else {
        showToast('invalid file');
        printIt('selected image is null');
      }
    } else {
      // showToast("Don't have permission to access photos");
      printIt("don't have image permission");
    }
    return null;
  }

  Future<String?> uploadImage(
      String address, File file, BuildContext context) async {
    try {
      showToast(AppLocalizations.of(context)?.uploading ?? "uploading");
      TaskSnapshot snapshot =
          await _storage.ref(address).child(const Uuid().v1()).putFile(file);
      // showToast("uploading ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%");
      String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }

  Future deleteImage(imageAddress) async {
    if (imageAddress == null) return null;

    try {
      await _storage.refFromURL(imageAddress).delete();
      return imageAddress;
    } catch (e) {
      
      printIt(e);

      return null;
    }
  }

  Future<bool> _requestPermission() async {
    PermissionStatus cameraPermission = await Permission.camera.request();
    PermissionStatus photoPermission = await Permission.photos.request();
    return ((cameraPermission.isGranted || cameraPermission.isLimited) &&
        (photoPermission.isGranted || photoPermission.isLimited));
  }
}
