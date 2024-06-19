import 'package:admin_panel/models/order-model.dart';
import 'package:admin_panel/utils/app-constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'check-single-order-screen.dart';

class SpecificCustomerOrderScreen extends StatelessWidget {
  String docId;
  String customerName;

  SpecificCustomerOrderScreen(
      {Key? key, required this.docId, required this.customerName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(customerName),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('orders')
            .doc(docId)
            .collection('confirmOrders')
            .orderBy('createdAt', descending: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text('Error occured while fetching orders!'),
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
                child: Text("No orders found!"),
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
                String orderDocId = data.id;

                OrderModel orderModel = OrderModel(
                    categoryId: data['categoryId'],
                    categoryName: data['categoryName'],
                    createdAt: data['createdAt'],
                    customerAddress: data['customerAddress'],
                    customerDeviceToken: data['customerDeviceToken'],
                    customerId: data['customerId'],
                    customerName: data['customerName'],
                    customerPhone: data['customerPhone'],
                    deliveryTime: data['deliveryTime'],
                    fullPrice: data['fullPrice'],
                    isSale: data['isSale'],
                    productDescription: data['productDescription'],
                    productId: data['productId'],
                    productImages: data['productImages'],
                    productName: data['productName'],
                    productQuantity: data['productQuantity'],
                    productTotalPrice: data['productTotalPrice'],
                    salePrice: data['salePrice'],
                    status: data['status'],
                    updatedAt: data['updatedAt']);

                return Card(
                  elevation: 5,
                  child: ListTile(
                    onTap: () => Get.to(
                      () => CheckSingleOrderScreen(
                        docId: snapshot.data!.docs[index].id,
                        orderModel: orderModel,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: AppConstant.appSecondaryColor,
                      child: Text(orderModel.customerName[0]),
                    ),
                    title: Text(data['customerName']),
                    subtitle: Text(
                      orderModel.productName,
                    ),
                    trailing: InkWell(
                        onTap: () {
                          showBottomSheet(
                              context: context,
                              userDocId: docId,
                              orderModel: orderModel,
                              orderDocId: orderDocId);
                        },
                        child: Icon(Icons.more_vert)),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  void showBottomSheet(
      {required String userDocId,
      required String orderDocId,
      required OrderModel orderModel,
      required BuildContext context}) {
    Get.bottomSheet(
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        EasyLoading.show();
                        try {
                          await FirebaseFirestore.instance
                              .collection('orders')
                              .doc(userDocId)
                              .collection('confirmOrders')
                              .doc(orderDocId)
                              .update({'status': false});

                          EasyLoading.dismiss();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: AppConstant.appSecondaryColor,
                            content: Text(
                              'Status Updated to Pending',
                              style: TextStyle(color: AppConstant.appTextColor),
                            ),
                            duration: Duration(seconds: 2),
                          ));
                        } catch (e) {
                          EasyLoading.dismiss();
                          Navigator.pop(context); // Close the bottom sheet
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to update status")),
                          );
                        }
                      },
                      child: Text("Pending"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          EasyLoading.show();

                          try {
                            await FirebaseFirestore.instance
                                .collection('orders')
                                .doc(userDocId)
                                .collection('confirmOrders')
                                .doc(orderDocId)
                                .update({'status': true});

                            EasyLoading.dismiss();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: AppConstant.appSecondaryColor,
                              content: Text(
                                'Status Updated to Delivered',
                                style:
                                    TextStyle(color: AppConstant.appTextColor),
                              ),
                              duration: Duration(seconds: 2),
                            ));
                          } catch (e) {
                            EasyLoading.dismiss();
                            Navigator.pop(context); // Close the bottom sheet
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Failed to update status")),
                            );
                          }
                        },
                        child: Text("Delivered")),
                  ),
                ],
              )
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        isDismissible: true,
        enableDrag: true,
        elevation: 6);
  }
}
