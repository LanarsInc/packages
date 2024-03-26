import 'dart:io';
import 'package:exif/exif.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker_example/logger/logger/pretty_socket_logger.dart';

Future<void> printExifData(File originalFile) async {
  final logger = PrettySocketLogger();

  final imageBytes = await originalFile.readAsBytes();

  print(originalFile.path);

  final originalImage = img.decodeImage(imageBytes);
  if (originalImage == null) {
    return;
  }

  // We'll use the exif package to read exif data
  // This is map of several exif properties
  // Let's check 'Image Orientation'
  final exifData = await readExifFromBytes(imageBytes);
  print('\n*********************************************');
  logger.printPrettyMap(exifData);
  print('*********************************************\n');

  print('orientation: ${exifData['Image Orientation']}');
  print('orientation values: ${exifData['Image Orientation']?.values}');


}
