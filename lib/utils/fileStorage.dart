
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// To save the file in the device
class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/DCIM");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> writeCounter(String bytes,String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension
    File file= File('$path/$name');;
    print("Save file");

    // Write the data in the file you have created
    return file.writeAsString(bytes);
  }

  Future<void> saveWidgetAsPdf(BuildContext context, Widget widget, String fileName) async {
    final pdf = pw.Document();

    // Convert the widget to an image
    final image = await widgetToImage(context, widget);

    // Add the image to the PDF document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Image(pw.MemoryImage(image));
        },
      ),
    );

    // Save the PDF to the device
    final outputDir = await getExternalStorageDirectory();
    final file = File("${outputDir?.path}/$fileName.pdf");
    await file.writeAsBytes(await pdf.save());

    // Show a toast message indicating the download status
    // Fluttertoast.showToast(
    //   msg: "PDF downloaded!",
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: Colors.green,
    //   textColor: Colors.white,
    // );
  }

  Future<Uint8List> widgetToImage(BuildContext context, Widget widget) async {
    final key = GlobalKey();
    final RenderRepaintBoundary boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}