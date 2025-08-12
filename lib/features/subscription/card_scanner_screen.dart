// import 'package:flutter/material.dart';
//
// /// This screen hosts the mobile_scanner widget for general purpose scanning.
// class CardScannerScreen extends StatefulWidget {
//   const CardScannerScreen({super.key});
//
//   @override
//   State<CardScannerScreen> createState() => _CardScannerScreenState();
// }
//
// class _CardScannerScreenState extends State<CardScannerScreen> {
//   /// Controller for the scanner to manage torch, camera facing, etc.
//   final MobileScannerController controller = MobileScannerController();
//   bool _isProcessing = false;
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: MobileScanner(
//         controller: controller,
//         // The scanner will stop when a barcode is detected.
//         onDetect: (capture) {
//           // Prevent processing the same code multiple times or after popping
//           if (_isProcessing || !mounted) return;
//
//           final List<Barcode> barcodes = capture.barcodes;
//           if (barcodes.isNotEmpty) {
//             final String? code = barcodes.first.rawValue;
//             if (code != null) {
//               setState(() {
//                 _isProcessing = true;
//               });
//               // Pop the screen and return the raw string value of the scanned code.
//               Navigator.of(context).pop(code);
//             }
//           }
//         },
//       ),
//     );
//   }
// }
