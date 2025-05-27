import 'package:flutter/cupertino.dart';

class AppSpacer extends StatelessWidget {
  final double? width,height;
  const AppSpacer({super.key,  this.width=0,  this.height=0});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: height,
      width: width,
    );
  }
}