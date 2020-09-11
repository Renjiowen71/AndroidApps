import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'main.dart';
import 'register.dart';

class login extends StatefulWidget {
  String imei;

  login({this.imei});

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  TextEditingController cusername = new TextEditingController();
  TextEditingController cpassword = new TextEditingController();




  void validateData() async{
    bool validate = false;
    final response = await http.get("http://192.168.0.9/testlogin/getdata.php");
    List list = json.decode(response.body);
    for(int i =0;i<list.length;i++){
      if(cusername.text==list[i]['username'] && cpassword.text == list[i]['password']){
        validate = true;
      }
    }
    if(validate){
      updateData();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context)=>Home(username: cusername.text)));
    }else{
      Fluttertoast.showToast(
          msg: "Kombinasi username dan login salah",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

  }

  void updateData(){
    var url = "http://192.168.0.9/testlogin/editdata.php";
    http.post(url,body:{
      "username": cusername.text,
      "logintime": (DateTime.now().hour*10000+DateTime.now().minute*100+DateTime.now().second).toString(),
      "loginstate": widget.imei,
    });
    Fluttertoast.showToast(
        msg: "Login Berhasil",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
          MaterialButton(
            child: Text("Log In"),
            color: Colors.redAccent,
            onPressed: (){
              validateData();
            },
          ),
          MaterialButton(
            child: Text("Register"),
            color: Colors.redAccent,
            onPressed: ()=>Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context)=>register(imei: widget.imei))),
          )
        ],
      ),
    );
  }
}
