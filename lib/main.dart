import 'package:band_names/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/pages/home.dart';
import 'package:band_names/pages/status.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => SocketService(),)
      ],
      child: MaterialApp(
          title: "Material App",
          initialRoute: 'home',
          routes: {
            'home': ( _ ) => HomePage(),
            'status': ( _ ) => StatusPage()
          },
        ),
    );
  }
  
}