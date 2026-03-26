import 'dart:io';
import 'package:dio/dio.dart';

class FileUploadUtils {
  const FileUploadUtils._();

  static Future<MultipartFile> uploadImageToAPI(File image) async {
    return MultipartFile.fromFile(
      image.path,
      filename: image.path.split('/').last,
    );
  }
}
