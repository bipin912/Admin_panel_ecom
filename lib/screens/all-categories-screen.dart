import 'package:admin_panel/controllers/edit-category-controller.dart';
import 'package:admin_panel/models/category-model.dart';
import 'package:admin_panel/screens/add-category-screen.dart';
import 'package:admin_panel/screens/edit-category-screen.dart';
import 'package:admin_panel/utils/app-constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('All Categories'),
        actions: [
          InkWell(
            onTap: () => Get.to(() => AddCategoriesScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('categories')
            // .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text('Error occured while fetching Categories!'),
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
              child: const Center(
                child: Text("No category found!"),
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

                CategoriesModel categoriesModel = CategoriesModel(
                    categoryId: data['categoryId'],
                    categoryName: data['categoryName'],
                    categoryImg: data['categoryImg'],
                    createdAt: data['createdAt'],
                    updatedAt: data['updatedAt']);

                return SwipeActionCell(
                    key: ObjectKey(categoriesModel.categoryId),

                    /// this key is necessary
                    trailingActions: <SwipeAction>[
                      SwipeAction(
                          title: "Delete",
                          onTap: (CompletionHandler handler) async {
                            await Get.defaultDialog(
                                title: "Delete Product",
                                content: Text(
                                    "Are you sure you want to delete this product?"),
                                textCancel: "Cancel",
                                textConfirm: "Delete",
                                contentPadding: EdgeInsets.all(10.0),
                                confirmTextColor: Colors.white,
                                onCancel: () {},
                                onConfirm: () async {
                                  Get.back(); //close dialog
                                  EasyLoading.show(status: "Please wait...");
                                  EditCategoryController
                                      editCategoryController =
                                      Get.put(EditCategoryController(
                                          categoriesModel: categoriesModel));
                                  
                                  await editCategoryController.deleteImagesFromStorage(categoriesModel.categoryImg);

                                  await editCategoryController.deleteImagefromFireStore(categoriesModel.categoryImg, categoriesModel.categoryId);

                                  // await deleteImagefromFirebase(
                                  //   productModel.productImages,
                                  // );
                                  await FirebaseFirestore.instance.collection(
                                      'categories')
                                      .doc(categoriesModel.categoryId)
                                      .delete();

                                  EasyLoading.dismiss();
                                },
                                buttonColor: Colors.red,
                                cancelTextColor: Colors.black);
                          },
                          color: Colors.red),
                    ],
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        onTap: () {},
                        leading: CircleAvatar(
                          backgroundColor: AppConstant.appSecondaryColor,
                          backgroundImage: CachedNetworkImageProvider(
                            categoriesModel.categoryImg,
                            errorListener: (e) {
                              // Handle the error here
                              print('Error loading image');
                              Icon(Icons.error);
                            },
                          ),
                        ),
                        title: Text(categoriesModel.categoryName),
                        subtitle: Text(categoriesModel.categoryId),
                        trailing: GestureDetector(
                            onTap: () {
                              Get.to(() => EditCategoryScreen(
                                  categoriesModel: categoriesModel));
                            },
                            child: Icon(Icons.edit)),
                      ),
                    ));
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
