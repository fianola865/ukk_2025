import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IndexDetail extends StatefulWidget {
  const IndexDetail({super.key});

  @override
  State<IndexDetail> createState() => _IndexDetailState();
}

class _IndexDetailState extends State<IndexDetail> {
  List<Map<String, dynamic>> Detail = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDetail();
  }
  
  Future<void> deleteDetail(int id) async{
    try{
    await Supabase.instance.client.from('Detail').delete().eq('DetailID', id);
    fetchDetail();
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('error $e')));
    }

  }

  Future<void> fetchDetail() async{
    
    try{
    final response = await Supabase.instance.client.from('detailpenjualan').select('*, penjualan(*, pelanggan(*)), produk(*)');
    setState(() {
      Detail = List<Map<String, dynamic>>.from(response);
      
    });
    } catch(e){
      print('error $e');
      setState(() {
        
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body
          : Detail.isEmpty
          ? Center(
            child: Text('Data Detail belum ditambahkan'),
          )
          :ListView.builder(
              itemCount: Detail.length,
              itemBuilder: (context, index){
                final Dl = Detail[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nama Pelanggan: ${Dl['penjualan']['pelanggan']['NamaPelanggan'] ?? 'tidak tersedia'}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        Text('Nama Produk: ${Dl['produk']['NamaProduk'] ?? 'Tidak tersedia'}',
                        style: TextStyle(fontSize: 18),),
                        Text('Jumlah Produk: ${Dl['JumlahProduk'] ?? 'tidak tersedia'}',
                        style: TextStyle(fontSize: 16),),
                        Text('Total Harga: ${Dl['Subtotal'] ?? 'tidak tersedia'}',
                        style: TextStyle(fontSize: 14),),
                      ],
                    ),
                  ),
                );
              },
            ),
          
    );
  }
}