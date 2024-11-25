import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  @override  
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    List<Band> bands = [];

    @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handreActiveBands);
        
    
    super.initState();
    }   

    _handreActiveBands ( dynamic payload) {
        bands = (payload as List)
        .map((band) => Band.fromMap(band))
        .toList();
        setState(() {});
    }
  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context);
    socketService.socket.off('active-bands');
    super.dispose();
  }
    @override
    Widget build(BuildContext context) {
        final socketService = Provider.of<SocketService>(context);
    return Scaffold(
        appBar: AppBar(
            title: Text('BandNames', style: TextStyle(color: Colors.black87),),
            backgroundColor: Colors.white,
            elevation: 1,
            actions: <Widget>[
                Container(
                    margin: EdgeInsets.only( right: 10),
                    child: (socketService.serverStatus == ServerStatus.Online) 
                    ? Icon( Icons.check_circle, color: Colors.blue[300],)
                    : Icon( Icons.offline_bolt, color: Colors.red,)
                    ),
                
            ],
        ),
        body: Column(children: <Widget>[
            _showGraph(),
            Expanded(
              child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => _bandTile(bands[i])
              ),
            )
        ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            elevation: 1,
            onPressed: addNewBand,
            ),
    );
}

    Widget _bandTile(Band band) {
        final socketService = Provider.of<SocketService>(context, listen: false);
      return Dismissible(
        key: Key(band.id),
        direction: DismissDirection.startToEnd,
        onDismissed: ( _ ) => socketService.socket.emit('delete-band', {'id': band.id}),
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
            onTap: () => socketService.socket.emit('vote-band', {'id': band.id})
             
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

            final socketService = Provider.of<SocketService>(context, listen: false);
            socketService.socket.emit('add-band', {'name': name});
        }
        Navigator.pop(context);
    }

    Widget _showGraph(){
        Map<String, double> dataMap = new Map();
        bands.forEach((band){
            dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
        });
        return dataMap.isNotEmpty ? Container(
            height: 200,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: PieChart(
                dataMap: dataMap, 
                chartType: ChartType.ring,))
            : LinearProgressIndicator();
    }
}