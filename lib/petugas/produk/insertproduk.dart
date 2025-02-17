import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/petugas/homepagepetugas.dart';

class insertProduk extends StatefulWidget {
  const insertProduk({super.key});

  @override
  State<insertProduk> createState() => _insertProdukState();
}

class _insertProdukState extends State<insertProduk> {
  final _np = TextEditingController();
  final _hr = TextEditingController();
  final _st = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> user() async {
    if (_formKey.currentState!.validate()) {
      final np = _np.text;
      final hr = _hr.text;
      final st = _st.text;

      try {
        final response = await Supabase.instance.client.from('produk').insert({
              'NamaProduk': np,
              'Harga': hr,
              'Stok': st
            });

        if (response.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tidak berhasil menambahkan produk')));
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
        title: Text('Form Tambah Produk'),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: _np,
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
                controller: _hr,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Harga',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _st,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Stok',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
                maxLength: 12,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'tidak boleh kosong';
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
