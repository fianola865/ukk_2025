import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/admin/homepageadmin.dart';

class InsertPelangganAdmin extends StatefulWidget {
  const InsertPelangganAdmin({super.key});

  @override
  State<InsertPelangganAdmin> createState() => _InsertPelangganAdminState();
}

class _InsertPelangganAdminState extends State<InsertPelangganAdmin> {
  final _nmp = TextEditingController();
  final _alm = TextEditingController();
  final _ntp = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> user() async {
    if (_formKey.currentState!.validate()) {
      final nmp = _nmp.text;
      final alm = _alm.text;
      final ntp = _ntp.text;

      try {
        final response = await Supabase.instance.client.from('pelanggan').insert({
              'NamaPelanggan': nmp,
              'Alamat': alm,
              'NomorTelepon': ntp
            });

        if (response.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tidak berhasil menambahkan user')));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePageAdmin()));
        }
      } catch (e) {
        Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePageAdmin()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Tambah Pelanggan'),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nmp,
                decoration: InputDecoration(
                    labelText: 'Nama Pelanggan',
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
                controller: _alm,
                decoration: InputDecoration(
                    labelText: 'Alamat',
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
                controller: _ntp,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Nomor Telepon',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
                maxLength: 12,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'tidak boleh kosong';
                  }
                  if (value.length > 12) {
                    return 'tidak boleh lebih dari 12';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harus berupa angka';
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
