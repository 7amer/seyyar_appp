import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
class SEYYAR_BENI_CAGIRANLAR extends StatefulWidget {
  @override
  _SEYYAR_BENI_CAGIRANLARState createState() => _SEYYAR_BENI_CAGIRANLARState();
}

class _SEYYAR_BENI_CAGIRANLARState extends State<SEYYAR_BENI_CAGIRANLAR> {
  String isim="assdasa";

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(isim.toUpperCase()+" BENI CAGIRANLAR"),
      ),
      body: SEYYAR_BENI_CAGIRANLAR_BODY(),
    );
  }
}
class SEYYAR_BENI_CAGIRANLAR_BODY extends StatefulWidget {
  @override
  _SEYYAR_BENI_CAGIRANLAR_BODYState createState() => _SEYYAR_BENI_CAGIRANLAR_BODYState();
}

class _SEYYAR_BENI_CAGIRANLAR_BODYState extends State<SEYYAR_BENI_CAGIRANLAR_BODY> {
  List<String> litems = [];
  List<String> adresler = [];
  var isim="";
  int sayac;

  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => pageLoad());
  }


  @override
  Widget build(BuildContext context) {
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
            itemCount: adresler.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${adresler[index]}'),
                onTap: (){
                 if(index==0)
                   {
                     _launchMapsUrl(double.parse(litems[0]),double.parse(litems[1]));
                   }
                  else{
                   _launchMapsUrl(double.parse(litems[index+1]),double.parse(litems[index+2]));
                 }
                },
              );
            },
          ),
        ),
        /*RaisedButton(
          child: Text("konumlari al"),
          onPressed: (){
            adresler.clear();
            litems.clear();
            Seyyari_Cagiranlari_Cek();
          },
        ),*/
      ],
    );
  }
  Future<String> Seyyari_Cagiranlari_Cek() async
  {

    List<String> yedek;
    int lat,long;
    var url ="http://192.168.1.106:3000/api/";

    url=url+"seyyariCagiranlar/"+isim;



    var responce =await http.get(Uri.encodeFull(url),
        headers: {
          "Accept":"application/json"
        }
    );
    //var donenMSJ=
    var list = json.decode(responce.body);
    //print(list["LAT"]);

    for( var i in list)
    {
      litems.add(i.toString());
    }
    print(litems.sublist(0,2));


    for(int i=0; i<litems.length; i++)
      {
        if(i%2!=0)
          {
            final coordinates = new Coordinates(double.parse(litems[i-1]),double.parse(litems[i]));

            var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
            var first = addresses.first;
          /*  print("${first.featureName} : ${first.addressLine}");
            adresler.add(first.featureName+" "+first.addressLine);*/

            print("${first.addressLine}");
            adresler.add(first.addressLine);
          }
      }
  }
  void _launchMapsUrl(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void pageLoad()
  {
    print("sadsadsa");
    Future.delayed(const Duration(milliseconds: 1000), () {
      adresler.clear();
      litems.clear();
      Seyyari_Cagiranlari_Cek();
    });

  }
}

