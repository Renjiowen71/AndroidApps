import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart'as http;
import 'dart:convert';

import 'Details.dart';
import 'NewData.dart';

void main()=>runApp(MaterialApp(
  title: "My App Test",
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    primarySwatch: Colors.red,
  ),
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var refreshkey = GlobalKey<RefreshIndicatorState>();

  Future<Null> Refreshitme() async{
    refreshkey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      FutureBuilder<List>(
        future: getData(),
        builder: (ctx, ss){
          if(ss.hasError) {
            print("Error");
          }
          if(ss.hasData){
            return Items (list:ss.data);
          }
          else{
            return CircularProgressIndicator();
          }
        },

      );
    });
    return null;
  }

  Future<List> getData() async{
    final response = await http.get("http://192.168.0.9/myfolder/getdata.php");
    return json.decode(response.body);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My App Bar"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:()=>  Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context)=>NewData(),
          )
        ),
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        key: refreshkey,
        child: FutureBuilder<List>(
          future: getData(),
          builder: (ctx, ss){
            if(ss.hasError) {
              print("Error");
            }
            if(ss.hasData){
              return Items (list:ss.data);
            }
            else{
              return CircularProgressIndicator();
            }
          },

        ),
        onRefresh: Refreshitme,
      )
    );
  }
}

class Items extends StatelessWidget {
  List list;
  Items({this.list});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list==null?0:list.length,
        itemBuilder: (ctx,i){
          return ListTile(
            leading: Icon(Icons.message),
            title: Text(list[i]['name']),
            subtitle: Text(list[i]['mobile']),
            onTap: ()=>Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context)=>Details(list:list,index:i),
              )
            ),
          );
        }
    );
  }
}


