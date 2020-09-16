import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
class SEYYAR_BILGILER extends StatefulWidget {
 final String isim;

  SEYYAR_BILGILER(this.isim);

  @override
  _SEYYAR_BILGILERState createState() => _SEYYAR_BILGILERState();
}

class _SEYYAR_BILGILERState extends State<SEYYAR_BILGILER> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isim+"  SATICI BILGILERI"),
      ),
      body: SEYYAR_BILGILER_BODY(widget.isim),
    );
  }
}
class SEYYAR_BILGILER_BODY extends StatefulWidget {
final String isim;

SEYYAR_BILGILER_BODY(this.isim);

  @override
  _SEYYAR_BILGILER_BODYState createState() => _SEYYAR_BILGILER_BODYState();
}

class _SEYYAR_BILGILER_BODYState extends State<SEYYAR_BILGILER_BODY> {
  List<String> litems = [];
  List<String> seyyarNeredePozisyon = [];
  Position SeyyarPosition;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      Urunleri_Cek();
    });
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: litems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${litems[index]}'),
              );
            },
          ),
        ),
        RaisedButton(
          child: Text(widget.isim+" CAGIR"),
          onPressed: (){
            pozisyon();
            Future.delayed(const Duration(milliseconds: 1000), () {
              Seyyar_Cagir();
            });
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("SEYYAR CAGIRILDI"),
            ));
          },
        ),
        RaisedButton(
          child: Text("NEREDE OLDUGUNA BAK"),
          onPressed: (){
            SeyyarKonumCek();
          },
        )
      ],
    );
  }
  Future<String> Urunleri_Cek() async
  {
    var url ="http://192.168.1.106:3000/api/";

    url=url+"seyyarUrunleriCek"+"/"+widget.isim;


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
      setState(() {
        litems.add(i);
      });
    }
    //  print(isim);
  }
  Future<Position> pozisyon() async
  {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    SeyyarPosition=position;
    print(SeyyarPosition.longitude.toStringAsFixed(2));
  }
  Future<String> Seyyar_Cagir() async
  {
    var url ="http://192.168.1.106:3000/api/";

    url=url+"seyyarCagir"+"/"+widget.isim+"/"+SeyyarPosition.latitude.toStringAsFixed(3)+"/"+SeyyarPosition.longitude.toStringAsFixed(3);


    var responce =await http.get(Uri.encodeFull(url),
        headers: {
          "Accept":"application/json"
        }
    );
    var donenMSJ=responce.body;
  }
  Future<String> SeyyarKonumCek() async
  {

    var url ="http://192.168.1.106:3000/api/";

    url=url+"seyyarKonumlari"+"/"+widget.isim;


    var responce =await http.get(Uri.encodeFull(url),
        headers: {
          "Accept":"application/json"
        }
    );
    var list = json.decode(responce.body);

    seyyarNeredePozisyon.clear();
    for( var i in list)
    {
      seyyarNeredePozisyon.add(i.toString());
    }
    print(seyyarNeredePozisyon);

    Future.delayed(const Duration(milliseconds: 1000), () {
      _launchMapsUrl(double.parse(seyyarNeredePozisyon[0]),double.parse(seyyarNeredePozisyon[1]));
    });
  }
  void _launchMapsUrl(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}



