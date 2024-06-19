import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CategoryDropDownController extends GetxController {
  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  RxString? selectedCategoryId;
  RxString? selectedCategoryName;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      List<Map<String, dynamic>> categoriesList = [];
      querySnapshot.docs
          .forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        categoriesList.add({
          'categoryId': document.id,
          'categoryName': document['categoryName'],
          'categoryImg': document['categoryImg'],
        });
      });
      categories.value = categoriesList;
      update();
    } catch (e) {
      print("Error $e");
    }
  }

  //set selected Category

  void setSelectedCategory(String? categoryId) {
    selectedCategoryId = categoryId?.obs;
    print("Selected Category id $selectedCategoryId");
    update();
  }

//fetch category name
  Future<String?> getCategoryName(String? categoryId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('categories')
          .doc(categoryId)
          .get();

      if (snapshot.exists) {
        return snapshot.data()?['categoryName'];
      }
    } catch (e) {
      print('Error $e');
      return null;
    }
  }
//set categoryName
  void setCategoryName(String? categoryName) {
    selectedCategoryName = categoryName?.obs;
    print("Selected Category name $selectedCategoryName");
    update();
  }
//set old value
  void setOldValue(String? categoryId) {
    selectedCategoryId = categoryId?.obs;
    print("Selected Category Id $selectedCategoryId");
    update();
  }
}
