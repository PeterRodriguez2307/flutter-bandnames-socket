import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override  
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    List<Band> bands = [
        Band(id: '1', name: 'metalica', votes: 5),
        Band(id: '2', name: 'banda2', votes: 6),
        Band(id: '3', name: 'banda 3', votes: 3),
        Band(id: '4', name: 'banda 4', votes: 10),
    ];
    @override
    Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('BandNames', style: TextStyle(color: Colors.black87),),
            backgroundColor: Colors.white,
            elevation: 1,
        ),
        body: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (context, i) => _bandTile(bands[i])
         
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            elevation: 1,
            onPressed: addNewBand,
            ),
    );
}

    Widget _bandTile(Band band) {
      return Dismissible(
        key: Key(band.id),
        direction: DismissDirection.startToEnd,
        onDismissed: ( direction ) {
            print(direction);
        },
        background: Container(
            padding: EdgeInsets.only( left: 8.0 ),
            color: Colors.red,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Delete', style: TextStyle(color: Colors.white),
                ),
            ),
        ),
        child: ListTile(
            leading: CircleAvatar(
                child: Text( band.name.substring(0,2)),
                backgroundColor: Colors.blue[20],
            ),
            title: Text( band.name ),
            trailing: Text('${ band.votes}', style: TextStyle( fontSize: 20),),
            onTap: (){
                print(band.name);
            }, 
        )
        );
    }

    addNewBand(){

        final textController = new TextEditingController();

        if( Platform.isAndroid ){
            showDialog( // Android
            context: context, 
            builder: ( context ) {
                return AlertDialog(
                    title: Text("New band name:"),
                    content: TextField(
                        controller: textController,
                    ),
                    actions: <Widget>[
                        MaterialButton(
                            child: Text('Add'),
                            elevation: 1,
                            textColor: Colors.purple,
                            onPressed: () => addBandToList( textController.text)
                        )
                    ],
                );
            });
        }

        showCupertinoDialog(
            context: context, 
            builder: (_) {
                return CupertinoAlertDialog(
                    title: Text('New band name:'),
                    content: CupertinoTextField(
                        controller: textController,
                    ),
                    actions: <Widget>[
                        CupertinoDialogAction(
                            child: Text('Add'),
                            isDefaultAction: true,
                            onPressed: () => addBandToList( textController.text),
                        ),
                        CupertinoDialogAction(
                            child: Text('Dismiss'),
                            isDestructiveAction: true,
                            onPressed: () => Navigator.pop( context ),
                        )
                    ],
                );
            }
        );

    }

    void addBandToList( String name){
        if ( name.length > 1) {
            this.bands.add( new Band(id: DateTime.now().toString(), name: name, votes: 0));
            setState(() {
              
            });
        }
        Navigator.pop(context);
    }
}