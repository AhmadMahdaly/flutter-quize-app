import 'package:flutter/cupertino.dart';

class StartQuizModel {
  BuildContext? context;
  int? offset;
  DateTime? pickedDate;
  List<int>? selectedSubCategoryId;

  StartQuizModel({this.context,this.offset, this.pickedDate, this.selectedSubCategoryId});

}