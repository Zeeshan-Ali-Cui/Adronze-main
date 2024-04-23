import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/cartmodel.dart';
import '../Models/productmodel.dart';
import '../services/firebaseaddcartservice.dart';

class fuelview extends StatefulWidget {
  cartm? cm;
  fuelview({Key? key,this.cm}) : super(key: key);

  @override
  State<fuelview> createState() => _fuelviewState();
}

class _fuelviewState extends State<fuelview> {

  List<productm> products = [
    productm("1L Fuel", "assets/images/fuel/petrol.png", "900", "1L Fuel "),
    productm("Empty Can", "assets/images/fuel/emptyfuelcan.png", "300", "Empty Fuel Can"),
  ];

  cartm? cm;

  @override
  void initState() {
    super.initState();
    if(widget.cm != null){
      cm = widget.cm;
    }
  }

  void getproducts() async {
    var cartdata = await cartservice().getcart(FirebaseAuth.instance.currentUser!.uid.toString());
    if(cartdata.id != null && cartdata.id!.isNotEmpty){
      setState(() {
        cm = cartdata;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double itemWidth = screenWidth * 0.45;
    double itemHeight = screenHeight * 0.1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel'),
        backgroundColor: Color(0xff29A9AB), // AppBar color.
        foregroundColor: Colors.white,
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              var item = products[index];

              bool alreadyExist = cm != null && cm!.products!.any((p) => p.name == item.name);

              return categoryItem(
                title: item.name.toString(),
                image: item.img.toString(),
                price: item.price.toString(),
                alreadyAdded: alreadyExist,
                onTap: () async {
                  String uid = FirebaseAuth.instance.currentUser!.uid;
                  bool check = await cartservice().addtocart(uid, item);
                  if(check){
                    setState(() {
                      cm!.products!.add(item);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Added")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Adding Failed")));
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget categoryItem({
    required String title,
    required String image,
    required String price,
    required bool alreadyAdded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity, // Take full width
        height: 120, // Fixed height for better appearance
        child: Card(
          elevation: 3,
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(8),
                child: Image.asset(image, width: 50, height: 50),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Price: $price Rs",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff29A9AB),
                ),
                onPressed: alreadyAdded
                    ? () async {
                  bool check = await cartservice().detletefromcart(FirebaseAuth.instance.currentUser!.uid, title);
                  if (check) {
                    setState(() {
                      cm!.products!.removeWhere((p) => p.name == title);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Removed")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Removing Failed")));
                  }
                }
                    : onTap,
                icon: alreadyAdded
                    ? Icon(Icons.minimize, size: 12, color: Colors.white)
                    : Icon(Icons.add_shopping_cart, size: 12, color: Colors.white),
                label: Text(
                  alreadyAdded ? "Remove" : "Add to Cart",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
