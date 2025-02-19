import 'package:flutter/material.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/admin/produk/insertproduk.dart';
import 'package:ukk_2025/admin/produk/updateproduk.dart';
import 'package:intl/intl.dart';

class IndexProdukPetugas extends StatefulWidget {
  const IndexProdukPetugas({super.key});

  @override
  State<IndexProdukPetugas> createState() => _IndexProdukPetugasState();
}

class _IndexProdukPetugasState extends State<IndexProdukPetugas> {
  List<Map<String, dynamic>> produk = [];
  List<Map<String, dynamic>> filteredProduk = [];
  bool isLoading = true;
  final searchController = TextEditingController();

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk tidak bisa dihapus karena sudah pernah bertransaksi'))
      );
    }
  }

  Future<void> fetchProduk() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('produk').select();
      setState(() {
        produk = List<Map<String, dynamic>>.from(response);
        filteredProduk = produk;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchProduk(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProduk = produk;
      } else {
        filteredProduk = produk
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
          onChanged: searchProduk,
          decoration: InputDecoration(
            hintText: 'Cari produk...',
            border: InputBorder.none,
          ),
        ),
      ),
      body:ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: filteredProduk.length,
              itemBuilder: (context, index) {
                final prd = filteredProduk[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama Produk: ${prd['NamaProduk'] ?? 'tidak tersedia'}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Harga: Rp${prd['Harga'] != null ? NumberFormat("#,###", "id_ID").format(int.tryParse(prd['Harga'].toString()) ?? 0) : 'tidak tersedia'}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                final ProdukID = prd['ProdukID'] ?? 0;
                                if (ProdukID != 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateProdukAdmin(ProdukID: ProdukID),
                                    ),
                                  );
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Hapus Produk'),
                                      content: Text('Apa Anda yakin ingin menghapus produk ini?'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Batal'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            deleteProduk(prd['ProdukID']);
                                            Navigator.pop(context);
                                          },
                                          child: Text('Hapus'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Stok: ${prd['Stok'] ?? 'tidak tersedia'}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => InsertProdukAdmin()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}