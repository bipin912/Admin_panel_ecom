import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetProductsLengthController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
  _productsControllerSubscription;

  final Rx<int> productsCollectionLength = Rx<int>(0);

  @override
  void onInit() {
    super.onInit();
    _productsControllerSubscription = _firestore
        .collection('products')

        .snapshots()
        .listen((snapshot) {
      productsCollectionLength.value = snapshot.size;

    });
  }

  @override
  void onClose() {
    _productsControllerSubscription.cancel();
    super.onClose();
  }
}