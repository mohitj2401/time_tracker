import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:time_tracker/helper/datebase.dart';
import 'package:time_tracker/models/category.dart';
import 'package:time_tracker/services/category_service.dart';
import 'package:time_tracker/util/toast.dart';
import 'package:time_tracker/widgets/category_bottom_sheet.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool isEdit = false;
  List<Category> categories = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  CategoryService service = CategoryService();
  List<DropdownMenuItem> items = [];
  int selectedCategory = -1;
  // String selectedType = 'select';
  TextEditingController categoryText = TextEditingController();

  ScrollController controller = ScrollController();

  saveCategory(String value) {
    Category category = Category(
      name: value,
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
    );

    int index = categories.indexWhere((element) => element.name == value);
    if (index == -1) {
      service.insertTask(category);
    } else {
      toast('Category Already Exits', context);
    }
    // categories.insert(0, category);
    categoryText.text = '';
    getCategory();
    setState(() {});
  }

  deleteCategory(int id, BuildContext context) {
    try {
      service.deleteTask(id, context);
      getCategory();
    } catch (e) {
      toast("Remove Task assoiciated to this category First", context,
          isError: true);
    }
    // categories.removeWhere((element) => element.id == id);
  }

  getCategory() async {
    categories = await service.getAllCategory();
    setState(() {});
  }

  @override
  void initState() {
    getCategory();
    // TODO: implement initState
    super.initState();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       // backgroundColor: ThemeProvider.appColor,
  //       automaticallyImplyLeading: false,
  //       elevation: 0.0,
  //       title: const Text(
  //         'Categories',
  //         // style: ThemeProvider.titleStyle,
  //       ),
  //     ),
  //     body: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
  //       width: 100.w,
  //       height: 100.h,
  //       child: Column(
  //         // mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Container(
  //             child: Text(
  //               isEdit ? "Edit Category" : "Add New Category",
  //               style: TextStyle(fontSize: 18),
  //             ),
  //           ),
  //           const SizedBox(
  //             height: 10,
  //           ),
  //           Container(
  //             child: TextFormField(
  //               controller: categoryText,
  //               style: const TextStyle(fontSize: 16),
  //               decoration: const InputDecoration(
  //                 // contentPadding: EdgeInsets.zero,
  //                 hintText: 'Category Name',
  //                 border: OutlineInputBorder(),
  //                 hintStyle: TextStyle(fontSize: 16),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(
  //             height: 10,
  //           ),
  //           Row(
  //             children: [
  //               ElevatedButton(
  //                 onPressed: () {
  //                   if (isEdit) {
  //                     if (categoryText.text.isNotEmpty &&
  //                         categoryText.text != '' &&
  //                         !categoryText.text.isBlank! &&
  //                         selectedCategory > -1) {
  //                       categories[selectedCategory].name = categoryText.text;
  //                       service.updateCategory(categories[selectedCategory]);
  //                       categoryText.text = '';
  //                       isEdit = false;
  //                       print(categories[selectedCategory].toString());
  //                       setState(() {});
  //                     } else {
  //                       toast('Category Name Cannot be Empty');
  //                     }
  //                   } else {
  //                     // print(categoryText.text);
  //                     if (categoryText.text.isNotEmpty &&
  //                         categoryText.text != '' &&
  //                         !categoryText.text.isBlank!) {
  //                       saveCategory(categoryText.text);
  //                     } else {
  //                       toast('Please Enter Category Name');
  //                     }
  //                   }
  //                 },
  //                 child: isEdit ? const Text("Edit") : const Text('Add'),
  //               ),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               if (isEdit)
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     // print(categoryText.text);
  //                     setState(() {
  //                       isEdit = false;
  //                       categoryText.text = '';
  //                     });
  //                   },
  //                   child: isEdit ? const Text("Back") : const Text('Add'),
  //                 ),
  //             ],
  //           ),
  //           const SizedBox(
  //             height: 10,
  //           ),
  //           Container(
  //             child: const Text(
  //               'Category List',
  //               style: TextStyle(fontSize: 18),
  //             ),
  //           ),
  //           const SizedBox(
  //             height: 10,
  //           ),
  //           Expanded(
  //             // width: 100.w,
  //             child: ListView.builder(
  //               controller: controller,
  //               itemBuilder: (context, index) {
  //                 return Container(
  //                   padding: (index + 1) == categories.length
  //                       ? EdgeInsets.only(bottom: 25)
  //                       : null,
  //                   child: Card(
  //                     elevation: 2,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Padding(
  //                               padding:
  //                                   const EdgeInsets.symmetric(horizontal: 20),
  //                             ),
  //                             Text(
  //                               categories[index].name!,
  //                               style: Theme.of(context).textTheme.bodyLarge,
  //                             ),
  //                           ],
  //                         ),
  //                         Row(
  //                           children: [
  //                             IconButton(
  //                               onPressed: () {
  //                                 isEdit = true;
  //                                 selectedCategory = index;
  //                                 categoryText.text = categories[index].name!;
  //                                 setState(() {});
  //                                 // deleteCategory(categories[index].id!);
  //                               },
  //                               icon: const Icon(Icons.edit),
  //                             ),
  //                             IconButton(
  //                               onPressed: () {
  //                                 deleteCategory(categories[index].id!);
  //                               },
  //                               icon: const Icon(Icons.delete),
  //                             ),
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               },
  //               itemCount: categories.length,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     bottomNavigationBar: BottomNavigationBar(
  //       backgroundColor: Colors.transparent,
  //       currentIndex: 1,
  //       onTap: (int value) {
  //         if (value == 0) {
  //           context.go('/');
  //         }
  //         if (value == 2) {
  //           context.go('/report');
  //         }
  //       },
  //       items: const [
  //         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
  //         BottomNavigationBarItem(
  //             icon: Icon(Icons.category), label: 'Category'),
  //         BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Report'),
  //       ],
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       mini: true,
  //       tooltip: 'Move to End',
  //       onPressed: () {
  //         controller.animateTo(99999,
  //             duration: Duration(milliseconds: 100), curve: Curves.linear);
  //       },
  //       child: Icon(
  //         Icons.keyboard_arrow_down,
  //         // size: 50,
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: ThemeProvider.appColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: const Text(
          'Categories',
          // style: ThemeProvider.titleStyle,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        width: 100.w,
        height: 100.h,
        child: ListView.builder(
          // controller: controller,
          itemBuilder: (context, index) {
            return Container(
              padding: (index + 1) == categories.length
                  ? EdgeInsets.only(bottom: 25)
                  : null,
              child: Card(
                elevation: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        Text(
                          categories[index].name!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            categoryText.text = '';

                            getCategoryBottonSheet(
                                context, categories[index], categoryText, () {
                              if (categoryText.text.isNotEmpty &&
                                  categoryText.text != '' &&
                                  !categoryText.text.isEmpty) {
                                CategoryService service = CategoryService();
                                categories[index].name = categoryText.text;
                                service.updateCategory(categories[index]);
                                setState(() {});
                                Navigator.pop(context);
                              } else {
                                toast('Please Enter Category Name', context);
                              }
                            });
                            // deleteCategory(categories[index].id!);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteCategory(categories[index].id!, context);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: categories.length,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: 1,
        onTap: (int value) {
          if (value == 0) {
            context.go('/');
          }
          if (value == 2) {
            context.go('/report');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Report'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        tooltip: 'Add',
        onPressed: () {
          categoryText.text = '';
          getCategoryBottonSheet(context, null, categoryText, () {
            if (categoryText.text.isNotEmpty &&
                categoryText.text != '' &&
                !categoryText.text.isEmpty) {
              saveCategory(categoryText.text);
              Navigator.pop(context);
            } else {
              toast('Please Enter Category Name', context);
            }
          });
        },
        child: Icon(
          Icons.add,
          // size: 50,
        ),
      ),
    );
  }
}
