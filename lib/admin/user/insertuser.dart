import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/admin/homepageadmin.dart';
import 'package:bcrypt/bcrypt.dart';

class InsertUserAdmin extends StatefulWidget {
  const InsertUserAdmin({super.key});

  @override
  State<InsertUserAdmin> createState() => _InsertUserAdminState();
}

class _InsertUserAdminState extends State<InsertUserAdmin> {
  final _usr = TextEditingController();
  final _pw = TextEditingController();
  String _selectedRole = 'admin';  // Default selected role
  final _formKey = GlobalKey<FormState>();


Future<void> InsertUserAdmin() async {
  if (_formKey.currentState!.validate()) {
    final username = _usr.text.trim();
    final password = _pw.text.trim();
    final role = _selectedRole;

    // Hash password sebelum menyimpan ke database
    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    await Supabase.instance.client.from('user').insert({
      'Username': username,
      'Password': hashedPassword,
      'Role': role
    });

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePageAdmin()));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah User'),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pw,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ), 
                items: [
                  DropdownMenuItem(
                    value: 'admin',
                    child: Text('Admin'),
                  ),
                  DropdownMenuItem(
                    value: 'petugas',
                    child: Text('Petugas'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Role tidak boleh kosong';
                  }
                  if (value != 'admin' && value != 'petugas') {
                    return 'Role hanya boleh admin atau petugas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: InsertUserAdmin,
                child: const Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}