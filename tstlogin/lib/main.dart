import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imei_plugin/imei_plugin.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tstlogin/register.dart';
import 'login.dart';

void main()=>runApp(MaterialApp(
  title: "Login",
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    primarySwatch: Colors.red,
  ),
  home: Home(),
));

class Home extends StatefulWidget {
  final String username;

  Home({this.username});
  @override

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _timeString='';
  String _login='';
  String _message='';
  String usernamee="";
  String imei;


  @override
  void initState(){
    _timeString = "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    Timer.periodic(Duration(seconds:1), (Timer t)=>_getCurrentTime());
    super.initState();

    _incrementStartup();
  }
  void _getCurrentTime()  {
    setState(() {
      _timeString = "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    });
  }

  Future<void> _incrementStartup() async{
    final prefs = await SharedPreferences.getInstance();
    String lastUsername = await _getIntFromSharedPref();
    if(widget.username==null){
      usernamee=lastUsername;
    }else{
      usernamee = widget.username;
    }
    prefs.setString("username", usernamee);
    imei = await ImeiPlugin.getImei();
    if(imei=="")
      imei="0";
  }
  Future<String> _getIntFromSharedPref() async{
    final prefs = await SharedPreferences.getInstance();
    final username= prefs.getString('username');
    if(username==null){
      return "";
    }
    return username;
  }





  void Hello() async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString('username')==""){
      Fluttertoast.showToast(
          msg: "Silahkan login terlebih dahulu",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context)=>login(imei: imei)));
    }else if(usernamee!=""){
      final response = await http.get("http://192.168.0.9/testlogin/getdata.php");
      List list = json.decode(response.body);
      int index = -1;
      for(int i =0;i<list.length;i++){
        if(usernamee==list[i]["username"])
          index = i;
      }
      if(imei==list[index]["loginstate"]){

        String asd =  list[index]["logintime"];

        _login = asd.substring(0,2)+":"+asd.substring(2,4)+":"+asd.substring(4,6);
        _message = "hai "+usernamee+" anda login pada "+_login;
        Fluttertoast.showToast(
            msg: _message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }else{
        Fluttertoast.showToast(
            msg: "Alat lain telah login",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context)=>login(imei: imei)));
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home " + _timeString),
        ),

        body: ListView(
        children: <Widget>[
          MaterialButton(
            child: Text("Hello "+ usernamee),
            onPressed: (){
              Hello();
              Fluttertoast.showToast(
                  msg: _message,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

            },
          )
          ]
        )
    );
  }
}



