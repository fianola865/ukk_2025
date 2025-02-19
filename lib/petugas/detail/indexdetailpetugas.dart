import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class IndexDetailPetugas extends StatefulWidget {
  const IndexDetailPetugas({super.key});

  @override
  State<IndexDetailPetugas> createState() => _IndexDetailPetugasState();
}

class _IndexDetailPetugasState extends State<IndexDetailPetugas> {
  List<Map<String, dynamic>> detailList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> deleteDetail(int id) async {
    try {
      await Supabase.instance.client.from('detailpenjualan').delete().eq('DetailID', id);
      fetchDetail();
    } catch (e) {
      debugPrint('Error saat menghapus: $e');
    }
  }

  Future<void> fetchDetail() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('detailpenjualan')
          .select('*, penjualan(*, pelanggan(*)), produk(*)');

      setState(() {
        detailList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error saat mengambil data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: detailList.length,
              itemBuilder: (context, index) {
                final dtl = detailList[index];
                final penjualan = dtl['penjualan'] ?? {};
                final pelanggan = penjualan['pelanggan'] ?? {};
                final produk = dtl['produk'] ?? {};

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    height: 180,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama Pelanggan: ${pelanggan['NamaPelanggan'] ?? 'Tidak tersedia'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nama Produk: ${produk['NamaProduk'] ?? 'Tidak tersedia'}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Jumlah Produk: ${dtl['JumlahProduk'] ?? 'Tidak tersedia'}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'SubTotal: Rp${dtl['Subtotal'] != null ? NumberFormat("#,###", "id_ID").format(int.tryParse(dtl['Subtotal'].toString()) ?? 0) : 'tidak tersedia'}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}