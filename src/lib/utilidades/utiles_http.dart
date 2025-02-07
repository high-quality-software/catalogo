import 'dart:io';
import 'package:ntp/ntp.dart';

import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';

enum DownloadTaskStatus {
  starting,
  downloading,
  done,
  failed,
}

abstract class UtilesHttp {
  static Future<DateTime> getFechaHoraNTP() async {
    try {
      return NTP.now(lookUpAddress: "ar.pool.ntp.org");
    } catch (e) {
      try {
        return NTP.now();
      } catch (e) {
        return DateTime.now();
      }
    }
  }

  static Future<File?> downloadFile(
      {required String url,
      required String filename,
      required String folder}) async {
    // Reset the vars from previous task.
    //int downloaded = 0;

    // var httpClient = http.Client();
    // var request = http.Request('GET', Uri.parse(url));
    // var response = httpClient.send(request);
    // //var status = DownloadTaskStatus.starting;
    // //int percent = 0;
    // File? downloadedFile;
    // // This will only work on Android.
    // // Use path_provider when platform is iOS.
    // Directory directory = Directory(folder);

    // List<List<int>> chunks = <List<int>>[];

    // var result = response.asStream().listen((http.StreamedResponse r) {
    //   r.stream.listen((List<int> chunk) {
    //     // Stream has started emitting
    //     // Download task has began
    //     //status = DownloadTaskStatus.downloading;

    //     // Display percentage of completion
    //     //debugPrint('downloadPercentage: ${downloaded / r.contentLength * 100}');

    //     chunks.add(chunk);
    //     //downloaded += chunk.length;
    //     //percent = (downloaded / (r.contentLength ?? 1) * 100).ceil();

    //     //notifyListeners();
    //   }, onDone: () async {
    //     // Display percentage of completion
    //     //debugPrint('downloadPercentage: ${downloaded / r.contentLength * 100}');
    //     directory.createSync();

    //     // Save the file
    //     File file = File('${directory.path}/$filename');
    //     final Uint8List bytes = Uint8List(r.contentLength ?? 1);
    //     int offset = 0;
    //     for (List<int> chunk in chunks) {
    //       bytes.setRange(offset, offset + chunk.length, chunk);
    //       offset += chunk.length;
    //     }

    //     try {
    //       await file.writeAsBytes(bytes);
    //     } on FileSystemException catch (e) {
    //       //status = DownloadTaskStatus.failed;
    //       //notifyListeners();
    //       if (kDebugMode) {
    //         print(e.message);
    //       }
    //       return;
    //     }

    //     // Set status to done
    //     //status = DownloadTaskStatus.done;
    //     downloadedFile = file;
    //   });
    // });
    // await result.asFuture();

    // return downloadedFile;
    var httpClient = http.Client();
    //var uriUrl = Uri.parse(url);
    var request = http.Request('GET', Uri.parse(url));
    var response = await httpClient.send(request);
    //var request = await httpClient.getUrl(Uri.parse(url));
    //var response = await httpClient.get(uriUrl); //request.close();
    var bytes = await response.stream.toBytes();
    // var bytes =
    //     response.bodyBytes; //await consolidateHttpClientResponseBytes();
    String dir = folder;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  // Future<bool> checkPermission() async {
  //   var status = await Permission.storage.status;

  //   if (status.isPermanentlyDenied || status.isDenied) {
  //     // Don't have permission yet
  //     if (await Permission.storage.shouldShowRequestRationale) {
  //       return await Permission.storage.request().isGranted;
  //     } else {
  //       return await Permission.storage.request().isGranted;
  //     }
  //   } else {
  //     return status.isGranted;
  //   }
  // }
}
