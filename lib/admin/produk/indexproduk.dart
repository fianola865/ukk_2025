import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/admin/produk/insertproduk.dart';
import 'package:ukk_2025/admin/produk/updateproduk.dart';

class IndexProdukAdmin extends StatefulWidget {
  const IndexProdukAdmin({super.key});

  @override
  State<IndexProdukAdmin> createState() => _IndexProdukAdminState();
}

class _IndexProdukAdminState extends State<IndexProdukAdmin> {
  List<Map<String, dynamic>> produk = [];
  List<Map<String, dynamic>> filteredproduk = [];
  final searchController = TextEditingController();
 

  @override
  void initState() {
    super.initState();
    fetchproduk();
  }

  Future<void> deleteproduk(int id) async {
    try {
      await Supabase.instance.client.from('produk').delete().eq('ProdukID', id);
      fetchproduk();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('error $e')));
    }
  }

  Future<void> fetchproduk() async {
    try {
      final response = await Supabase.instance.client.from('produk').select();
      setState(() {
        produk = List<Map<String, dynamic>>.from(response);
        filteredproduk = produk; 
        
      });
    } catch (e) {
      print('Error: $e');
      
    }
  }

  void searchproduk(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredproduk = produk;
      } else {
        filteredproduk = produk
            .where((prd) => prd['NamaProduk']
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: searchproduk,
          decoration: InputDecoration(
            hintText: 'Cari produk...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8)
            ),
          ),
        ),
      ),
      body: filteredproduk.isEmpty
              ? Center(
                  child: Text(
                    'produk belum ditambahkan',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: filteredproduk.length,
                  itemBuilder: (context, index) {
                    final prd = filteredproduk[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: SizedBox(
                        height: 180,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nama produk: ${prd['NamaProduk'] ?? 'tidak tersedia'}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Harga: ${prd['Harga'] ?? 'tidak tersedia'}',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Stok : ${prd['Stok'] ?? 'tidak tersedia'}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ]
                              
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => InsertProdukAdmin()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}