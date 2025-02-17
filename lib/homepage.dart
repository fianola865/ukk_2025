import 'package:flutter/material.dart';
import 'package:ukk_2025/pelanggan/indexpelanggan.dart';
import 'package:ukk_2025/produk/indexpelanggan.dart';
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
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.person,color: Color.fromARGB(255, 85, 146, 113)), text: 'pelanggan'),
            Tab(icon: Icon(Icons.shopping_cart, color: Color.fromARGB(255, 85, 146, 113)), text: 'penjualan'),
            Tab(icon: Icon(Icons.inventory, color: Color.fromARGB(255, 85, 146, 113)), text: 'produk'),
            Tab(icon: Icon(Icons.shopping_bag, color: Color.fromARGB(255, 85, 146, 113)), text: 'detail penjualan'),
            Tab(icon: Icon(Icons.person_3, color: Color.fromARGB(255, 85, 146, 113)), text: 'user')
          ]
        ),
       ),
       body: TabBarView(
        children: [
          IndexPelanggan(),
          // IndexPenjualan(),
          IndexProduk(),
          Center(child: Text('detail produk')),
          IndexUser(),
        ],
       ),
      ),
    );
  }
}