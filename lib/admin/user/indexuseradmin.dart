import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/admin/user/insertuser.dart';
import 'package:ukk_2025/admin/user/updateuser.dart';

class IndexUseradmin extends StatefulWidget {
  const IndexUseradmin({super.key});

  @override
  State<IndexUseradmin> createState() => _IndexUseradminState();
}

class _IndexUseradminState extends State<IndexUseradmin> {
  List<Map<String, dynamic>> user = [];

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchuser();
  }
  
  Future<void> deleteuser(int id) async{
    try{
    await Supabase.instance.client.from('user').delete().eq('UserID', id);
    fetchuser();
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('error $e')));
    }

  }

  Future<void> fetchuser() async{
    try{
    final response = await Supabase.instance.client.from('user').select();
    setState(() {
      user = List<Map<String, dynamic>>.from(response);
     
    });
    } catch(e){
      print('error $e');
      
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user.isEmpty
          ? Center(
            child: Text('Data user belum ditambahkan'),
          )
          :ListView.builder(
              itemCount: user.length,
              itemBuilder: (context, index){
                final usr = user[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username: ${usr['Username'] ?? 'tidak tersedia'}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text('Password: ${usr['Password']?.toString() ?? 'Tidak tersedia'}',
                            style: TextStyle( fontSize: 18),),
                            SizedBox(width: 1000),
                            IconButton(onPressed: (){
                              final UserID = usr['UserID'];
                              if(UserID != 0){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UpdateUserAdmin(UserID: UserID)));
                              }
                            }, icon: Icon(Icons.edit, color: Colors.blue,)),
                            IconButton(onPressed: (){
                              showDialog(
                                context: context, builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text('Hapus pelanggan'),
                                    content: Text('Apakah anda yakin menghapus use ini?'),
                                    actions: [
                                      ElevatedButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: Text('Batal')),
                                      ElevatedButton(onPressed: (){
                                        deleteuser(usr['UserID']); 
                                        Navigator.pop(context);
                                      }, child: Text('Hapus'))
                                    ],
                                  );
                                }
                              );
                            }, icon: Icon(Icons.delete, color: Colors.red,))
                          ]
                        ),
                        SizedBox(height: 8),
                        Text('Role: ${usr['Role']?.toString() ?? 'tidak tersedia'}',
                        style: TextStyle( fontSize: 16),),
                      ],
                    ),
                  ),
                );
              },
            ),
          
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InsertUserAdmin()));
      }, child: Icon(Icons.add)),
    );
  }
}