import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tstlogin/login.dart';

class register extends StatefulWidget {
  final String imei;
  register({this.imei});
  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  String username;
  @override
  TextEditingController cusername = new TextEditingController();
  TextEditingController cpassword = new TextEditingController();
  TextEditingController cpassword2 = new TextEditingController();
  void addData(){

    if(cpassword.text==cpassword2.text) {
      var url = "http://192.168.0.9/testlogin/adddata.php";
      http.post(url, body: {
        "username": cusername.text,
        "password": cpassword.text,
        "logintime": (DateTime
            .now()
            .hour * 10000 + DateTime
            .now()
            .minute * 100 + DateTime
            .now()
            .second).toString(),
        "loginstate": "",
      });
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) =>
              login(imei: widget.imei)));
    } else{
      Fluttertoast.showToast(
          msg: "Password yang dikonfirmasi tidak sama",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            controller: cusername,
            decoration: InputDecoration(hintText: "Enter Username", labelText: "Enter Username"),
          ),
          TextField(
            controller: cpassword,
            decoration: InputDecoration(hintText: "Enter Password", labelText: "Enter Password"),
          ),
          TextField(
            controller: cpassword2,
            decoration: InputDecoration(hintText: "Konfirmasi Password", labelText: "Konfirmasi Password"),
          ),
          MaterialButton(
            child: Text("Register"),
            color: Colors.redAccent,
            onPressed: (){
              addData();

            },
          )
        ],
      ),
    );
  }
}
