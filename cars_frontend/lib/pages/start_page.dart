import 'package:flutter/material.dart';
import 'package:cars_frontend/pages/home_page.dart';
import 'package:universal_html/html.dart' as html;

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {

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
            ElevatedButton(
              onPressed: () { 
                _redirectToHomePage(context);
                Navigator.pushNamed(context, '/dataset');
              },
              style: ElevatedButton.styleFrom(
                iconColor: Colors.yellowAccent,
                backgroundColor: Colors.yellowAccent,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  
                ),
              ),
              child: Text('Pretraga dostupne automobile'),
            ),
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
}
