import 'package:flutter/material.dart';

class StartQuizModel {
  StartQuizModel({
    this.context,
    this.offset,
    this.pickedDate,
    this.selectedSubCategoryId,
  });
  BuildContext? context;
  int? offset;
  DateTime? pickedDate;
  List<int>? selectedSubCategoryId;
}
