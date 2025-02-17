import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IndexDetail extends StatefulWidget {
  const IndexDetail({super.key});

  @override
  State<IndexDetail> createState() => _IndexDetailState();
}

class _IndexDetailState extends State<IndexDetail> {
  List<Map<String, dynamic>> detail = [];
  bool isLoading = true;
  Map<int, bool> selectedProduk = {};
  double totalHarga = 0.0;

  @override
  void initState() {
    super.initState();
    fetchdetail();
  }

  Future<void> fetchdetail() async {
    setState(() => isLoading = true);
    try {
      final response = await Supabase.instance.client
          .from('detailpenjualan')
          .select('*, penjualan(*, pelanggan(*)), produk(*)');

      setState(() {
        detail = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  void toggleProdukSelection(int produkID, double harga) {
    setState(() {
      selectedProduk[produkID] = !(selectedProduk[produkID] ?? false);
      totalHarga = selectedProduk[produkID]! ? totalHarga + harga : totalHarga - harga;
    });
  }

  Future<void> insertDetailPenjualan() async {
    List<Map<String, dynamic>> produkDipilih = detail.where((dtl) {
      int? produkID = dtl['produk']?['ProdukID'] as int?;
      return produkID != null && selectedProduk[produkID] == true;
    }).map((dtl) {
      return {
        'PelangganID': dtl['penjualan']?['PelangganID'],
        'TotalHarga': (dtl['Subtotal'] as num?)?.toDouble() ?? 0.0,
      };
    }).toList();

    if (produkDipilih.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pilih minimal satu produk!")),
      );
      return;
    }

    try {
      await Supabase.instance.client.from('penjualan').insert(produkDipilih);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Produk berhasil dipesan!")),
      );
      setState(() {
        selectedProduk.clear();
        totalHarga = 0.0;
      });
    } catch (e) {
      debugPrint("Error saat insert: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memesan produk: $e")),
      );
    }
  }

  
  void showOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pilih Opsi"),
        content: Text("Ingin memesan sekarang atau mencetak PDF?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              insertDetailPenjualan();
            },
            child: Text("Pesan Sekarang"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cetak PDF"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:detail.isEmpty
              ? Center(child: Text('Penjualan belum ditambahkan', style: TextStyle(fontSize: 18)))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: detail.length,
                        itemBuilder: (context, index) {
                          final dtl = detail[index];
                          int produkID = dtl['produk']?['ProdukID'] ?? 0;
                          double harga = (dtl['Subtotal'] as num?)?.toDouble() ?? 0.0;
                          return Card(
                            key: ValueKey(produkID),
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: Checkbox(
                                value: selectedProduk[produkID] ?? false,
                                onChanged: (bool? value) => toggleProdukSelection(produkID, harga),
                              ),
                              title: Text(
                                'Nama Produk: ${dtl['produk']?['NamaProduk'] ?? '-'}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nama Pelanggan: ${dtl['penjualan']?['pelanggan']?['NamaPelanggan'] ?? '-'}',
                                  ),
                                  Text('Jumlah Produk: ${dtl['JumlahProduk'] ?? 'tidak tersedia'}'),
                                  Text(
                                    'Total Harga: Rp${harga.toStringAsFixed(2)}',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton(
                        onPressed: showOrderDialog,
                        child: Text("Pesan"),
                      ),
                    )
                  ],
                ),
    );
  }
}