import 'dart:io';

import 'package:admin_panel/models/category-model.dart';
import 'package:admin_panel/utils/app-constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Services/generate-ids-service.dart';
import '../controllers/product-images-controller.dart';

class AddCategoriesScreen extends StatefulWidget {
  AddCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoriesScreen> createState() => _AddCategoriesScreenState();
}

class _AddCategoriesScreenState extends State<AddCategoriesScreen> {
  TextEditingController categoryNameController = TextEditingController();
  AddProductImagesController addProductImagesController =
  Get.put(AddProductImagesController());



  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text("Add Categories"),
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select Images'),
                    ElevatedButton(
                        onPressed: () {
                          addProductImagesController.showImagePickerDialog();
                        },
                        child: Text('Select Images'))
                  ],
                ),
              ),

              GetBuilder<AddProductImagesController>(
                  init: AddProductImagesController(),
                  builder: (imageController) {
                    return imageController.selectedImages.length > 0
                        ? Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 20,
                      height: Get.height / 2.5,
                      child: GridView.builder(
                          itemCount: addProductImagesController
                              .selectedImages.length,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 10),
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              children: [
                                Image.file(
                                  File(addProductImagesController
                                      .selectedImages[index].path),
                                  fit: BoxFit.cover,
                                  height: Get.height / 4,
                                  width: Get.width / 2,
                                ),
                                Positioned(
                                    right: 10,
                                    top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        imageController
                                            .removeImages(index);
                                        print(imageController
                                            .selectedImages.length);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor:
                                        AppConstant.appSecondaryColor,
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ))
                              ],
                            );
                          }),
                    )
                        : SizedBox.shrink();
                  }),

              SizedBox(
                height: 10.0,
              ),

              //form widget
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  controller: categoryNameController,
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,

                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintText: "Category Name",
                      hintStyle: TextStyle(fontSize: 12.0),
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),


              ElevatedButton(onPressed: () async {

                EasyLoading.show();
                await addProductImagesController.uploadFunction(
                    addProductImagesController.selectedImages);
                String categoryId = await GenerateIds()
                    .generateCategoryId();

                CategoriesModel categoriesModel = CategoriesModel(
                    categoryId: categoryId,
                    categoryName: categoryNameController.text.trim(),
                    categoryImg: addProductImagesController.arrImagesUrl[0].toString(),
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now());
                print(categoryId);

                FirebaseFirestore.instance.collection('categories').doc(categoryId).set(categoriesModel.toJson());
                EasyLoading.dismiss();
                Navigator.pop(context);

              }, child: Text('Save'))


            ],
          ),
        ),
      ),
    );
  }
}
