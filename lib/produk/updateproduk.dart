import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/homepage.dart';

class UpdateProduk extends StatefulWidget {
  final int ProdukID;

  const UpdateProduk({super.key, required this.ProdukID});
  
  @override
  State<UpdateProduk> createState() => _UpdateProdukState();
}

class _UpdateProdukState extends State<UpdateProduk> {
  final _np = TextEditingController();
  final _st = TextEditingController();
  final _hr = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tampilpelanggan();
  }

  Future<void> tampilpelanggan() async{
    final pelanggan = await Supabase.instance.client.from('produk').select().eq('ProdukID', widget.ProdukID).single();
    setState(() {
      _np.text = pelanggan['NamaProduk'] ?? '';
      _hr.text = pelanggan['Harga']?.toString() ?? '';
      _st.text = pelanggan['Stok']?.toString() ?? '';
    });
  }

  Future<void> UpdateProduk() async{
    if(_formKey.currentState!.validate()){
     
    }
    await Supabase.instance.client.from('produk').update({
      'NamaProduk': _np.text,
      'Harga': _hr.text,
      'Stok': _st.text,
    }).eq('ProdukID', widget.ProdukID);
   
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homepage())
      
    );
    

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Form Update Produk'),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _np,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
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
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'tidak boleh kosong';
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
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                maxLength: 12,
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return ('tidak boleh kosong');
                  } 
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: (){
               UpdateProduk();
              }, child: Text('update'))
            ],
          )
        ),
      )
    );
  }
}