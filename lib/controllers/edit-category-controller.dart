import 'dart:ffi';

import 'package:admin_panel/models/category-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../models/product-model.dart';

class EditCategoryController extends GetxController {
  CategoriesModel categoriesModel;

  EditCategoryController({required this.categoriesModel});

  Rx<String> categoryImg = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getRealTimeCategoryImg();
  }

  void getRealTimeCategoryImg() {
    FirebaseFirestore.instance
        .collection('categories')
        .doc(categoriesModel.categoryId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && data['categoryImg'] != null) {
          categoryImg.value = data['categoryImg'].toString();
          print(categoryImg);
          update();
        }
      }
    });
  }

  //delete images

  Future deleteImagesFromStorage(String imageUrl) async {
    final FirebaseStorage storage = FirebaseStorage.instance;

    try {
      Reference reference = storage.refFromURL(imageUrl);
      await reference.delete();
    } catch (e) {
      print('error $e');
    }
  }

//collection

  Future<void> deleteImagefromFireStore(
      String imageUrl, String categoryId) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .update({'categoryImg': ''});
      update();
    } catch (e) {
      print('error $e');
    }
  }
}
