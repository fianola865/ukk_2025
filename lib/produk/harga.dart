import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/homepage.dart';

class Harga extends StatefulWidget {
  final Map<String, dynamic> produk;
  const Harga({Key? key, required this.produk}) : super(key: key);

  @override
  State<Harga> createState() => _HargaState();
}

class _HargaState extends State<Harga> {
  int jumlahPesanan = 0;
  int totalHarga = 0;
  int stokAkhir = 0;
  int? pilihPelanggan;
  List<Map<String, dynamic>> pelangganlist = [];

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future<void> fetchPelanggan() async {
    try {
      final response = await Supabase.instance.client.from('pelanggan').select('PelangganID, NamaPelanggan');
      if (mounted) {
        setState(() {
          pelangganlist = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      debugPrint('Error fetching pelanggan: $e');
    }
  }

  void updateData(int harga, int delta, int stok) {
    setState(() {
      jumlahPesanan = (jumlahPesanan + delta).clamp(0, stok);
      totalHarga = jumlahPesanan * harga;
      stokAkhir = (stok - jumlahPesanan).clamp(0, stok);
    });
  }

  Future<void> simpanPesanan() async {
    final produkID = widget.produk['ProdukID'];
    final namaProduk = widget.produk['NamaProduk'];
    final harga = widget.produk['Harga'];

    if (produkID == null || pilihPelanggan == null || jumlahPesanan <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data sebelum menyimpan')),
      );
      return;
    }

    try {
      final penjualan = await Supabase.instance.client.from('detailpenjualan').insert({
        'TotalHarga': totalHarga,
        'PelangganID': pilihPelanggan
      }).select().single();

      if (penjualan.isNotEmpty) {
        await Supabase.instance.client.from('produk').update({
          'NamaProduk': namaProduk,
          'Harga': harga,
          'Stok': stokAkhir
        }).eq('ProdukID', produkID);

        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const homepage()));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;
    final harga = produk['Harga'] ?? 0;
    final stok = produk['Stok'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Nama Produk: ${produk['NamaProduk'] ?? 'Tidak Tersedia'}', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                Text('Harga: $harga', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                Text('Stok: $stok', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: pilihPelanggan,
                  hint: const Text('Pilih Pelanggan'),
                  items: pelangganlist.isNotEmpty
                      ? pelangganlist.map((pel) {
                          return DropdownMenuItem<int>(
                            value: pel['PelangganID'],
                            child: Text(pel['NamaPelanggan']),
                          );
                        }).toList()
                      : [],
                  onChanged: (value) => setState(() => pilihPelanggan = value),
                  decoration: const InputDecoration(
                    labelText: 'Pelanggan',
                    border: OutlineInputBorder(),
                  ),
                  disabledHint: pelangganlist.isEmpty
                      ? const Text('Tidak ada pelanggan tersedia')
                      : null,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => updateData(harga, -1, stok),
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$jumlahPesanan', style: const TextStyle(fontSize: 20)),
                    IconButton(
                      onPressed: () => updateData(harga, 1, stok),
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
