// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:smle/core/functions/responsive_config.dart';
// import 'package:smle/core/helpers/extensions.dart';
// import 'package:smle/core/shared_widgets/debug_print_widget.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// class PdfViewerFromUrlScreen extends StatefulWidget {
//   const PdfViewerFromUrlScreen({super.key, required this.pdfUrl});
//   final String pdfUrl;

//   @override
//   State<PdfViewerFromUrlScreen> createState() => _PdfViewerFromUrlScreenState();
// }

// class _PdfViewerFromUrlScreenState extends State<PdfViewerFromUrlScreen> {
//   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
//   @override
//   void initState() {
//     blockScreenshot();
//     super.initState();
//   }

//   static const platform = MethodChannel('secure_screen');

//   Future<void> blockScreenshot() async {
//     try {
//       await platform.invokeMethod('secure');
//     } on PlatformException catch (e) {
//       debugPrintWidget("Failed to secure screen: '${e.message}'.");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () => context.pop(),
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             size: SizeConfig.responsiveValue(phone: 24.sp, tablet: 24.sp),
//           ),
//         ),
//         title: const Text('PDF Viewer'),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(
//               Icons.bookmark,
//               color: Colors.white,
//               semanticLabel: 'Bookmark',
//             ),
//             onPressed: () {
//               _pdfViewerKey.currentState?.openBookmarkView();
//             },
//           ),
//         ],
//       ),
//       body: SfPdfViewer.network(
//         widget.pdfUrl,
//         key: _pdfViewerKey,
//         onDocumentLoadFailed: (details) {
//           // يمكنك التعامل مع أخطاء التحميل هنا
//           debugPrintWidget('Failed to load PDF: ${details.error}');
//           debugPrintWidget(details.description);
//         },
//       ),
//     );
//   }
// }
