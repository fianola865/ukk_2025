import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/admin/homepageadmin.dart';

class UpdatePelangganAdmin extends StatefulWidget {
  final int PelangganID;

  const UpdatePelangganAdmin({super.key, required this.PelangganID});
  
  @override
  State<UpdatePelangganAdmin> createState() => _UpdatePelangganAdminState();
}

class _UpdatePelangganAdminState extends State<UpdatePelangganAdmin> {
  final _nmp = TextEditingController();
  final _alm = TextEditingController();
  final _ntp = TextEditingController();
  final _rl = TextEditingController();
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
      _rl.text = pelanggan['member'] ?? '';
    });
  }

  Future<void> UpdatePelangganAdmin() async{
    if(_formKey.currentState!.validate()){
     
    }
    await Supabase.instance.client.from('pelanggan').update({
      'NamaPelanggan': _nmp.text,
      'Alamat': _alm.text,
      'NomorTelepon': _ntp.text,
      'member': _rl.text
    }).eq('PelangganID', widget.PelangganID);
   
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePageAdmin())
      
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
              SizedBox(height: 8),
              TextFormField(
                controller: _rl,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Role tidak boleh kosong';
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
                  if (int.tryParse(value) == null) {
                    return 'Harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: (){
               UpdatePelangganAdmin();
              }, child: Text('update'))
            ],
          )
        ),
      )
    );
  }
}