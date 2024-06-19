import 'dart:io';

import 'package:admin_panel/Services/generate-ids-service.dart';
import 'package:admin_panel/controllers/category-dropdown-controller.dart';
import 'package:admin_panel/controllers/is-sale-controller.dart';
import 'package:admin_panel/controllers/product-images-controller.dart';
import 'package:admin_panel/models/product-model.dart';
import 'package:admin_panel/utils/app-constant.dart';
import 'package:admin_panel/widgets/drop-down-categories-widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AddProductsScreen extends StatelessWidget {
  AddProductsScreen({Key? key}) : super(key: key);

  AddProductImagesController addProductImagesController =
  Get.put(AddProductImagesController());

  CategoryDropDownController categoryDropDownController =
  Get.put(CategoryDropDownController());

  IssaleController issaleController = Get.put(IssaleController());

  TextEditingController productNameController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Add Products',
          style: TextStyle(color: Colors.white),
        ),
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
              //show Images
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
              //show categories drop down
              DropDownCategoriesWidget(),

              SizedBox(
                height: 20.0,
              ),

              //isSale
              GetBuilder<IssaleController>(
                  init: IssaleController(),
                  builder: (isSaleController) {
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 11.0),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Is Sale'),
                            Switch(
                                value: isSaleController.isSale.value,
                                activeColor: AppConstant.appMainColor,
                                onChanged: (value) {
                                  isSaleController.toggleIsSale(value);
                                })
                          ],
                        ),
                      ),
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
                  controller: productNameController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintText: "Product Name",
                      hintStyle: TextStyle(fontSize: 12.0),
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),

              Obx(() {
                return issaleController.isSale.value
                    ? Container(
                  height: 65,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    cursorColor: AppConstant.appMainColor,
                    textInputAction: TextInputAction.next,
                    controller: salePriceController,
                    decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0),
                        hintText: "Sale Price",
                        hintStyle: TextStyle(fontSize: 12.0),
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)))),
                  ),
                )
                    : SizedBox.shrink();
              }),

              //form widget

              SizedBox(
                height: 10.0,
              ),

              //form widget
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: fullPriceController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintText: "Full Price",
                      hintStyle: TextStyle(fontSize: 12.0),
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),

              //form widget
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: deliveryTimeController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintText: "Delivery  Time",
                      hintStyle: TextStyle(fontSize: 12.0),
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),

              //form widget
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: productDescriptionController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintText: "Product Description",
                      hintStyle: TextStyle(fontSize: 12.0),
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    // String productId =  await GenerateIds().generateProductId();
                    // print(productId);

                    try {
                      EasyLoading.show();
                      await addProductImagesController.uploadFunction(
                          addProductImagesController.selectedImages);
                      print(addProductImagesController.arrImagesUrl);

                      String productId = await GenerateIds()
                          .generateProductId();

                      ProductModel productModel = ProductModel(
                          productId: productId,
                          categoryId: categoryDropDownController
                              .selectedCategoryId.toString(),
                          productName: productNameController.text.trim(),
                          categoryName: categoryDropDownController
                              .selectedCategoryName.toString(),
                          salePrice: salePriceController.text != ''
                              ? salePriceController.text.trim()
                              : '',
                          fullPrice: fullPriceController.text.trim(),
                          productImages: addProductImagesController.arrImagesUrl,
                          deliveryTime: deliveryTimeController.text.trim(),
                          isSale: issaleController.isSale.value,
                          productDescription: productDescriptionController.text.trim(),
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now()
                      );

                      await FirebaseFirestore.instance.collection('products').doc(productId).set(productModel.toMap());

                      EasyLoading.dismiss();
                      Navigator.pop(context);
                    } catch (e) {
                      print("error $e");
                    }
                  },
                  child: Text("Upload"))
            ],
          ),
        ),
      ),
    );
  }
}
