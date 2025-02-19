import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IndexUserPetugas extends StatefulWidget {
  const IndexUserPetugas({super.key});

  @override
  State<IndexUserPetugas> createState() => _IndexUserPetugasState();
}

class _IndexUserPetugasState extends State<IndexUserPetugas> {
  List<Map<String, dynamic>> user = [];
  Map<int, bool> passwordVisibility = {}; // Untuk menyimpan status visibilitas password

  @override
  void initState() {
    super.initState();
    fetchuser();
  }

  Future<void> deleteuser(int id) async {
    try {
      await Supabase.instance.client.from('user').delete().eq('UserID', id);
      fetchuser();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> fetchuser() async {
    try {
      final response = await Supabase.instance.client.from('user').select();
      setState(() {
        user = List<Map<String, dynamic>>.from(response);
        passwordVisibility = {for (var usr in user) usr['UserID']: false}; // Inisialisasi semua password tersembunyi
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user.isEmpty
          ? Center(
              child: Text('Data user belum ditambahkan'),
            )
          : ListView.builder(
              itemCount: user.length,
              itemBuilder: (context, index) {
                final usr = user[index];
                final userID = usr['UserID'];
                final isPasswordVisible = passwordVisibility[userID] ?? false;

                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username: ${usr['Username'] ?? 'tidak tersedia'}',
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Role: ${usr['Role']?.toString() ?? 'tidak tersedia'}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      
    );
  }
}