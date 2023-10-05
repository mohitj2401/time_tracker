import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:time_tracker/helper/datebase.dart';
import 'package:time_tracker/models/category.dart';
import 'package:time_tracker/services/category_service.dart';
import 'package:time_tracker/util/theme.dart';
import 'package:time_tracker/util/toast.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> categories = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  CategoryService service = CategoryService();
  List<DropdownMenuItem> items = [];
  // String selectedType = 'select';
  TextEditingController categoryText = TextEditingController();
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
      showToast('Category Already Exits');
    }
    // categories.insert(0, category);
    categoryText.text = '';
    getCategory();
    setState(() {});
  }

  deleteCategory(int id) {
    try {
      service.deleteTask(id);
      getCategory();
    } catch (e) {
      showToast("Remove Task assoiciated to this category First",
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
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: const Text(
                "Add New Category",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: TextFormField(
                controller: categoryText,
                cursorColor: ThemeProvider.whiteColor,
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
            ElevatedButton(
              onPressed: () {
                // print(categoryText.text);
                if (categoryText.text.isNotEmpty) {
                  saveCategory(categoryText.text);
                } else {
                  showToast('Please Enter Category Name');
                }
              },
              child: const Text('Add'),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: const Text(
                'Category List',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              // width: 100.w,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text((index + 1).toString()),
                            ),
                            Text(categories[index].name!),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                // deleteCategory(categories[index].id!);
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                deleteCategory(categories[index].id!);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
                itemCount: categories.length,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (int value) {
          if (value == 0) {
            Get.toNamed('/');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Report'),
        ],
      ),
    );
  }
}
