import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:seyyar_app/seyyar_beni_cagiranlar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bilgilerimi_duzenle_seyyar.dart';

class SATICI_ANASAYFA extends StatefulWidget {
  @override
  _SATICI_ANASAYFAState createState() => _SATICI_ANASAYFAState();
}
class _SATICI_ANASAYFAState extends State<SATICI_ANASAYFA> {
  int _currenIntext=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SATICI ANASAYFA"),
      ),
      body: MYBODY(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currenIntext,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Ana Sayfa"),
              backgroundColor: Colors.blue
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            title: Text("Bilgilerimi Düzenle"),
            backgroundColor: Colors.amberAccent,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              title: Text("Beni Cagıranlar"),
              backgroundColor: Colors.green,
          ),
        ],
        onTap: (index){
          setState(() {
            _currenIntext=index;
          });
          if(index==1)
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BILGILERIMI_DUZENLE_SEYYAR()),
              );
            }
          if(index==2)
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SEYYAR_BENI_CAGIRANLAR()),
              );
            }
        },
      ),
    );
  }
}

class MYBODY extends StatefulWidget {
  @override
  _MYBODYState createState() => _MYBODYState();
}
class _MYBODYState extends State<MYBODY> {
  final urunEkleController = TextEditingController();
  var isim="";
  Position SeyyarPosition;

  List<String> litems = [];
  // final items = List<String>.generate(10000, (i) => "Item $i");


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    urunEkleController.dispose();
    super.dispose();
  }



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
        TextFormField(
          decoration: InputDecoration(labelText: 'Urunlerinizi Giriniz'),
          controller: urunEkleController,
          onFieldSubmitted:(urun){
            litems.clear();
            Urunleri_Database_yaz(urun);
            urunEkleController.text="";
            Future.delayed(const Duration(milliseconds: 1000), () {
              Urunleri_Cek();
            });


            /*    litems.clear();
            litems.add("y");*/
          },
        ),
        RaisedButton(
          color: Colors.deepOrange,
          child: Text("KONUM PAYLAS"),
          onPressed: () {
            setState(() {
            });
            //_launchMapsUrl(41.015137,28.979530);
            pozisyon();
            Future.delayed(const Duration(milliseconds: 1000), () {
              Seyyar_Pozisyon_Guncelle();
            });
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("KONUMUNUZ PAYLASILDI"),
            ));
          },
        ),
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
      ],
    );
  }
  Future<String> Urunleri_Database_yaz(String urun) async
  {
    var url ="http://192.168.1.106:3000/api/";

    url=url+"seyyarUrunEkle"+"/"+isim+"/"+urun;


    var responce =await http.get(Uri.encodeFull(url),
        headers: {
          "Accept":"application/json"
        }
    );
    var donenMSJ=responce.body;




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
  //  print(isim);
  }


  void _launchMapsUrl(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Position> pozisyon() async
  {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    SeyyarPosition=position;
    print(SeyyarPosition.longitude.toStringAsFixed(2));

    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
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


}