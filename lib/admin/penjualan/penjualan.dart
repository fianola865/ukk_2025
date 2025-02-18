import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/petugas/penjualan/insertpenjualan.dart';
class IndexPenjualanPetugas extends StatefulWidget {
  const IndexPenjualanPetugas({super.key});

  @override
  State<IndexPenjualanPetugas> createState() => _IndexPenjualanPetugasState();
}

class _IndexPenjualanPetugasState extends State<IndexPenjualanPetugas> {
  List<Map<String, dynamic>> penjualan = [];
  List<int> selectedPenjualan = [];
 
  @override
  void initState() {
    super.initState();
    fetchPenjualan();
  }

  Future<void> fetchPenjualan() async {
    
    try {
      final response = await Supabase.instance.client.from('penjualan').select('*, pelanggan(*)');
        setState(() {
          penjualan = List<Map<String, dynamic>>.from(response);
         
        });
    } catch (e) {
      print('Error: $e');
      
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body
          : penjualan.isEmpty
              ? const Center(child: Text('Data penjualan belum ditambahkan'))
              : Container(
                padding: EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: penjualan.length,
                  itemBuilder: (context, index) {
                    final pjl = penjualan[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama Pelanggan: ${pjl['pelanggan']['NamaPelanggan'] ?? 'Tidak tersedia'}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text('Tanggal: ${pjl['TanggalPenjualan'] ?? 'Tidak tersedia'}',
                          style: TextStyle(fontSize: 16),),
                          Text('Total Harga: ${pjl['TotalHarga'] ?? 'Tidak tersedia'}',
                        style: TextStyle(fontSize: 14),),
                        ],
                      ),
                    );
                  },
                ),
              ),
      // floatingActionButton: FloatingActionButton(onPressed: (){
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => InsertPenjualan(produk: pjl)));
      // },
      // child: Icon(Icons.add),
      // ), 
    );
  }
}