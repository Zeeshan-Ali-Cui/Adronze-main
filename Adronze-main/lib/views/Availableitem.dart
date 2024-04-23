import 'package:adronze/Models/cartmodel.dart';
import 'package:adronze/services/firebaseaddcartservice.dart';
import 'package:adronze/services/firebaseuserdataservice.dart';
import 'package:adronze/views/Bookview.dart';
import 'package:adronze/views/CategoryDetailpage.dart';
import 'package:adronze/views/Fuel.dart';
import 'package:adronze/views/Upcomingitems.dart';
import 'package:adronze/views/grocery.dart';
import 'package:adronze/views/showcart.dart';
import 'package:adronze/views/sports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imager/imager.dart';

class Availableitem extends StatefulWidget {
  late cartm? cm;
  final double? lat, long;

  Availableitem({Key? key, this.cm, this.lat, this.long}) : super(key: key);

  @override
  State<Availableitem> createState() => _AvailableitemState();
}

class _AvailableitemState extends State<Availableitem> {
  late double w, h;
  late double itemW, itemH;

  @override
  void initState() {
    super.initState();
    userdataservice().savetoken(FirebaseAuth.instance.currentUser!.uid);
  }

  bool loading = false;
  bool loadingError = false;

  void getProducts() async {
    setState(() {
      loading = true;
    });
    try {
      var cartData = await cartservice()
          .getcart(FirebaseAuth.instance.currentUser!.uid.toString());
      if (cartData.products != null &&
          cartData.products!.isNotEmpty &&
          cartData.products != null) {
        setState(() {
          widget.cm = cartData;
        });
      }
    } catch (e) {
      setState(() {
        loadingError = true;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    itemW = w * 0.45;
    itemH = h * 0.1;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: const Color(0xff29A9AB),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Home",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                  return showcart(
                    lat: widget.lat,
                    long: widget.long,
                  );
                }));
              },
            ),
          ],
          backgroundColor: const Color(0xff29A9AB),
          foregroundColor: Colors.white,
        ),
        body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: loadingError
                ? Center(
              child: InkWell(
                onTap: () {
                  getProducts();
                },
                child: Text("Error Loading Data...\nRefresh"),
              ),
            )
                : loading
                ? Center(
              child: CircularProgressIndicator(
                color: Colors.blueGrey,
              ),
            )
                : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 10),
                    child: Text("Welcome Back!"),
                  ),
                  Container(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    height: 187.h, // Adjust this value as needed
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          color: Colors.white,
                          child: Imager.fromLocal(
                            "assets/images/Droneimg.jpg",
                            height: MediaQuery.of(context).size.height * 0.3, // Adjust this value as needed
                            width: MediaQuery.of(context).size.width * 0.8, // Adjust this value as needed
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          color: Colors.white,
                          child: Imager.fromLocal(
                            "assets/images/dronegif2.gif",
                            height: MediaQuery.of(context).size.height * 0.3, // Adjust this value as needed
                            width: MediaQuery.of(context).size.width * 0.8, // Adjust this value as needed
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          color: Colors.white,
                          child: Imager.fromLocal(
                            "assets/images/dronedelivery.jpg",
                            height: MediaQuery.of(context).size.height * 0.3, // Adjust this value as needed
                            width: MediaQuery.of(context).size.width * 0.8, // Adjust this value as needed
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(),
                  //Services text portion start
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                              child: Text(
                                "Services",
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(),
                  Container(
                    child: GridView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 2),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      children: [
                        categoryItems(
                          "Medicine",
                          "assets/images/medicine.png",
                              () => showModalBottomSheet(
                            context: context,
                            builder: (context) => categorydetail(
                              cm: widget.cm,
                            ),
                          ),
                        ),
                        categoryItems(
                          "Groceries",
                          "assets/images/Groceries.png",
                              () => showModalBottomSheet(
                            context: context,
                            builder: (context) => groceryitem(
                              cm: widget.cm,
                            ),
                          ),
                        ),
                        categoryItems(
                          "Books",
                          "assets/images/Books.png",
                              () => showModalBottomSheet(
                            context: context,
                            builder: (context) => bookview(
                              cm: widget.cm,
                            ),
                          ),
                        ),
                        categoryItems(
                          "Fuel",
                          "assets/images/fuel.png",
                              () => showModalBottomSheet(
                            context: context,
                            builder: (context) => fuelview(
                              cm: widget.cm,
                            ),
                          ),
                        ),
                        categoryItems(
                          "Sports items",
                          "assets/images/Sports.png",
                              () => showModalBottomSheet(
                            context: context,
                            builder: (context) => sportsview(
                              cm: widget.cm,
                            ),
                          ),
                        ),
                        categoryItems(
                          "Upcomings",
                          "assets/images/upcoming.png",
                              () => showModalBottomSheet(
                            context: context,
                            builder: (context) => Upcomingitem(),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
//All Items Cart here
  Widget categoryItems(String title, String image, Function onTap) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * 0.45; // Adjust this factor as needed
        final cardHeight = cardWidth * 1.2; // Maintain aspect ratio
        final imageSize = cardWidth * 0.8; // Adjust image size
        final fontSize = cardWidth * 0.3; // Adjust font size

        return InkWell(
          onTap: () {
            onTap();
          },
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      image,
                      width: imageSize,
                      height: imageSize,
                    ),
                  ),
                  Spacer(),
                  Text(
                    title,
                    style: TextStyle(fontSize: fontSize),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
