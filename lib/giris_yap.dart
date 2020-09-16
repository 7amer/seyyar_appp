import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'satici_anasayfa.dart';

class GirisYapSayfasi extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giris Yap"),
      ),
      body:MyBody(),
    );
  }
}
class MyBody extends StatefulWidget {
  @override
  _MyBodyState createState() => _MyBodyState();
}
class _MyBodyState extends State<MyBody> {
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
    return Column(
      children: <Widget>[
        Text("GIRIS YAPINIZ"),
        TextFormField(
          decoration: InputDecoration(labelText: 'Isminizi Giriniz'),
          controller: kullaniciAdiController,
        ),
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(labelText: 'Sifrenizi Giriniz'),
          controller: sifreController,
        ),
        RaisedButton(
          color: Colors.deepOrange,
          child: Text("GIRIS YAP"),
          onPressed: () {
            GIRIS_YAP(kullaniciAdiController.text, sifreController.text);
            Future<SharedPreferences> prefs = SharedPreferences.getInstance();
            prefs.then(
                    (pref) {
                  //call functions like pref.getInt(), etc. here

                  pref.setString("ISIM", kullaniciAdiController.text);
                }
            );
          },
        ),
      ],
    );
  }

  Future<String> GIRIS_YAP(String isim,String sifre) async{


    var url ="http://192.168.1.106:3000/api/";

    url=url+"seyyarGirisYap"+"/"+isim+"/"+sifre;
    var responce =await http.get(Uri.encodeFull(url),
        headers: {
          "Accept":"application/json"
        }
    );

    /*  List data=json.decode(responce.body);
    print(data[0]["title"]);*/
    String donenMSJ=responce.body;
    String match="match";
  /*  Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(donenMSJ),
    ));*/



    kullaniciAdiController.text="";
    sifreController.text="";

     print(donenMSJ.substring(1,donenMSJ.length-1)=="match");

    if(donenMSJ.substring(1,donenMSJ.length-1)=="match")
      {
        print("burdayim");
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Giris Yapılıyor"),
        ));
        Future.delayed(const Duration(milliseconds: 1000), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SATICI_ANASAYFA()),
          );
        });
      }
    else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Giris Bilgilerinizi Kontrol Ediniz"),
      ));
    }





  }




}