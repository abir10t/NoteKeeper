import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';

class NoteDetail extends StatefulWidget
{
  final String  appBarTitle;
  final Note  note;

  NoteDetail(this.note,this.appBarTitle);


  @override
  State<StatefulWidget>createState()
  {
    return NoteDetailState(this.note,this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail>
{
  static var _priorities = ['Hight', 'Low'];
  DatabaseHelper helper = DatabaseHelper();

  String ? appBarTitle;
  Note note;

  final TextEditingController  titleController = TextEditingController();
 final TextEditingController  descriptionController = TextEditingController();

  NoteDetailState(this.note,this.appBarTitle);


  @override
  Widget build(BuildContext context) {

     titleController.text = note.title;
     descriptionController.text = note.description!;


    return WillPopScope(
      onWillPop: (){
        return movedToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle!),
          leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
            movedToLastScreen();
          },),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: [
              ListTile(
                title: DropdownButton(
                    items: _priorities.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    value: getPriorityAsString(note.priority),
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User selected $valueSelectedByUser');
                        updatePriorityAsInt(valueSelectedByUser.toString());
                      });
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: titleController,
                  onChanged: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateTitle();
                  },
                  decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descriptionController,
                  onChanged: (value) {
                    debugPrint('Something changed in Description Text Field');
                    updateDescription();
                  },
                  decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.deepPurple),
                        child: Text('Save',style: TextStyle(color: Colors.white),),
                        onPressed: () {
                          _save();
                        },
                      ),
                    ),
                    Container(width: 5.0,),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.deepPurple),
                        child: Text('Delete',style: TextStyle(color: Colors.white),),
                        onPressed: ()
                        {
                         setState(() {
                           debugPrint("Delete button Clicked");
                           _delete();
                         });
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  movedToLastScreen()
  {
     Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value)
  {
    switch(value)
    {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }

  }

  String? getPriorityAsString(int value)
  {
    String ? priority;
    switch(value)
    {
      case 1 :
        priority = _priorities[0]; // 'High'
        break;

      case 2 :
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  void updateTitle()
  {
     note.title = titleController!.text;
  }

  void updateDescription()
  {
     note.description = descriptionController!.text;
  }
  void _save() async
  {

    movedToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id != null) {result =  await helper.updateNote(note);}
    else {result = await helper.insertNote(note);}

    if(result !=0 ) {_showAlertDialog('status', 'Note Saves Successfully');}

    else {_showAlertDialog('status', 'problem saving note');}
  }

  void _showAlertDialog(String title, String message)
  {
    AlertDialog alterDialog = AlertDialog
      (
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alterDialog);
  }


  void _delete() async
  {
    movedToLastScreen();

    if(note.id == null)
    {
      _showAlertDialog('status', 'No Note was deleted');
      return;
    }
    
   int result =  await helper.deleteNote(note.id);

    if( result!=0 )
      _showAlertDialog('Status', 'Note Deleted Successfully');
    else
      _showAlertDialog('Status', 'Error Occured while Deleting Note');

  }


}

