import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/image_notifier.dart';

final imageProvider = NotifierProvider.autoDispose<ImageNotifier, XFile?>(
  ImageNotifier.new,
);
