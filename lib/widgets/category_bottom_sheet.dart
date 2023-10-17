import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:time_tracker/models/category.dart';

getCategoryBottonSheet(
  BuildContext context,
  Category? category,
  TextEditingController controller,
  VoidCallback onPressed,
) {
  if (category != null) {
    controller.text = category.name!;
  }
  return showModalBottomSheet<void>(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          height: 300,
          child: SingleChildScrollView(child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          category != null ? "Edit Category" : "Add Category",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: onPressed,
                        child: Text(category != null ? "Edit" : 'Save'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  Container(
                    child: TextFormField(
                      controller: controller,
                      // cursorColor: ThemeProvider.whiteColor,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        // contentPadding: EdgeInsets.zero,
                        hintText: 'Category Name',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            },
          )),
        ),
      );
    },
  );
}
