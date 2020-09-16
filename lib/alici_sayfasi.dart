import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'seyyar_bilgiler.dart';

class ALICI_SAYFASI extends StatefulWidget {
  @override
  _ALICI_SAYFASIState createState() => _ALICI_SAYFASIState();
}

class _ALICI_SAYFASIState extends State<ALICI_SAYFASI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ALICI SAYFASI"),
      ),
      body: ALICI_BODY(),
    );
  }
}

class ALICI_BODY extends StatefulWidget {
  @override
  _ALICI_BODYState createState() => _ALICI_BODYState();
}

class _ALICI_BODYState extends State<ALICI_BODY> {
  List<String> litems = [""];

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      Seyyar_Isimleri_Cek();
    });
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: litems.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text('${litems[index]}'),
                  onTap: ()
                  {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SEYYAR_BILGILER(litems[index])));
                  },
                ),
              );
            },
          ),
        ),

      ],
    );
  }
  Future<String> Seyyar_Isimleri_Cek() async
  {
    var url ="http://192.168.1.106:3000/api/";

    url=url+"seyyarIsimleriCek";


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
   //  print(litems);
  }

}

































/*class ALICI_SAYFASI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ALICI"),
      ),
      body: ALICI_BODY(),
    );
  }
}

class ALICI_BODY extends StatefulWidget {
  @override
  _ALICI_BODYState createState() => _ALICI_BODYState();
}

class _ALICI_BODYState extends State<ALICI_BODY> {
  List<String> litems = [];
  List<String> konumlar = [];
  List<String> adresler = [];
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      Seyyar_Isimleri_Cek();
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      for(var i = 0; i<litems.length; i++)
      {
        Konumlari_Cek(litems[i]);
      }
       print(litems.toString()+" isimleri yolladım");

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
          child: Text("assadsa"),
          onPressed: (){
           // Konumlari_Cek("kasap")

              print(adresler);
          },
        )
      ],
    );
  }
  Future<String> Seyyar_Isimleri_Cek() async
  {
    var url ="http://192.168.1.108:3000/api/";

    url=url+"seyyarIsimleriCek";


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
     // print(litems);
  }

  Future<String> Konumlari_Cek(String isim) async
  {
    var url ="http://192.168.1.108:3000/api/";

    url=url+"seyyarKonumlari/"+isim;


    var responce =await http.get(Uri.encodeFull(url),
        headers: {
          "Accept":"application/json"
        }
    );
    //var donenMSJ=
    var list = json.decode(responce.body);

    konumlar.clear();
    adresler.clear();
    for( var i in list)
    {
      konumlar.add(i.toString());
    }
    print(konumlar.toString()+"asdsadasd");


    final coordinates = new Coordinates(double.parse(konumlar[0]),double.parse(konumlar[1]));
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    adresler.add(first.featureName+" "+first.addressLine);

  }
  Future<Position> pozisyon() async
  {

  }

}    */

