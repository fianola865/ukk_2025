// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// class IndexPenjualan extends StatefulWidget {
//   const IndexPenjualan({super.key});

//   @override
//   State<IndexPenjualan> createState() => _IndexPenjualanState();
// }

// class _IndexPenjualanState extends State<IndexPenjualan> {
//   List<Map<String, dynamic>> penjualan = [];
//   List<int> selectedPenjualan = [];
 
//   @override
//   void initState() {
//     super.initState();
//     fetchPenjualan();
//   }

//   Future<void> fetchPenjualan() async {
    
//     try {
//       final response = await Supabase.instance.client.from('penjualan').select('*, pelanggan(*)');
//       if (mounted) {
//         setState(() {
//           penjualan = List<Map<String, dynamic>>.from(response);
         
//         });
//       }
//     } catch (e) {
//       print('Error: $e');
      
//     }
//   }

//   Future<void> saveSelectedPenjualan() async {
//     if (selectedPenjualan.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Pilih setidaknya satu produk!')),
//       );
//       return;
//     }
    
//     try {
//       for (var id in selectedPenjualan) {
//         // await Supabase.instance.client.from('detailpenjualan').insert({
//         //   'PenjualanID': id,
//         //   ''
//         // });
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Pesanan berhasil disimpan!')),
//       );
//       setState(() => selectedPenjualan.clear());
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Daftar Penjualan'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.shopping_cart),
//             onPressed: saveSelectedPenjualan,
//           ),
//         ],
//       ),
//       body
//           : penjualan.isEmpty
//               ? const Center(child: Text('Data produk belum ditambahkan'))
//               : ListView.builder(
//                   itemCount: penjualan.length,
//                   itemBuilder: (context, index) {
//                     final item = penjualan[index];
//                     return Card(
//                       elevation: 4,
//                       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12),
//                         child: Row(
//                           children: [
//                             Checkbox(
//                               value: selectedPenjualan.contains(item['PenjualanID']),
//                               onChanged: (bool? value) {
//                                 setState(() {
//                                   if (value == true) {
//                                     selectedPenjualan.add(item['PenjualanID']);
//                                   } else {
//                                     selectedPenjualan.remove(item['PenjualanID']);
//                                   }
//                                 });
//                               },
//                             ),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Nama: ${item['pelanggan']['NamaPelanggan'] ?? 'Tidak tersedia'}',
//                                     style: const TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                   Text('Tanggal: ${item['TanggalPenjualan'] ?? 'Tidak tersedia'}'),
//                                   Text('Total Harga: ${item['TotalHarga'] ?? 'Tidak tersedia'}'),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }