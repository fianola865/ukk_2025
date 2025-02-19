import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/admin/user/insertuser.dart';
import 'package:ukk_2025/admin/user/updateuser.dart';

class IndexUserAdmin extends StatefulWidget {
  const IndexUserAdmin({super.key});

  @override
  State<IndexUserAdmin> createState() => _IndexUserAdminState();
}

class _IndexUserAdminState extends State<IndexUserAdmin> {
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
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (userID != 0) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateUserAdmin(UserID: userID),
                                    ),
                                  );
                                }
                              },
                              icon: Icon(Icons.edit, color: Colors.blue),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Hapus pengguna'),
                                      content: Text(
                                          'Apakah anda yakin ingin menghapus user ini?'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Batal'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            deleteuser(userID);
                                            Navigator.pop(context);
                                          },
                                          child: Text('Hapus'),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            )
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => InsertUserAdmin()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}