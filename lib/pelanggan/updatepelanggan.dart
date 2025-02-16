import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/homepage.dart';

class UpdatePelanggan extends StatefulWidget {
  final int PelangganID;

  const UpdatePelanggan({super.key, required this.PelangganID});
  
  @override
  State<UpdatePelanggan> createState() => _UpdatePelangganState();
}

class _UpdatePelangganState extends State<UpdatePelanggan> {
  final _nmp = TextEditingController();
  final _alm = TextEditingController();
  final _ntp = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tampilpelanggan();
  }

  Future<void> tampilpelanggan() async{
    final pelanggan = await Supabase.instance.client.from('pelanggan').select().eq('PelangganID', widget.PelangganID).single();
    setState(() {
      _nmp.text = pelanggan['NamaPelanggan'] ?? '';
      _alm.text = pelanggan['Alamat'] ?? '';
      _ntp.text = pelanggan['NomorTelepon'] ?? '';
    });
  }

  Future<void> UpdatePelanggan() async{
    if(_formKey.currentState!.validate()){
     
    }
    await Supabase.instance.client.from('pelanggan').update({
      'NamaPelanggan': _nmp.text,
      'Alamat': _alm.text,
      'NomorTelepon': _ntp.text,
    }).eq('PelangganID', widget.PelangganID);
   
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homepage())
      
    );
    

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Form Update Pelanggan'),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nmp,
                decoration: InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'username tidak boleh kosong';
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
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
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
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                maxLength: 12,
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return ('username tidak boleh kosong');
                  } if(value.length > 12 ){
                    return 'tidak boleh lebih dari 12 angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: (){
               UpdatePelanggan();
              }, child: Text('update'))
            ],
          )
        ),
      )
    );
  }
}