import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageCubit extends Cubit<XFile?> {
  final ImagePicker _picker;

  ProfileImageCubit()
      : _picker = ImagePicker(),
        super(null);

  Future<void> pickImage() async {
    final img = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (img != null) {
      emit(img);
    }
  }

  void clear() {
    emit(null);
  }
}

