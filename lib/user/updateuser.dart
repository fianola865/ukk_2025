import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/homepage.dart';
class UpdateUser extends StatefulWidget {
  final int UserID;

  const UpdateUser({super.key, required this.UserID});
  
  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _role = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tampiluser();
  }

  Future<void> tampiluser() async{
    final user = await Supabase.instance.client.from('user').select().eq('UserID', widget.UserID).single();
    setState(() {
      _username.text = user['Username'] ?? '';
      _password.text = user['Password'] ?? '';
      _role.text = user['Role'] ?? '';
    });
  }

  Future<void> updateuser() async{
    if(_formKey.currentState!.validate()){
     
    }
    await Supabase.instance.client.from('user').update({
      'Username': _username.text.trim(),
      'Password': _password.text.trim(),
      'Role': _role.text.trim()
    }).eq('UserID', widget.UserID);
   
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homepage())
      
    );
    

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Form Update User'),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _username,
                decoration: InputDecoration(
                  labelText: 'Username',
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
                controller: _password,
                decoration: InputDecoration(
                  labelText: 'Password',
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
                controller: _role,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return ('username tidak boleh kosong');
                  } if(value != 'petugas' && value != 'admin'){
                    return 'Hanya boleh role admin dan petugas';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: (){
               updateuser();
              }, child: Text('update'))
            ],
          )
        ),
      )
    );
  }
}