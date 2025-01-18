import 'package:cars_frontend/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cars_frontend/controller/cars_data_download.dart';

final FlutterSecureStorage secureStorage = FlutterSecureStorage();

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  String? accessToken;
  String? userProfile;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _setupTokenListener();
  }

  Future<void> _checkLoginStatus() async {
    String? token = await secureStorage.read(key: 'accessToken');
    if (token != null) {
      setState(() {
        accessToken = token;
      });
      await _fetchUserProfile();
    }
  }

  void _setupTokenListener() {
    html.window.onMessage.listen((event) {
      final token = event.data;
      if (token != null) {
        secureStorage.write(key: 'accessToken', value: token);
        setState(() {
          accessToken = token;
        });
        _fetchUserProfile();
      }
    });
  }

  Future<void> _fetchUserProfile() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/profile'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      setState(() {
        userProfile = response.body;
      });
    } else {
      setState(() {
        userProfile = 'Failed to fetch user profile';
      });
    }
  }

  Future<void> _logout() async {
    await secureStorage.delete(key: 'accessToken');
    setState(() {
      accessToken = null;
      userProfile = null;
    });
    html.window.open('http://localhost:3000/logout', '_self');
  }

  @override
  Widget build(BuildContext context) {
    // Postavljanje meta podataka
    html.document.title = 'Start page'; 
    html.MetaElement description = html.MetaElement(); 
    description.name = 'Vedran Lugarić'; 
    description.content = 'Pocetna stranica'; 
    html.document.head?.append(description);

    return Scaffold(
      body: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Dobro došli!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Udite u predivan svijet atomobila i autoindustrije',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 40),
            accessToken == null
                ? ElevatedButton(
                    onPressed: () {
                      html.window.open('http://localhost:3000/login', '_blank');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellowAccent,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('Prijava'),
                  )
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: ()  {
                          html.window.open('http://localhost:3000/profile', '_self');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellowAccent,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text('Profil'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellowAccent,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text('Odjava'),
                      ),
                      SizedBox(height: 20),
                      DownloadButtonsOsvjezi(),
                      
                    ],
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _redirectToHomePage(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellowAccent,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text('Pretraga dostupne automobile'),
            )
          ],
        ),
      ),
    );
  }

  void _redirectToHomePage(final BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  void _redirectToProfilePage(final BuildContext context) {
    if (userProfile != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProfilePage(profilJson: userProfile!)),
      );
    } else {
      _showErrorDialog(context, 'Nije moguće dohvatiti profil.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dogodila se greška'),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String profilJson;

  const ProfilePage({Key? key, required this.profilJson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body: Center(
        child: Text(profilJson),
      ),
    );
  }
}
