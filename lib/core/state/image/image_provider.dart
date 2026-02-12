import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_nest/core/state/image/image_notifire.dart';

final StateNotifierProvider<ImageNotifire, XFile?> imageProvider =
    StateNotifierProvider.autoDispose<ImageNotifire, XFile?>(
      (ref) => ImageNotifire(ImagePicker()),
    );
