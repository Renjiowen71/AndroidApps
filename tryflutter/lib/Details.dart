import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart'as http;
import 'dart:convert';

import 'Edit.dart';
import 'main.dart';

class Details extends StatefulWidget {
  List list;
  int index;

  Details({this.list,this.index});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  void delete(){
    var url = 'http://192.168.0.9/myfolder/deletedata.php';
    http.post(url,body: {
      'id': widget.list[widget.index]['id']
    });
  }


  void confirm(){
    AlertDialog alert = new AlertDialog(
      content: Text("Are You Sure?"),
      actions: <Widget>[
        MaterialButton(
          child: Text("Ok"),
          onPressed: (){
            delete();
            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context)=>Home()));
          },
        ),
        MaterialButton(
          child: Text("Cancel"),
          onPressed: ()=>Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context)=>Home())
          ),
        )
      ],
    );
    showDialog(context: context, child: alert);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.list[widget.index]['name']}"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text(
              widget.list[widget.index]['name'],
              style: TextStyle(
                  fontSize: 20.0
              ),
            ),
            Text(
              widget.list[widget.index]['mobile'],

            ),
            MaterialButton(
              child: Text("EDIT"),
              color: Colors.deepOrangeAccent,
              onPressed: ()=>Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context)=>Edit(list:widget.list,index:widget.index))
              ),
            ),
            MaterialButton(
              child: Text("DELETE"),
              color: Colors.deepOrangeAccent,
              onPressed: ()=>confirm(),
            ),
          ],
        ),
      ),
    );
  }
}
