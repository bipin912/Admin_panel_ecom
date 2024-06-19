import 'dart:isolate';

import 'package:admin_panel/controllers/category-dropdown-controller.dart';
import 'package:admin_panel/controllers/get-all-products-length-controller.dart';
import 'package:admin_panel/controllers/get-all-user-length-controller.dart';
import 'package:admin_panel/controllers/is-sale-controller.dart';
import 'package:admin_panel/models/product-model.dart';
import 'package:admin_panel/models/user-model.dart';
import 'package:admin_panel/screens/edit-product-screen.dart';
import 'package:admin_panel/screens/product-detail-screen.dart';
import 'package:admin_panel/utils/app-constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'add-products-screen.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final GetProductsLengthController _getProductsLengthController =
  Get.put(GetProductsLengthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => AddProductsScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add),
            ),
          )
        ],
        iconTheme: IconThemeData(color: Colors.white),
        title: Obx(() {
          return Text(
            'All Products (${_getProductsLengthController
                .productsCollectionLength.toString()})',
            style: TextStyle(color: Colors.white),);
        }),
        backgroundColor: AppConstant.appMainColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text('Error occured while fetching products!'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Container(
              child: Center(
                child: Text("No products found!"),
              ),
            );
          }

          if (snapshot.data != null) {
            return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                ProductModel productModel = ProductModel(
                    productId: data['productId'],
                    categoryId: data['categoryId'],
                    productName: data['productName'],
                    categoryName: data['categoryName'],
                    salePrice: data['salePrice'],
                    fullPrice: data['fullPrice'],
                    productImages: data['productImages'],
                    deliveryTime: data['deliveryTime'],
                    isSale: data['isSale'],
                    productDescription: data['productDescription'],
                    createdAt: ['datacreatedAt'],
                    updatedAt: data['updatedAt']);
                return

                  SwipeActionCell(
                      key: ObjectKey(productModel.productId),

                      /// this key is necessary
                      trailingActions: <SwipeAction>[
                        SwipeAction(
                            title: "Delete",
                            onTap: (CompletionHandler handler) async {
                              await Get.defaultDialog(
                                  title: "Delete Product",
                                  content: Text(
                                      "Are you sure you want to delete this product?"
                                  ),
                                  textCancel: "Cancel",
                                  textConfirm: "Delete",
                                  contentPadding: EdgeInsets.all(10.0),
                                  confirmTextColor: Colors.white,
                                  onCancel: () {},
                                  onConfirm: () async {
                                    Get.back(); //close dialog
                                    EasyLoading.show(status: "Please wait...");

                                    await deleteImagefromFirebase(
                                      productModel.productImages,
                                    );
                                    await FirebaseFirestore.instance.collection(
                                        'products')
                                        .doc(productModel.productId)
                                        .delete();

                                    EasyLoading.dismiss();
                                  },
                                buttonColor: Colors.red,
                                cancelTextColor: Colors.black
                              );
                            },
                            color: Colors.red),
                      ],
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          onTap: () =>
                              Get.to(
                                      () => SingleProductDetailScreen(
                                      productModel: productModel)
                              ),
                          leading: CircleAvatar(
                            backgroundColor: AppConstant.appSecondaryColor,
                            child: (productModel.productImages.isNotEmpty && productModel.productImages[0].isNotEmpty)
                                ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: productModel.productImages[0],
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            )
                                : Text(
                              productModel.productName.isNotEmpty ? productModel.productName[0] : '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                              ),
                            ),
                          ),






                          title: Text(productModel.productName),
                          subtitle: productModel.isSale != true
                              ? Text('Full Price: Rs.' + productModel.fullPrice)
                              : Text('Sale Price: Rs.' + productModel
                              .salePrice),
                          trailing: GestureDetector(
                              onTap: () {
                                final editProductCategory = Get.put(
                                    CategoryDropDownController());
                                editProductCategory.setOldValue(
                                    productModel.categoryId);

                                final issaleController = Get.put(
                                    IssaleController());
                                issaleController.setIsSaleOldValue(
                                    productModel.isSale);

                                Get.to(() =>
                                    EditProductScreen(
                                      productModel: productModel,
                                    ));
                              },
                              child: Icon(Icons.edit)),
                        ),
                      )
                  );
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  Future deleteImagefromFirebase(List imageUrls) async{
    final FirebaseStorage storage = FirebaseStorage.instance;

    for(String imageUrl in imageUrls){
      try{


        Reference reference = storage.refFromURL(imageUrl);

        await reference.delete();
      } catch(e){
        print('$e');
      }
    }
  }
}
