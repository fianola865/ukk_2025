import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/petugas/homepagepetugas.dart';

class Insertuser extends StatefulWidget {
  const Insertuser({super.key});

  @override
  State<Insertuser> createState() => _InsertuserState();
}

class _InsertuserState extends State<Insertuser> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _role = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> exitingusername = [];
  String ? selectrole;
  List<String> listrole = ['petugas', 'admin'];
  
  Future<void> user() async {
    if (_formKey.currentState!.validate()) {
      final username = _username.text.trim();
      final password = _password.text.trim();
      final role = _role.text.trim();

      try {
        final response = await Supabase.instance.client.from('user').insert({
              'Username': username,
              'Password': password,
              'Role': role
            });

        if (response.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tidak berhasil menambahkan user')));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePagePetugas()));
        }
      } catch (e) {
        Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePagePetugas()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Tambah User'),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: _username,
                decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectrole,
                decoration: InputDecoration(
                  labelText: 'Pilih Role',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                items: listrole.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectrole = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Silakan pilih role';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: user, child: Text('Tambah'))
            ],
          ),
        ),
      ),
    );
  }
}