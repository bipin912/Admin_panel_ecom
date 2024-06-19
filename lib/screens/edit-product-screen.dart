import 'dart:io';

import 'package:admin_panel/controllers/edit-product-controller.dart';
import 'package:admin_panel/models/product-model.dart';
import 'package:admin_panel/screens/all-products-screen.dart';
import 'package:admin_panel/utils/app-constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/category-dropdown-controller.dart';
import '../controllers/is-sale-controller.dart';
import '../controllers/product-images-controller.dart';

class EditProductScreen extends StatefulWidget {
  ProductModel productModel;

  EditProductScreen({Key? key, required this.productModel}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
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
  void initState() {
    super.initState();

    productNameController.text = widget.productModel.productName;
    salePriceController.text = widget.productModel.salePrice;
    deliveryTimeController.text = widget.productModel.deliveryTime;
    productDescriptionController.text = widget.productModel.productDescription;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProductController>(
        init: EditProductController(productModel: widget.productModel),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppConstant.appMainColor,
              title: Text(
                'Edit Product ${widget.productModel.productName}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: Get.height / 4,
                        child: GridView.builder(
                            itemCount: controller.images.length,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 10),
                            itemBuilder: (BuildContext context, int index) {
                              final imageUrl = controller.images[index];
                              print('Image URL at index $index: $imageUrl');
                              if (imageUrl[index].isNotEmpty && imageUrl[0].isNotEmpty) {
                                return Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: controller.images[index],
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
                                            await controller
                                                .deleteImagesFromStorage(
                                                    controller.images[index]
                                                        .toString());
                                            await controller
                                                .deleteImagefromFireStore(
                                                    controller.images[index]
                                                        .toString(),
                                                    widget.productModel
                                                        .productId);
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
                                );
                              } else {
                                return Container(
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
                                          return imageController
                                                      .selectedImages.length >
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
                                                              .selectedImages
                                                              .length,
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 2,
                                                              mainAxisSpacing:
                                                                  20,
                                                              crossAxisSpacing:
                                                                  10),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Stack(
                                                          children: [
                                                            Image.file(
                                                              File(addProductImagesController
                                                                  .selectedImages[
                                                                      index]
                                                                  .path),
                                                              fit: BoxFit.cover,
                                                              height:
                                                                  Get.height /
                                                                      4,
                                                              width:
                                                                  Get.width / 2,
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
                                                                  child:
                                                                      CircleAvatar(
                                                                    backgroundColor:
                                                                        AppConstant
                                                                            .appSecondaryColor,
                                                                    child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .white,
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
                              }
                            }),
                      ),
                    ),

                    SizedBox(
                      height: 10.0,
                    ),
                    // drop down
                    GetBuilder<CategoryDropDownController>(
                        init: CategoryDropDownController(),
                        builder: (categoryDropDownController) {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButton<String>(
                                      value: categoryDropDownController
                                          .selectedCategoryId?.value,
                                      items: categoryDropDownController
                                          .categories
                                          .map((category) {
                                        return DropdownMenuItem<String>(
                                            value: category['categoryId'],
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      category['categoryImg']
                                                          .toString()),
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
                                        String? categoryname =
                                            await categoryDropDownController
                                                .getCategoryName(selectedValue);

                                        categoryDropDownController
                                            .setCategoryName(categoryname);
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
                        }),
                    SizedBox(
                      height: 10.0,
                    ),
                    GetBuilder<IssaleController>(
                        init: IssaleController(),
                        builder: (isSaleController) {
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 11.0),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
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

                    GetBuilder<IssaleController>(
                        init: IssaleController(),
                        builder: (issaleController) {
                          return issaleController.isSale.value
                              ? Container(
                                  height: 65,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: TextFormField(
                                    cursorColor: AppConstant.appMainColor,
                                    textInputAction: TextInputAction.next,
                                    controller: salePriceController,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                        hintText: "Sale Price",
                                        hintStyle: TextStyle(fontSize: 12.0),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)))),
                                  ),
                                )
                              : SizedBox.shrink();
                        }),

                    // Obx(() {
                    //   return issaleController.isSale.value
                    //       ? Container(
                    //     height: 65,
                    //     margin: EdgeInsets.symmetric(horizontal: 10.0),
                    //     child: TextFormField(
                    //       cursorColor: AppConstant.appMainColor,
                    //       textInputAction: TextInputAction.next,
                    //       controller: salePriceController
                    //         ..text = productModel.salePrice,
                    //       decoration: InputDecoration(
                    //           contentPadding:
                    //           EdgeInsets.symmetric(horizontal: 10.0),
                    //           hintText: "Sale Price",
                    //           hintStyle: TextStyle(fontSize: 12.0),
                    //           border: OutlineInputBorder(
                    //               borderRadius:
                    //               BorderRadius.all(Radius.circular(10.0)))),
                    //     ),
                    //   )
                    //       : SizedBox.shrink();
                    // }),

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
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
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
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
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
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            hintText: "Product Description",
                            hintStyle: TextStyle(fontSize: 12.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          EasyLoading.show();

                          await addProductImagesController.uploadFunction(
                              addProductImagesController.selectedImages);

                          ProductModel newProductModel = ProductModel(
                              productId: widget.productModel.productId,
                              categoryId: categoryDropDownController
                                  .selectedCategoryId
                                  .toString(),
                              productName: productNameController.text.trim(),
                              categoryName: categoryDropDownController
                                  .selectedCategoryName
                                  .toString(),
                              salePrice: salePriceController.text != ''
                                  ? salePriceController.text.trim()
                                  : '',
                              fullPrice: fullPriceController.text.trim(),
                              productImages:
                                  addProductImagesController.arrImagesUrl,
                              deliveryTime: deliveryTimeController.text.trim(),
                              isSale: issaleController.isSale.value,
                              productDescription:
                                  productDescriptionController.text.trim(),
                              createdAt: widget.productModel.createdAt,
                              updatedAt: DateTime.now());

                          await FirebaseFirestore.instance
                              .collection('products')
                              .doc(widget.productModel.productId)
                              .update(newProductModel.toMap());

                          EasyLoading.dismiss();
                          Navigator.pop(context);
                        },
                        child: Text('Update'))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
