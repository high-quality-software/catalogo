// import 'dart:io';
// // import 'dart:typed_data';
// //import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// // import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
// import 'package:flutter/material.dart';
// // import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

//import 'package:epub_view/epub_view.dart';

// import 'package:flutter_epub/flutter_epub.dart';
// import 'package:flutter_full_pdf_viewer_null_safe/full_pdf_viewer_plugin.dart';
// import 'package:flutter_full_pdf_viewer_null_safe/full_pdf_viewer_scaffold.dart';
// import 'package:flutter_full_pdf_viewer_null_safe/flutter_full_pdf_viewer.dart';

// import 'package:syncfusion_flutter_pdf/pdf.dart' as p;
// import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
// import 'package:flutter_full_pdf_viewer_null_safe/full_pdf_viewer_scaffold.dart';
// import 'package:flutter_full_pdf_viewer_null_safe/flutter_full_pdf_viewer.dart';

// class PdfViewer extends StatefulWidget {
//   const PdfViewer({Key? key, required this.pathPDF, required this.titulo})
//       : super(key: key);

//   final String pathPDF;
//   final String titulo;

//   @override
//   State<PdfViewer> createState() => _PdfViewerState();
// }

// class _PdfViewerState extends State<PdfViewer> {
//   //late EpubController _epubReaderController;

//   late PdfViewerController _pdfViewerController;
//   final GlobalKey<SfPdfViewerState> _pdfViewerStateKey = GlobalKey();
//   //bool _isLoading = true;
//   //late SfPdfViewer _pdfViewer;
//   // late PDFDocument _pdf;
//   // late Uint8List _dataPdf;
//   // void _loadFile() async {
//   //   // Load the pdf file from the internet
//   //   // var f = File(widget.pathPDF);
//   //   // _pdfViewer = SfPdfViewer.file(f);

//   //   // _pdf = await PDFDocument.fromFile(f);

//   //   // setState(() {
//   //   //   _isLoading = false;
//   //   // });
//   // }

//   @override
//   void initState() {
//     _pdfViewerController = PdfViewerController();
//     // var f = File(widget.pathPDF);
//     // _dataPdf = f.readAsBytesSync();
//     super.initState();
//     //_loadFile();
//   }

//   // @override
//   // void initState() {
//   //   _epubReaderController = EpubController(
//   //     document: EpubDocument.openFile(File(widget.pathPDF)),
//   //     // epubCfi:
//   //     //     'epubcfi(/6/26[id4]!/4/2/2[id4]/22)', // book.epub Chapter 3 paragraph 10
//   //     // epubCfi:
//   //     //     'epubcfi(/6/6[chapter-2]!/4/2/1612)', // book_2.epub Chapter 16 paragraph 3
//   //   );
//   //   super.initState();
//   // }

//   @override
//   void dispose() {
//     //_epubReaderController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SfPdfViewer.file(File(widget.pathPDF),
//           controller: _pdfViewerController, key: _pdfViewerStateKey),
//       appBar: AppBar(
//         actions: <Widget>[
//           IconButton(
//               onPressed: () {
//                 _pdfViewerStateKey.currentState!.openBookmarkView();
//               },
//               icon: const Icon(
//                 Icons.bookmark,
//                 color: Colors.white,
//               )),
//           IconButton(
//               onPressed: () {
//                 _pdfViewerController.jumpToPage(5);
//               },
//               icon: const Icon(
//                 Icons.arrow_drop_down_circle,
//                 color: Colors.white,
//               )),
//           IconButton(
//               onPressed: () {
//                 _pdfViewerController.zoomLevel = 1.25;
//               },
//               icon: const Icon(
//                 Icons.zoom_in,
//                 color: Colors.white,
//               ))
//         ],
//       ),
//     );
//     //return SfPdfViewer.memory(_dataPdf);
//     // return Center(
//     //     child: _isLoading
//     //         ? const Center(child: CircularProgressIndicator())
//     //         : _pdfViewer);
//     // return EpubView(
//     //   controller: _epubReaderController,
//     // );
//     // return PDFViewerScaffold(
//     //   path: pathPDF,
//     // );
//     //PdfView(path: pathPDF);
//     // return PDFViewerScaffold(
//     //     appBar: AppBar(
//     //       title: Text(titulo),
//     //       actions: <Widget>[
//     //         IconButton(
//     //           icon: const Icon(Icons.share),
//     //           onPressed: () {},
//     //         ),
//     //       ],
//     //     ),
//     //     path: pathPDF);
//   }
// }
