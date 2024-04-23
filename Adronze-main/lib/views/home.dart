import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../Models/cartmodel.dart';
import '../services/firebaseaddcartservice.dart';
import '../services/firebaseuserdataservice.dart';
import 'Availableitem.dart';
import 'Notification.dart';
import 'order.dart';
import 'Profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _currentAddress;
  Position? _currentPosition;
  cartm? cm; // Initialize cm with null

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getProducts();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    _getCurrentPosition().then((value) => _getAddressFromLatLng(_currentPosition!).then(
            (value) {
          userdataservice().savelatlong(FirebaseAuth.instance.currentUser!.uid, _currentPosition!.latitude!.toString(),_currentPosition!.longitude!.toString() );
        }
    ));
  }

  void getProducts() async {
    var cartdata = await cartservice().getcart(FirebaseAuth.instance.currentUser!.uid.toString());
    if (cartdata.products != null && cartdata.products!.isNotEmpty && cartdata.products != null) {
      setState(() {
        cm = cartdata;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Color(0xff29A9AB)),
      child: SafeArea(
        child: Scaffold(
          body: TabBarView(
            controller: _tabController,
            children: [
              Availableitem(cm: cm, lat: _currentPosition?.latitude, long: _currentPosition?.longitude),
              orderview(),
              notificationsview(),
              profilepage(),
            ],
          ),
          bottomNavigationBar: bottomNav(),
        ),
      ),
    );
  }

  Widget bottomNav() {
    return Container(
      color: Colors.white,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _tabController.index = 0;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Icon(
                  Icons.home,
                  color: Color(0xff29A9AB),
                ),
                Text('Home'),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _tabController.index = 1;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.card_travel,
                  color: Color(0xff29A9AB),
                ),
                Text('Order'),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _tabController.index = 2;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xff29A9AB),
                ),
                Text('Notification'),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _tabController.index = 3;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  color: Color(0xff29A9AB),
                ),
                Text('Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
