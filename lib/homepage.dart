import 'package:flutter/material.dart';
import 'package:ukk_2025/detail/indexdetail.dart';
import 'package:ukk_2025/main.dart';
import 'package:ukk_2025/pelanggan/indexpelanggan.dart';
import 'package:ukk_2025/penjualan/penjualan.dart';
import 'package:ukk_2025/produk/indexproduk.dart';
import 'package:ukk_2025/user/indexuser.dart';
class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, 
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Es Teh Borcelle',
        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          }, icon: Icon(Icons.exit_to_app, color: Colors.green, size: 30,))
        ],
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.person,color: Colors.white), text: 'pelanggan'),
            Tab(icon: Icon(Icons.shopping_cart, color: Colors.white), text: 'penjualan'),
            Tab(icon: Icon(Icons.inventory, color: Colors.white), text: 'produk'),
            Tab(icon: Icon(Icons.shopping_bag, color: Colors.white), text: 'detail penjualan'),
            Tab(icon: Icon(Icons.person_3, color: Colors.white), text: 'user')
          ]
        ),
       ),
       body: TabBarView(
        children: [
          IndexPelanggan(),
          IndexPenjualan(),
          IndexProduk(),
          IndexDetail(),
          IndexUser(),
        ],
       ),
      ),
    );
  }
}