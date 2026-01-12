import 'package:flutter/material.dart';

class YearPickerFormField extends FormField<int> {
  YearPickerFormField({
    super.key,
    required BuildContext context,
    super.initialValue,
    int startYear = 1990,
    int? endYear,
    super.validator,
    ValueChanged<int>? onChanged,
    String hintText = 'Select Year',
  }) : super(
         builder: (state) {
           return InkWell(
             onTap: () async {
               final selectedYear = await showDialog<int>(
                 context: context,
                 builder: (_) => _YearPickerDialog(
                   initialYear: state.value,
                   startYear: startYear,
                   endYear: endYear ?? DateTime.now().year,
                 ),
               );

               if (selectedYear != null) {
                 state.didChange(selectedYear);
                 onChanged?.call(selectedYear);
               }
             },
             child: InputDecorator(
               decoration: InputDecoration(
                 hintText: hintText,
                 errorText: state.errorText,
                 border: const OutlineInputBorder(),
               ),
               child: Text(state.value?.toString() ?? ''),
             ),
           );
         },
       );
}

class _YearPickerDialog extends StatelessWidget {
  final int? initialYear;
  final int startYear;
  final int endYear;

  const _YearPickerDialog({
    this.initialYear,
    required this.startYear,
    required this.endYear,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 300,
        child: YearPicker(
          firstDate: DateTime(startYear),
          lastDate: DateTime(endYear),
          selectedDate: DateTime(initialYear ?? DateTime.now().year),
          onChanged: (date) {
            Navigator.pop(context, date.year);
          },
        ),
      ),
    );
  }
}
