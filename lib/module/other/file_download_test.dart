import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

const imgUrl =
    "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
var dio = Dio();

class FileDownloadTest extends StatelessWidget {
  const FileDownloadTest({super.key});

  Future<bool> checkIfFileExists(String fileName) async {
    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      final downloadPath = path.join(
        directory.parent.parent.parent.parent.path,
        'Download',
      );
      String fullPath = path.join(downloadPath, fileName);

      // Check if the file exists
      File file = File(fullPath);
      return await file.exists();
    }
    return false;
  }

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      // print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
  // onPressed: () async {
  //                 var tempDir = await getTemporaryDirectory();
  //                 String fullPath = tempDir.path + "/boo2.pdf'";
  //                 print('full path ${fullPath}');

  //                 download2(dio, imgUrl, fullPath);
  //               },
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("File Download"),
      ),
      body: Center(
        child: FutureBuilder<bool>(
          future: checkIfFileExists("boo2.pdf"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            bool fileExists = snapshot.data ?? false;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (fileExists)
                  ElevatedButton(
                    onPressed: () async {
                      Directory? directory =
                          await getExternalStorageDirectory();
                      if (directory != null) {
                        final downloadPath = path.join(
                          directory.parent.parent.parent.parent.path,
                          'Download',
                        );
                        String fullPath = path.join(downloadPath, "boo2.pdf");
                        await OpenFilex.open(fullPath);
                      }
                    },
                    child: const Text('Open Invoice'),
                  ),
                if (!fileExists)
                  ElevatedButton(
                    onPressed: () async {
                      Directory? directory =
                          await getExternalStorageDirectory();
                      if (directory != null) {
                        final downloadPath = path.join(
                          directory.parent.parent.parent.parent.path,
                          'Download',
                        );
                        String fullPath = path.join(downloadPath, "boo2.pdf");
                        await download2(dio, imgUrl, fullPath);
                        await OpenFilex.open(fullPath);
                      }
                    },
                    child: const Text('Download Invoice'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
