import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/petugas/homepagepetugas.dart';
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
  String ? selectrole;
  List<String> listrole = ['petugas', 'admin'];

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
   
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePagePetugas())
      
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
              DropdownButtonFormField<String>(
                value: selectrole,
                decoration: InputDecoration(
                  labelText: 'Pilih Role',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                items: listrole.map((String listrole) {
                  return DropdownMenuItem<String>(
                    value: listrole,
                    child: Text(listrole),
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