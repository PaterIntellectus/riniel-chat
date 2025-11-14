import 'package:cross_file/cross_file.dart';
import 'package:flutter/widgets.dart';

class FileController extends ValueNotifier<XFile?> {
  FileController([super.file]);

  void drop() => value = null;
}
