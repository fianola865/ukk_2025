import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/user/insertuser.dart';
import 'package:ukk_2025/user/updateuser.dart';

class IndexUser extends StatefulWidget {
  const IndexUser({super.key});

  @override
  State<IndexUser> createState() => _IndexUserState();
}

class _IndexUserState extends State<IndexUser> {
  List<Map<String, dynamic>> User = [];

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user();
  }
  
  Future<void> deleteuser(int id) async{
    try{
    await Supabase.instance.client.from('user').delete().eq('UserID', id);
    user();
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('error $e')));
    }

  }

  Future<void> user() async{
    try{
    final response = await Supabase.instance.client.from('user').select();
    setState(() {
      User = List<Map<String, dynamic>>.from(response);
     
    });
    } catch(e){
      print('error $e');
      
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: User.isEmpty
          ? Center(
            child: Text('Data user belum ditambahkan'),
          )
          :ListView.builder(
              itemCount: User.length,
              itemBuilder: (context, index){
                final user = User[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username: ${user['Username'] ?? 'tidak tersedia'}'),
                        Text('Password: ${user['Password'] ?? 'Tidak tersedia'}'),
                        Text('Role: ${user['Role'] ?? 'tidak tersedia'}'),
                        Row(
                          children: [
                            IconButton(onPressed: (){
                              final UserID = user['UserID'];
                              if(UserID != 0){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UpdateUser(UserID: UserID)));
                              }
                            }, icon: Icon(Icons.edit)),
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
                                        deleteuser(user['UserID']); 
                                        Navigator.pop(context);
                                      }, child: Text('Hapus'))
                                    ],
                                  );
                                }
                              );
                            }, icon: Icon(Icons.delete))
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Insertuser()));
      }, child: Icon(Icons.add)),
    );
  }
}