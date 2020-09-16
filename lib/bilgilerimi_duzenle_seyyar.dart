import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'satici_anasayfa.dart';

class BILGILERIMI_DUZENLE_SEYYAR extends StatefulWidget {
  @override
  _BILGILERIMI_DUZENLE_SEYYARState createState() => _BILGILERIMI_DUZENLE_SEYYARState();
}

class _BILGILERIMI_DUZENLE_SEYYARState extends State<BILGILERIMI_DUZENLE_SEYYAR> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SATICI BILGILERI DUZENLE"),
      ),
      body: DUZENLE_BODY(),
    );
  }
}
class DUZENLE_BODY extends StatefulWidget {
  @override
  _DUZENLE_BODYState createState() => _DUZENLE_BODYState();
}

class _DUZENLE_BODYState extends State<DUZENLE_BODY> {
  var isim="";
  var urun="";
  Position SeyyarPosition;
  List<String> litems = [];
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      Urunleri_Cek();
    });
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then(
            (pref)
        {
          //call functions like pref.getInt(), etc. here
          setState(() {
            isim=  pref.getString("ISIM");
          });
        }
    );
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: litems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${litems[index]}'),
                onTap: ()
                {
                  setState(() {
                    urun=litems[index].toUpperCase();
                  });
                  /*Future.delayed(const Duration(milliseconds: 10000), () {
                   setState(() {
                     urun="";
                   });
                  });*/
                },
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.all(60.0),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
            children: <Widget>[
              RaisedButton(
                color: Colors.deepOrange,
                child: Text("SIL   "+urun),
                onPressed: () {
                  URUNSIL();
                  setState(() {
                    urun="";
                  });
                },
              ),
              RaisedButton(
                color: Colors.deepPurple,
                child: Text("KONUM GUNCELLE"),
                onPressed: (){
                  pozisyon();
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    Seyyar_Pozisyon_Guncelle();
                  });
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("KONUMUNUZ GUNCELLENDI"),
                  ));
                },
              )
            ],
          ),
        ),

      ],
    );
  }
  Future<String> Urunleri_Cek() async
  {
    var url ="http://192.168.1.106:3000/api/";

    url=url+"seyyarUrunleriCek"+"/"+isim;


    var responce =await http.get(Uri.encodeFull(url),
        headers: {
          "Accept":"application/json"
        }
    );
    //var donenMSJ=
    var list = json.decode(responce.body);

    litems.clear();
    for( var i in list)
    {
      litems.add(i);
    }
  }

  Future<String> URUNSIL() async {
    var url ="http://192.168.1.106:3000/api/";

    url=url+"urunSil"+"/"+isim+"/"+urun;

    var responce =await http.get(Uri.encodeFull(url),
        headers: {
          "Accept":"application/json"
        }
    );
    var donenMSJ=responce.body;
  }

  Future<String> Seyyar_Pozisyon_Guncelle() async
  {
    var url ="http://192.168.1.106:3000/api/";

    url=url+"seyyarKonumGuncelle"+"/"+isim+"/"+SeyyarPosition.latitude.toStringAsFixed(3)+"/"+SeyyarPosition.longitude.toStringAsFixed(3);


    var responce =await http.get(Uri.encodeFull(url),
        headers: {
          "Accept":"application/json"
        }
    );
    var donenMSJ=responce.body;
  }
  Future<Position> pozisyon() async
  {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    SeyyarPosition=position;
    print(SeyyarPosition.longitude.toStringAsFixed(2));
  }
}

