import 'dart:convert';

import 'package:cars_frontend/api/api_client.dart';
import 'package:flutter/material.dart';

class InputPage extends StatelessWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController field1Controller = TextEditingController();
    final TextEditingController field2Controller = TextEditingController();
    final TextEditingController field3Controller = TextEditingController();
    final TextEditingController field4Controller = TextEditingController();
    final ApiClient apiClient = ApiClient();

    return Scaffold(
      appBar: AppBar(
        title: Text('Unos podataka'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: field1Controller,
              decoration: InputDecoration(labelText: 'Polje 1'),
            ),
            TextField(
              controller: field2Controller,
              decoration: InputDecoration(labelText: 'Polje 2'),
            ),
            TextField(
              controller: field3Controller,
              decoration: InputDecoration(labelText: 'Polje 3'),
            ),
            TextField(
              controller: field4Controller,
              decoration: InputDecoration(labelText: 'Polje 4'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                   Map<String, dynamic> podaci =jsonDecode(field1Controller.text);
                   print(podaci);
                   print("Saljem podatke");
                    await apiClient.postData(podaci);
                  },
                  child: Text('Gumb 1 - POST'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    
                    Map<String, dynamic> podaci =jsonDecode(field3Controller.text);
                    await apiClient.putData(field2Controller.text, podaci);
                  },
                  child: Text('Gumb 2 - PUT'),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final data = {
                      'field4': field4Controller.text,
                     
                    };
                await apiClient.deleteData(field4Controller.text);
              },
              child: Text('Gumb 3 - DELETE'),
            ),
          ],
        ),
      ),
    );
  }
}
