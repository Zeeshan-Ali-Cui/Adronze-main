import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/cartmodel.dart';
import '../Models/productmodel.dart';
import '../services/firebaseaddcartservice.dart';

class groceryitem extends StatefulWidget {
  final cartm? cm;

  groceryitem({Key? key, this.cm}) : super(key: key);

  @override
  State<groceryitem> createState() => _groceryitemState();
}

class _groceryitemState extends State<groceryitem> {
  List<productm> products = [
    productm("Vegetable", "assets/images/grocery/vegetable.png", "80", "1kg item only"),
    productm("Fruits", "assets/images/grocery/fruits.png", "300", "1kg item only"),
    productm("Burger", "assets/images/grocery/burger.png", "150", "1 Burger only"),
    productm("Drink", "assets/images/grocery/drink.png", "50", "1 NR Drink only"),
  ];

  cartm? cm;

  @override
  void initState() {
    super.initState();
    if (widget.cm != null) {
      cm = widget.cm;
    }
  }

  late double w, h;
  late double itemW, itemH;

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    itemW = w * 0.45;
    itemH = h * 0.1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery item'),
        backgroundColor: const Color(0xff29A9AB), // appbar color.
        foregroundColor: Colors.white,
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              var item = products[index];
              bool alreadyexist = false;
              if (cm != null) {
                for (var p in cm!.products!) {
                  if (p.name == item.name) {
                    alreadyexist = true;
                    break;
                  }
                }
              }
              return categoryItems(
                item.name.toString(),
                item.img.toString(),
                item.price.toString(),
                alreadyexist,
                    () async {
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
                    () async {
                  bool check = await cartservice().detletefromcart(FirebaseAuth.instance.currentUser!.uid, item.name!);
                  if (check) {
                    setState(() {
                      cm!.products!.removeWhere((element) => element.name == item.name);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Removed")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Removing Failed")));
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget categoryItems(String title, String image, String price, bool alreadyadded, Function() onTap, Function() onRemove) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: itemW,
        height: itemH,
        child: Card(
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Image.asset(image, width: 50, height: h * 0.09),
              ),
              Spacer(),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacer(),
              Text("Price $price Rs"),
              Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff29A9AB),
                ),
                onPressed: alreadyadded
                    ? () async {
                  bool check = await cartservice().detletefromcart(FirebaseAuth.instance.currentUser!.uid, title);
                  if (check) {
                    setState(() {
                      cm!.products!.removeWhere((element) => element.name == title);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Remove")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Removing Failed")));
                  }
                }
                    : onTap,
                icon: alreadyadded
                    ? Icon(Icons.minimize, size: 12.0, color: Colors.white)
                    : Icon(
                  Icons.card_travel,
                  size: 12.0,
                  color: Colors.white,
                ),
                label: Text(
                  alreadyadded ? "remove" : 'Add to Cart',
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
