import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:ukk_2025/admin/homepageadmin.dart';

class hargaAdmin extends StatefulWidget {
  final Map<String, dynamic> produk;
  const hargaAdmin({Key? key, required this.produk}) : super(key: key);

  @override
  _hargaAdminState createState() => _hargaAdminState();
}

class _hargaAdminState extends State<hargaAdmin> {
  int jumlahPesanan = 0;
  int stokakhir = 0;
  int totalhargaAdmin = 0;
  int? selectedPelangganId;
  List<Map<String, dynamic>> pelangganList = [];
  

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
    stokakhir = widget.produk['Stok'] ;

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

  void updateJumlahPesanan(int hargaAdmin, int delta) {
    setState(() {
      if (jumlahPesanan + delta >= 0 && jumlahPesanan + delta <= stokakhir) {
        jumlahPesanan += delta;
        totalhargaAdmin = jumlahPesanan * hargaAdmin;
      }
    });
  }

  Future<void> simpanPesanan() async {
    final supabase = Supabase.instance.client;
    final produkid = widget.produk['ProdukID'];

    if (produkid == null || selectedPelangganId == null || jumlahPesanan <= 0) {
      print("Gagal menyimpan, pastikan semua data sudah lengkap.");
      return;
    }

    try {
      final penjualan = await supabase.from('penjualan').insert({
        'TotalhargaAdmin': totalhargaAdmin,
        'PelangganID': selectedPelangganId,
      }).select().single();

      if (penjualan.isNotEmpty) {
        final penjualanId = penjualan['PenjualanID'];

        await supabase.from('detailpenjualan').insert({
          'PenjualanID': penjualanId,
          'ProdukID': produkid,
          'JumlahProduk': jumlahPesanan,
          'Subtotal': totalhargaAdmin,
        }).select().single();

        await supabase.from('produk').update({
          'Stok': stokakhir - jumlahPesanan
        }).eq('ProdukID', produkid);
        setState(() {
          stokakhir -= jumlahPesanan;
        });

        // Konfirmasi cetak struk setelah pesanan tersimpan
        showPrintConfirmation(penjualanId);
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePageAdmin()));
      }
    } catch (e) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePageAdmin()));
    }
  }

  Future<void> showPrintConfirmation(int penjualanId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Cetak'),
        content: const Text('Apakah Anda ingin mencetak struk pembelian?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cetak'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      generatePDF(penjualanId);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePageAdmin()));
    }
  }

  Future<void> generatePDF(int penjualanId) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Struk Pembelian', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Text('ID Penjualan: $penjualanId'),
            pw.Text('Nama Produk: ${widget.produk['NamaProduk']}'),
            pw.Text('Jumlah: $jumlahPesanan'),
            pw.Text('Total hargaAdmin: Rp $totalhargaAdmin'),
            pw.SizedBox(height: 16),
            pw.Text('Terima kasih telah berbelanja!', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePageAdmin()));
  }

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;
    final hargaAdmin = produk['hargaAdmin'] ?? 0;

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
                Text('hargaAdmin: $hargaAdmin', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                Text('Stok: ${produk['Stok'] ?? 'Tidak Tersedia'}', style: const TextStyle(fontSize: 20)),
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
                      onPressed: () => updateJumlahPesanan(hargaAdmin, -1),
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$jumlahPesanan', style: const TextStyle(fontSize: 20)),
                    IconButton(
                      onPressed: () => updateJumlahPesanan(hargaAdmin, 1),
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
                      child: Text('Pesan ($totalhargaAdmin)', style: const TextStyle(fontSize: 20)),
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