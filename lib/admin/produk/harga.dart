import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/admin/homepageadmin.dart';
import 'package:ukk_2025/petugas/homepagepetugas.dart';

class harga extends StatefulWidget {
  final Map<String, dynamic> produk;
  const harga({Key? key, required this.produk}) : super(key: key);

  @override
  _hargaState createState() => _hargaState();
}

class _hargaState extends State<harga> {
  int jumlahPesanan = 0;
  int totalHarga = 0;
  int stokAkhir = 0;
  int? selectedPelangganId;
  List<Map<String, dynamic>> pelangganList = [];

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
    stokAkhir = widget.produk['Stok'] ?? 0;
  }

  Future<void> fetchPelanggan() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('pelanggan').select('PelangganID, NamaPelanggan');

    if (response.isNotEmpty) {
      setState(() {
        pelangganList = List<Map<String, dynamic>>.from(response);
      });
    }
  }

  void updateJumlahPesanan(int harga, int delta) {
    setState(() {
      if (jumlahPesanan + delta >= 0 && jumlahPesanan + delta <= stokAkhir) {
        jumlahPesanan += delta;
        totalHarga = jumlahPesanan * harga;
      }
    });
  }

  Future<void> simpanPesanan() async {
    final supabase = Supabase.instance.client;
    final produkID = widget.produk['ProdukID'];

    if (produkID == null || selectedPelangganId == null || jumlahPesanan <= 0) {
      print("Gagal menyimpan, pastikan semua data sudah lengkap.");
      return;
    }

    try {
      final penjualan = await supabase.from('detailpenjualan').insert({
        'PenjualanID': selectedPelangganId,
        'ProdukID': produkID,
        'JumlahProduk': jumlahPesanan,
        'Subtotal': totalHarga,
      }).select().single();

      if (penjualan.isNotEmpty) {
        await supabase.from('produk').update({
          'Stok': stokAkhir - jumlahPesanan,
        }).eq('ProdukID', produkID);

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePageAdmin()));
      }
    } catch (e) {
      print("Error saat menyimpan pesanan: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;
    final harga = produk['Harga'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama Produk: ${produk['NamaProduk'] ?? 'Tidak Tersedia'}', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                Text('Harga: $harga', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                Text('Stok: $stokAkhir', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16),

                DropdownButtonFormField<int>(
                  value: selectedPelangganId,
                  items: pelangganList.map((pelanggan) {
                    return DropdownMenuItem<int>(
                      value: pelanggan['PelangganID'],
                      child: Text(pelanggan['NamaPelanggan']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPelangganId = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Pilih Pelanggan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => updateJumlahPesanan(harga, -1),
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$jumlahPesanan', style: const TextStyle(fontSize: 20)),
                    IconButton(
                      onPressed: () => updateJumlahPesanan(harga, 1),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup', style: TextStyle(fontSize: 20)),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: jumlahPesanan > 0 ? simpanPesanan : null,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: Text('Pesan ($totalHarga)', style: const TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}