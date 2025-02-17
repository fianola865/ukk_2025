import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/produk/harga.dart';
import 'package:ukk_2025/produk/insertproduk.dart';
import 'package:ukk_2025/produk/updateproduk.dart';

class IndexProduk extends StatefulWidget {
  const IndexProduk({super.key});

  @override
  State<IndexProduk> createState() => _IndexProdukState();
}

class _IndexProdukState extends State<IndexProduk> {
  List<Map<String, dynamic>> produk = [];
  List<Map<String, dynamic>> filteredproduk = [];
  final seletedproduk = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> deleteProduk(int id) async {
    try {
      await Supabase.instance.client.from('produk').delete().eq('ProdukID', id);
      fetchProduk();
    } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> fetchProduk() async {
    
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
  void seletectproduk(String query) {
    setState(() {
    if(query.isEmpty){
      filteredproduk = produk;
    } else {
    filteredproduk = produk
          .where((item) => item['NamaProduk']
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
          controller: seletedproduk,
          onChanged: seletectproduk,
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
              child: Text('tidak ada data produk'),
            )
              : produk.isEmpty
              ? Center(
                  child: Text('Data produk belum ditambahkan'),
                )
              : ListView.builder(
                  itemCount: filteredproduk.length,
                  itemBuilder: (context, index) {
                    final item = filteredproduk[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => harga(produk: item)),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nama Produk: ${item['NamaProduk'] ?? 'Tidak tersedia'}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text('Harga: ${item['Harga'] ?? 'Tidak tersedia'}',
                              style: TextStyle(fontSize: 16),),
                              Text('Stok: ${item['Stok'] ?? 'Tidak tersedia'}',
                              style: TextStyle(fontSize: 14),),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      final produkID = item['ProdukID'];
                                      if (produkID != null) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateProduk(ProdukID: produkID),
                                          ),
                                        );
                                      }
                                    },
                                    icon: Icon(Icons.edit, color: Colors.blue,),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Hapus Produk'),
                                            content: Text(
                                                'Apakah Anda yakin ingin menghapus produk ini?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Batal'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  deleteProduk(item['ProdukID']);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Hapus'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => insertProduk()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
