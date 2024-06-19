import 'package:admin_panel/models/order-model.dart';
import 'package:admin_panel/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/get_utils.dart';

class CheckSingleOrderScreen extends StatelessWidget {
  String docId;
  OrderModel orderModel;


  CheckSingleOrderScreen({
    Key? key,
    required this.docId,
    required this.orderModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('Order detail'),

      ),
      body: Container(
        child: Card(
          elevation: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Product Name: '+orderModel.productName),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Rs: '+orderModel.productTotalPrice.toString()),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Quantity: '+orderModel.productQuantity.toString()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Description: '+orderModel.productDescription),
              ),




              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  CircleAvatar(
                    radius:  60.0,
                    foregroundImage: NetworkImage(orderModel.productImages[0]),
                  ),

                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Customer Name: '+orderModel.customerName),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Customer No.: '+orderModel.customerPhone),
              ),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Customer Address: '+orderModel.customerAddress),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Delivery Time: '+orderModel.deliveryTime),
              ),



            ],
          ),
        ),
      )
    );

  }
}
