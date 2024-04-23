import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/cartmodel.dart';
import '../Models/productmodel.dart';
import '../services/firebaseaddcartservice.dart';

class sportsview extends StatefulWidget {
  final cartm? cm;

  sportsview({Key? key, this.cm}) : super(key: key);

  @override
  State<sportsview> createState() => _sportsviewState();
}

class _sportsviewState extends State<sportsview> {
  late double itemWidth;
  late double itemHeight;

  List<productm> products = [
    productm("Cricket Ball", "assets/images/Sports/cricket.png", "8000", "Cricket Ball"),
    productm("Base Ball", "assets/images/Sports/baseball.png", "9000", "Base Ball"),
  ];

  cartm? cm;

  @override
  void initState() {
    super.initState();
    cm = widget.cm;
  }

  @override
  Widget build(BuildContext context) {
    itemWidth = MediaQuery.of(context).size.width * 0.9;
    itemHeight = MediaQuery.of(context).size.height * 0.15;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sports'),
        backgroundColor: Color(0xff29A9AB),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
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
              if (check) {
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
      child: Container(
        height: itemHeight,
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Card(
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                child: Image.asset(image, width: 50, height: 50),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                      maxLines: 2, // Ensure text doesn't overflow horizontally
                      overflow: TextOverflow.ellipsis, // Ellipsis for long titles
                    ),
                    SizedBox(height: 5),
                    Text("Price ${price} Rs"),
                  ],
                ),
              ),
              Spacer(),
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
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Remove")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Removing Failed")));
                  }
                }
                    : onTap,
                icon: alreadyAdded ? Icon(Icons.minimize, size: 12.0, color: Colors.white) : Icon(Icons.card_travel, size: 12.0, color: Colors.white),
                label: Text(
                  alreadyAdded ? "Remove" : 'Add to Cart',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
