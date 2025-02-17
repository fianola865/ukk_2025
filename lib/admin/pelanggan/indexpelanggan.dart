import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IndexPelanggan extends StatefulWidget {
  const IndexPelanggan({super.key});

  @override
  State<IndexPelanggan> createState() => _IndexPelangganState();
}

class _IndexPelangganState extends State<IndexPelanggan> {
  List<Map<String, dynamic>> pelanggan = [];
  List<Map<String, dynamic>> filteredPelanggan = [];
  final searchController = TextEditingController();
 

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future<void> deletePelanggan(int id) async {
    try {
      await Supabase.instance.client.from('pelanggan').delete().eq('PelangganID', id);
      fetchPelanggan();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('error $e')));
    }
  }

  Future<void> fetchPelanggan() async {
    try {
      final response = await Supabase.instance.client.from('pelanggan').select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response);
        filteredPelanggan = pelanggan; 
        
      });
    } catch (e) {
      print('Error: $e');
      
    }
  }

  void searchPelanggan(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPelanggan = pelanggan;
      } else {
        filteredPelanggan = pelanggan
            .where((plg) => plg['NamaPelanggan']
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
          onChanged: searchPelanggan,
          decoration: InputDecoration(
            hintText: 'Cari pelanggan...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8)
            ),
          ),
        ),
      ),
      body: filteredPelanggan.isEmpty
              ? Center(
                  child: Text(
                    'Pelanggan belum ditambahkan',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: filteredPelanggan.length,
                  itemBuilder: (context, index) {
                    final planggan = filteredPelanggan[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: SizedBox(
                        height: 180,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nama Pelanggan: ${planggan['NamaPelanggan'] ?? 'tidak tersedia'}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Alamat: ${planggan['Alamat'] ?? 'tidak tersedia'}',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Nomor Telepon: ${planggan['NomorTelepon'] ?? 'tidak tersedia'}',
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