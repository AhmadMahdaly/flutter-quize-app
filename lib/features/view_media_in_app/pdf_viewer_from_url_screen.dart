import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerFromUrlScreen extends StatefulWidget {
  const PdfViewerFromUrlScreen({super.key, required this.pdfUrl});
  final String pdfUrl;

  @override
  State<PdfViewerFromUrlScreen> createState() => _PdfViewerFromUrlScreenState();
}

class _PdfViewerFromUrlScreenState extends State<PdfViewerFromUrlScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  void initState() {
    blockScreenshot();
    super.initState();
  }

  Future<void> blockScreenshot() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: SizeConfig.responsiveValue(phone: 24.sp, tablet: 24.sp),
          ),
        ),
        title: const Text('PDF Viewer'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.pdfUrl,
        key: _pdfViewerKey,
        onDocumentLoadFailed: (details) {
          // يمكنك التعامل مع أخطاء التحميل هنا
          print('Failed to load PDF: ${details.error}');
          print(details.description);
        },
      ),
    );
  }
}
