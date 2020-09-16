import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'alici_sayfasi.dart';
import 'giris_yap.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[600],

          // Define the default font family.
          fontFamily: 'Georgia',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
      home: MyHomePage(title: 'Seyyar Satıcı Uygulamasi'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  final kullaniciAdiController = TextEditingController();
  final sifreController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    kullaniciAdiController.dispose();
    sifreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Text("SATICI İSENİZ ÜYE OLUNUZ",style: TextStyle(color: Colors.amberAccent,fontSize: 15.00,fontStyle: FontStyle.normal)),
          Container(
            margin: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Isminizi Giriniz'),
                  controller: kullaniciAdiController,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Sifrenizi Giriniz',),
                  controller: sifreController,
                ),
                RaisedButton(
                  color: Colors.deepOrange,
                  child: Text("UYE OL"),
                  onPressed: () {
                    UYE_OLl(kullaniciAdiController.text,sifreController.text);
                  },
                ),
                RaisedButton(
                  color: Colors.deepOrange,
                  child: Text("GIRIS YAP"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GirisYapSayfasi()),
                    );
                  },
                ),
                RaisedButton(
                  color: Colors.deepOrange,
                  child: Text("ALICI'YIM  ->"),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ALICI_SAYFASI()),
                    );
                  },
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
  Future<String> UYE_OLl(String isim,String sifre) async{
    var url ="http://192.168.1.106:3000/api/";

    url=url+"seyyarOlustur"+"/"+isim+"/"+sifre;


    var responce =await http.get(Uri.encodeFull(url),
        headers: {
          "Accept":"application/json"
        }
    );

    /*  List data=json.decode(responce.body);
    print(data[0]["title"]);*/
    var x=responce.body;


    kullaniciAdiController.text="";
    sifreController.text="";

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GirisYapSayfasi()),
    );
  }
}
