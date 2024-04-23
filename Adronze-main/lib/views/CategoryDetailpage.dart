import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adronze/Models/cartmodel.dart';
import 'package:adronze/Models/productmodel.dart';
import 'package:adronze/services/firebaseaddcartservice.dart';

class categorydetail extends StatefulWidget {
  final cartm? cm;

  categorydetail({Key? key, this.cm}) : super(key: key);

  @override
  State<categorydetail> createState() => _categorydetailState();
}

class _categorydetailState extends State<categorydetail> {
  List<productm> products = [
    productm("Panadol", "assets/images/panadol.jpg", "80", "For headache and pain"),
    productm("Disprin", "assets/images/Disprin.jpg", "50", "For headache and pain"),
    productm("Arinac", "assets/images/ARINAC.jpg", "100", "For illness"),
    productm("Afrin", "assets/images/Afrin.jpg", "50", "For headache and pain"),
    productm("Injection", "assets/images/injection.png", "90", "Injection Kit"),
    productm("Drip", "assets/images/Drip.png", "300", "Drip Kit"),
  ];

  cartm? cm;
  bool loading = false;
  late double w, h;
  late double itemW, itemH;

  @override
  void initState() {
    super.initState();
    if (widget.cm != null) {
      cm = widget.cm;
    }
  }

  void getproducts() async {
    setState(() {
      loading = true;
    });

    var cartdata = await cartservice().getcart(FirebaseAuth.instance.currentUser!.uid.toString());
    if (cartdata.id != null && cartdata.id!.isNotEmpty) {
      setState(() {
        cm = cartdata;
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    itemW = w * 0.45;
    itemH = h * 0.1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine item'),
        backgroundColor: const Color(0xff29A9AB),
        foregroundColor: Colors.white,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: const Color(0xff29A9AB)))
          : Padding(
        padding: const EdgeInsets.only(top: 40, right: 10, left: 10),
        child: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
            Text("Price $price Rs", overflow: TextOverflow.ellipsis),
            Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff29A9AB),
              ),
              onPressed: alreadyadded ? onRemove : onTap,
              icon: Icon(
                alreadyadded ? Icons.minimize : Icons.card_travel,
                size: 12.0,
                color: Colors.white,
              ),
              label: Text(
                alreadyadded ? "Remove" : 'Add to Cart',
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
