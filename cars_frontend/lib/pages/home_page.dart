import 'package:cars_frontend/controller/cars_data_download.dart';
import 'package:cars_frontend/pages/widgets/cars_filter.dart';
import 'package:cars_frontend/pages/widgets/cars_table.dart';
import 'package:flutter/material.dart';
import 'package:cars_frontend/pages/input_page.dart'; // Import new page

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Automobili'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.lightBlueAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Popis automobila",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InputPage()),
                  );
                },
                child: Text('Dodaj podatke'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FilterCars(),
                    SizedBox(height: 20),
                    DownloadButtons(),
                    SizedBox(height: 20),
                    Expanded(child: CarsTable()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
