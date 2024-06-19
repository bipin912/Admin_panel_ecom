import 'package:admin_panel/models/product-model.dart';
import 'package:admin_panel/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleProductDetailScreen extends StatelessWidget {
  ProductModel productModel;

  SingleProductDetailScreen({Key? key, required this.productModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(productModel.productName),
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Column(
                children: [

                  SizedBox(
                      height: 20
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      CircleAvatar(
                        radius:  60.0,
                        foregroundImage: NetworkImage(productModel.productImages[0]),
                      ),

                    ],
                  ),
                  SizedBox(
                      height: 20
                  ),





                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Product Name: '),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            productModel.productName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Category Name: '),
                        Container(
                          width: Get.width /2,
                          child: Text(productModel.categoryName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Product Price: '),
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            productModel.isSale != true
                                ? 'Full Price: Rs.' + productModel.fullPrice
                                : 'Sale Price: Rs.'+productModel.salePrice,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Product Name: '),
                        Container(
                          width: Get.width /2,
                          child: Text(productModel.productName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Product Description: '),
                        Container(
                          width: Get.width /2,
                          child: Text(productModel.productDescription,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
