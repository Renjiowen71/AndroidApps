import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart'as http;
import 'dart:convert';

import 'main.dart';

class NewData extends StatefulWidget {
  @override
  _NewDataState createState() => _NewDataState();
}

class _NewDataState extends State<NewData> {


  TextEditingController cname = new TextEditingController();
  TextEditingController cmobile = new TextEditingController();
  void addData(){


    var url = "http://192.168.0.9/myfolder/adddata.php";
    http.post(url,body:{
      "name": cname.text,
      "mobile": cmobile.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Nwe Data"),
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            controller: cname,
            decoration: InputDecoration(hintText: "Enter Name", labelText: "Enter Name"),
          ),
          TextField(
            controller: cmobile,
            decoration: InputDecoration(hintText: "Enter Mobile", labelText: "Enter Mobile"),
          ),
          MaterialButton(
            child: Text("Add Data"),
            color: Colors.redAccent,
            onPressed: (){
              addData();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context)=>Home()

                )
              );
            },
          )
        ],
      ),
    );
  }
}