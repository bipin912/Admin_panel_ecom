import 'dart:io';

import 'package:admin_panel/models/category-model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../controllers/edit-category-controller.dart';
import '../controllers/product-images-controller.dart';
import '../utils/app-constant.dart';

class EditCategoryScreen extends StatefulWidget {
  CategoriesModel categoriesModel;

  EditCategoryScreen({Key? key, required this.categoriesModel})
      : super(key: key);

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  AddProductImagesController addProductImagesController =
      Get.put(AddProductImagesController());
  TextEditingController categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    categoryNameController.text = widget.categoriesModel.categoryName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(widget.categoriesModel.categoryName),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              GetBuilder(
                  init: EditCategoryController(
                      categoriesModel: widget.categoriesModel),
                  builder: (editCategory) {
                    return editCategory.categoryImg.value != ''
                        ? Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    editCategory.categoryImg.value.toString(),
                                fit: BoxFit.contain,
                                height: Get.height / 5.5,
                                width: Get.width / 2,
                                placeholder: (context, url) => Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              Positioned(
                                  right: 10,
                                  top: 0,
                                  child: InkWell(
                                    onTap: () async {
                                      EasyLoading.show();
                                      await editCategory.deleteImagesFromStorage(
                                          editCategory.categoryImg.value
                                              .toString());
                                      await editCategory.deleteImagefromFireStore(
                                          editCategory.categoryImg.value
                                              .toString(),
                                          widget.categoriesModel.categoryId);
                                      EasyLoading.dismiss();
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
                          )
                        : Container(
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Select Images'),
                                    ElevatedButton(
                                        onPressed: () {
                                          addProductImagesController
                                              .showImagePickerDialog();
                                        },
                                        child: Text('Select Images'))
                                  ],
                                ),
                              ),
                              GetBuilder<AddProductImagesController>(
                                  init: AddProductImagesController(),
                                  builder: (imageController) {
                                    return imageController.selectedImages.length >
                                            0
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                20,
                                            height: Get.height / 2.5,
                                            child: GridView.builder(
                                                itemCount:
                                                    addProductImagesController
                                                        .selectedImages.length,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        mainAxisSpacing: 20,
                                                        crossAxisSpacing: 10),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Stack(
                                                    children: [
                                                      Image.file(
                                                        File(
                                                            addProductImagesController
                                                                .selectedImages[
                                                                    index]
                                                                .path),
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
                                                                  .removeImages(
                                                                      index);
                                                              print(imageController
                                                                  .selectedImages
                                                                  .length);
                                                            },
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  AppConstant
                                                                      .appSecondaryColor,
                                                              child: Icon(
                                                                Icons.close,
                                                                color:
                                                                    Colors.white,
                                                              ),
                                                            ),
                                                          ))
                                                    ],
                                                  );
                                                }),
                                          )
                                        : SizedBox.shrink();
                                  })
                            ]),
                          );
                  }),

              SizedBox(
                height: 20.0,
              ),

              //form widget
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: categoryNameController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintText: "Product Name",
                      hintStyle: TextStyle(fontSize: 12.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),

              ElevatedButton(
                  onPressed: () async {
                    EasyLoading.show();

                    await addProductImagesController.uploadFunction(addProductImagesController.selectedImages);

                    CategoriesModel categoriesModel = CategoriesModel(
                        categoryId: widget.categoriesModel.categoryId,
                        categoryName: categoryNameController.text.trim(),
                        categoryImg: addProductImagesController.arrImagesUrl[0].toString(),
                        createdAt: widget.categoriesModel.createdAt,
                        updatedAt: DateTime.now());

                    await FirebaseFirestore.instance
                        .collection('categories')
                        .doc(categoriesModel.categoryId)
                        .update(categoriesModel.toJson());
                    EasyLoading.dismiss();
                    Navigator.pop(context);
                  },
                  child: Text('Update'))
            ],
          ),
        ),
      ),
    );
  }
}
