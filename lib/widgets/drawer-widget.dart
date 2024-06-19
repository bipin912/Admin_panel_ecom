
import 'package:admin_panel/screens/all-categories-screen.dart';
import 'package:admin_panel/screens/all-orders-screen.dart';
import 'package:admin_panel/screens/all-products-screen.dart';
import 'package:admin_panel/screens/all-users-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';


import '../utils/app-constant.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Get.height / 25),
      child: Drawer(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            )),
        child: Wrap(
          runSpacing: 10,
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Bipin",
                  style: TextStyle(
                    color: AppConstant.appTextColor,
                  ),
                ),
                subtitle: Text("Version 1.0.1"),
                leading: CircleAvatar(
                  radius: 22.0,
                  backgroundColor: Colors.white,
                  child: Text("B"),
                ),
              ),
            ),
            Divider(
              indent: 10.0,
              endIndent: 10.0,
              thickness: 1.5,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("Home",
                      style: TextStyle(
                        color: AppConstant.appTextColor,
                      )),
                  leading: Icon(Icons.home,color: Colors.white),
                  trailing: Icon(Icons.arrow_forward,color: Colors.white),
                  onTap: (){
                    Get.back();

                  }
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("Users",
                      style: TextStyle(
                        color: AppConstant.appTextColor,
                      )),
                  leading: Icon(Icons.person,color: Colors.white),
                  trailing: Icon(Icons.arrow_forward,color: Colors.white),
                  onTap: (){
                    Get.to(()=>AllUserScreen());

                  }
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("Orders",
                      style: TextStyle(
                        color: AppConstant.appTextColor,
                      )),
                  leading: Icon(Icons.shopping_bag,color: Colors.white),
                  trailing: Icon(Icons.arrow_forward,color: Colors.white),
                  onTap: (){
                    Get.to(()=> AllOrdersScreen());

                  }
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("Reviews",
                      style: TextStyle(
                        color: AppConstant.appTextColor,
                      )),
                  leading: Icon(Icons.reviews,color: Colors.white),
                  trailing: Icon(Icons.arrow_forward,color: Colors.white),
                  onTap: (){
                    Get.back();

                  }
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("Products",
                      style: TextStyle(
                        color: AppConstant.appTextColor,
                      )),
                  leading: Icon(Icons.production_quantity_limits,color: Colors.white,),
                  trailing: Icon(Icons.arrow_forward,color: Colors.white),
                  onTap: (){
                    Get.to(()=>AllProductsScreen());

                  }
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("Categories",
                      style: TextStyle(
                        color: AppConstant.appTextColor,
                      )),
                  leading: Icon(Icons.category,color: Colors.white),
                  trailing: Icon(Icons.arrow_forward,color: Colors.white),
                  onTap: (){
                    Get.back();

                    Get.to(()=> AllCategoriesScreen());

                  }
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Contact",
                    style: TextStyle(
                      color: AppConstant.appTextColor,
                    )),
                leading: Icon(Icons.help,color: Colors.white),
                trailing: Icon(Icons.arrow_forward,color: Colors.white),
                onTap: () {
                  sendMessageOnWhatsapp();
                },

              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListTile(
                onTap: ()async{
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  FirebaseAuth _auth = FirebaseAuth.instance;
                  await _auth.signOut();

                  await googleSignIn.signOut();
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Logout",
                    style: TextStyle(
                      color: AppConstant.appTextColor,
                    )),
                leading: Icon(Icons.logout,color: Colors.white),
                trailing: Icon(Icons.arrow_forward,color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppConstant.appSecondaryColor,
      ),
    );
  }

  static Future<void> sendMessageOnWhatsapp() async {
    final String number = "+9779804071418";
    final String message = "Hello Bipin \n I got some queries }";
    final Uri whatsappUrl = Uri.parse('whatsapp://send?phone=$number&text=${Uri.encodeComponent(message)}');
    final Uri webUrl = Uri.parse('https://wa.me/$number?text=${Uri.encodeComponent(message)}');

    print('Constructed WhatsApp URL: $whatsappUrl'); // Log the WhatsApp URL
    print('Constructed Web URL: $webUrl'); // Log the Web URL

    if (await canLaunchUrl(whatsappUrl)) {
      print('Launching WhatsApp URL: $whatsappUrl'); // Log successful launch attempt
      await launchUrl(whatsappUrl);
    } else if (await canLaunchUrl(webUrl)) {
      print('Launching Web URL: $webUrl'); // Log successful launch attempt
      await launchUrl(webUrl);
    } else {
      print('Could not launch $whatsappUrl or $webUrl'); // Log failure
      throw 'Could not launch $whatsappUrl or $webUrl';
    }
  }
}
