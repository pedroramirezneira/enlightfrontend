import 'package:enlight/components/subject_menu.dart';
import 'package:enlight/models/day_data.dart';
import 'package:enlight/models/subject_data.dart';
import 'package:enlight/services/teacher_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showSubjectMenu({
  required BuildContext context,
}) {
  final teacherService = Provider.of<TeacherService>(context, listen: false);
  showModalBottomSheet<SubjectData>(
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    builder: (context) => SubjectMenu(
      categories: teacherService.data.categories,
      onPressed: _submit,
    ),
  );
}

void _submit({
  required BuildContext context,
  required String categoryName,
  required String name,
  required String description,
  required int price,
  required int group,
  required String modality,
  required List<DayData> days,
}) {
  final data = SubjectData(
    id: -1,
    categoryName: categoryName,
    name: name,
    description: description,
    price: price,
    days: days,
  );
  final teacherService = Provider.of<TeacherService>(context, listen: false);
  teacherService
      .createSubject(
    context: context,
    data: data,
    modality: modality,
    size: group,
  )
      .then((response) {
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
    }
  });
}
