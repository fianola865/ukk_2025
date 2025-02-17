import 'package:flutter/material.dart';
import 'package:ukk_2025/admin/detail/indexdetail.dart';
import 'package:ukk_2025/main.dart';
import 'package:ukk_2025/admin/penjualan/penjualan.dart';
import 'package:ukk_2025/admin/produk/indexproduk.dart';
import 'package:ukk_2025/petugas/pelanggan/indexpelanggan.dart';
import 'package:ukk_2025/petugas/user/indexuserpetugas.dart';
class HomePagePetugas extends StatefulWidget {
  const HomePagePetugas({super.key});

  @override
  State<HomePagePetugas> createState() => _HomePagePetugasState();
}

class _HomePagePetugasState extends State<HomePagePetugas> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, 
      child: Scaffold(
      appBar: AppBar(
        title: Text('Es Teh Borcelle',
        style: TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          }, icon: Icon(Icons.exit_to_app, color: Colors.green, size: 30,))
        ],
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.person,color: Colors.green), text: 'pelanggan'),
            Tab(icon: Icon(Icons.shopping_cart, color: Colors.green), text: 'penjualan'),
            Tab(icon: Icon(Icons.inventory,color: Colors.green), text: 'produk'),
            Tab(icon: Icon(Icons.shopping_bag, color: Colors.green), text: 'detail penjualan'),
            Tab(icon: Icon(Icons.person_3, color: Colors.green), text: 'user')
          ]
        ),
       ),
       body: TabBarView(
        children: [
          IndexPelanggan(),
          IndexPenjualan(),
          IndexProduk(),
          IndexDetail(),
          IndexUserPetugas(),
        ],
       ),
      ),
    );
  }
}