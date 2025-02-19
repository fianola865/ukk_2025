import 'package:flutter/material.dart';
import 'package:ukk_2025/main.dart';
import 'package:ukk_2025/petugas/detail/indexdetailpetugas.dart';
import 'package:ukk_2025/petugas/penjualan/grafikpetugas.dart';
import 'package:ukk_2025/petugas/penjualan/penjualanpetugas.dart';
import 'package:ukk_2025/petugas/produk/indexprodukpetugas.dart';
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
      length: 6, 
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Pengaturan Dan Lain Lain', // Ganti dengan nama admin yang sesuai
                      style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.green),
                title: Text('User'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => IndexUserPetugas()));
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_bag, color: Colors.green),
                title: Text('Detail Penjualan'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => IndexDetailPetugas()));
                },
              ),
            ],
          ),
        ),
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
            Tab(icon: Icon(Icons.bar_chart, color: Colors.green), text: 'Grafik'),
            Tab(icon: Icon(Icons.inventory,color: Colors.green), text: 'produk'),
            Tab(icon: Icon(Icons.person_3, color: Colors.green), text: 'user'),
            Tab(icon: Icon(Icons.shopping_cart, color: Colors.green), text: 'penjualan'),
          ]
        ),
       ), 
       body: TabBarView(
        children: [
          GrafikAdminPetugas(),
          IndexProdukPetugas(),
          IndexUserPetugas(),
          IndexPenjualanPetugas()
        ],
       ),
      ),
    );
  }
}