import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/pelanggan/insertpelanggan.dart';
import 'package:ukk_2025/pelanggan/updatepelanggan.dart';

class IndexPelanggan extends StatefulWidget {
  const IndexPelanggan({super.key});

  @override
  State<IndexPelanggan> createState() => _IndexPelangganState();
}

class _IndexPelangganState extends State<IndexPelanggan> {
  List<Map<String, dynamic>> pelanggan = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Pelanggan();
  }
  
  Future<void> deletepelanggan(int id) async{
    try{
    await Supabase.instance.client.from('pelanggan').delete().eq('PelangganID', id);
    Pelanggan();
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('error $e')));
    }

  }

  Future<void> Pelanggan() async{
    
    try{
    final response = await Supabase.instance.client.from('pelanggan').select();
    setState(() {
      pelanggan = List<Map<String, dynamic>>.from(response);
      
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
          : pelanggan.isEmpty
          ? Center(
            child: Text('Data pelanggan belum ditambahkan'),
          )
          :ListView.builder(
              itemCount: pelanggan.length,
              itemBuilder: (context, index){
                final Pelanggan = pelanggan[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nama Pelanggan: ${Pelanggan['NamaPelanggan'] ?? 'tidak tersedia'}'),
                        Text('Alamat: ${Pelanggan['Alamat'] ?? 'Tidak tersedia'}'),
                        Text('Nomor Telepon: ${Pelanggan['NomorTelepon'] ?? 'tidak tersedia'}'),
                        Row(
                          children: [
                            IconButton(onPressed: (){
                              final PelangganID = Pelanggan['PelangganID'];
                              if(PelangganID != 0){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UpdatePelanggan(PelangganID: PelangganID)));
                              }
                            }, icon: Icon(Icons.edit)),
                            IconButton(onPressed: (){
                              showDialog(
                                context: context, builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text('Hapus pelanggan'),
                                    content: Text('Apakah anda yakin menghapus use ini?'),
                                    actions: [
                                      ElevatedButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: Text('Batal')),
                                      ElevatedButton(onPressed: (){
                                        deletepelanggan(Pelanggan['PelangganID']); 
                                        Navigator.pop(context);
                                      }, child: Text('Hapus'))
                                    ],
                                  );
                                }
                              );
                            }, icon: Icon(Icons.delete))
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Insertpelanggan()));
      }, child: Icon(Icons.add)),
    );
  }
}