import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';

class FileUploadController {
  //---- upload picked image file to the firebase storage bucket in the given path

  Future<String> uploadFile(File file, String folderPath) async {
    try {
      //----getting the file name from the file path
      final String fileName = basename(file.path);

      ///-----defining the firebae storage destination where the file should be uploaded to
      final String destintaion = "$folderPath/$fileName";

      //----creating te firebase storage referrence with the destintaion file location
      final ref = FirebaseStorage.instance.ref(destintaion);

      ///----uploading the file
      final UploadTask task = ref.putFile(file);

      //---wait untill the task is completed
      final snapshot = await task.whenComplete(() {});

      //---getting the download url of the uploaded file
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      Logger().e(e);

      return "";
    }
  }
}
