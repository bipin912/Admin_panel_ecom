import 'package:admin_panel/controllers/category-dropdown-controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class DropDownCategoriesWidget extends StatelessWidget {
  const DropDownCategoriesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryDropDownController>(
        init: CategoryDropDownController(),
        builder: (categoryDropDownController) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Card(

                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value:
                          categoryDropDownController.selectedCategoryId?.value,
                      items:
                          categoryDropDownController.categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category['categoryId'],
                            child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  category['categoryImg'].toString()),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(category['categoryName'])
                          ],
                        ));
                      }).toList(),
                      onChanged: (String? selectedValue) async {
                        categoryDropDownController
                            .setSelectedCategory(selectedValue);
                        String? categoryname = await categoryDropDownController
                            .getCategoryName(selectedValue);

                        categoryDropDownController.setCategoryName(categoryname);

                      },
                      hint: Text('Select a category'),
                      isExpanded: true,
                      elevation: 10,
                      underline: SizedBox.shrink(),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }
}
