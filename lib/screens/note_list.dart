import 'package:flutter/material.dart';

import 'note_details.dart';

class NoteList extends StatefulWidget {


  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
            debugPrint('FAB Clicked');
            navigateToDetail('Add Note');
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }
  ListView getNoteListView(){
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        return  Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.keyboard_arrow_right),

            ),
            title: const Text('Dummy Title'),
            subtitle: const Text('Dummy Date'),
            trailing: Icon(Icons.delete,color: Colors.grey,),
            onTap: (){
              debugPrint("ListTile Tapped");
               navigateToDetail('Edit Note');
            },

          ),

        );
      },
    );

  }

  void navigateToDetail(String title){
 Navigator.push(context, MaterialPageRoute(builder: (context){
   return NoteDetail(title);
 }));
  }
}
