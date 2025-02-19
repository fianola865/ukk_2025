import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/admin/homepageadmin.dart';
import 'package:bcrypt/bcrypt.dart';

class UpdateUserAdmin extends StatefulWidget {
  final int UserID;
  const UpdateUserAdmin({super.key, required this.UserID});

  @override
  State<UpdateUserAdmin> createState() => _UpdateUserAdminState();
}

class _UpdateUserAdminState extends State<UpdateUserAdmin> {
  final _usr = TextEditingController();
  final _pw = TextEditingController();
  final _role = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? oldPassword; // Menyimpan hash password lama

  @override
  void initState() {
    super.initState();
    tampiluser();
  }

  Future<void> tampiluser() async {
    final data = await Supabase.instance.client
        .from('user')
        .select()
        .eq('UserID', widget.UserID)
        .single();

    setState(() {
      _usr.text = data['Username'] ?? '';
      _role.text = data['Role'] ?? '';
      oldPassword = data['Password']; // Simpan password lama (hashed)
      _pw.text = ''; // Kosongkan agar user bisa isi password baru
    });
  }

  Future<void> UpdateUserAdmin() async {
    if (_formKey.currentState!.validate()) {
      String newPassword = _pw.text.trim();
      String updatedPassword = oldPassword!; // Default ke password lama

      // Cek apakah password diubah
      if (newPassword.isNotEmpty) {
        updatedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
      }

      await Supabase.instance.client.from('user').update({
        'Username': _usr.text.trim(),
        'Password': updatedPassword,
        'Role': _role.text.trim(),
      }).eq('UserID', widget.UserID);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePageAdmin()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _usr,
                  decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _pw,
                  decoration: InputDecoration(
                      labelText: 'Password (kosongkan jika tidak diubah)',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _role,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) {
                    if (value != 'petugas' && value != 'admin') {
                      return 'Hanya boleh admin dan petugas';
                    }
                    if (value == null || value.isEmpty) {
                      return 'tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(onPressed: UpdateUserAdmin, child: Text('Update'))
              ],
            )),
      ),
    );
  }
}