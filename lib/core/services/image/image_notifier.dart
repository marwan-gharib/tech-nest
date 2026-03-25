import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImageNotifier extends AutoDisposeNotifier<XFile?> {
  late final ImagePicker _picker;

  @override
  XFile? build() {
    _picker = ImagePicker();
    return null;
  }

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
