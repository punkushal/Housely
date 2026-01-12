import 'dart:io';

class FileUtils {
  static double getFileSizeInMB(File file) {
    final bytes = file.lengthSync();
    final sizeInMB = bytes / (1024 * 1024);
    return sizeInMB;
  }

  static double getTotalSizeInMB(List<File> files) {
    return files.fold(0, (total, file) => total + getFileSizeInMB(file));
  }
}
