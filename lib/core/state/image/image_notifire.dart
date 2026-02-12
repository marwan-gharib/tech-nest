import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

class ImageNotifire extends StateNotifier<XFile?> {
  final ImagePicker _picker;

  ImageNotifire(this._picker) : super(null);

  Future<void> pickImage() async {
    final img = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (img != null) {
      state = img;
    }
  }

  void clear() {
    state = null;
  }
}
