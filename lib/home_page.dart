import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List> pegarUsuarios() async {
    var url = Uri.parse('https://reqres.in/api/users');
    var response = await http.get(url);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if (response.statusCode == 200) {
      return decodedResponse['data'].toList();
    } else {
      throw Exception('Erro ao carregar dados do servidor');
    }
  }

  @override

Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Api de usuarios'),
    ),
    body: FutureBuilder<List>(
        future: pegarUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            const Center(
              child: Text('Erro ao carregar Usuários'),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                      NetworkImage(snapshot.data![index]['avatar']),
                    ),title: Text(
                      '${snapshot.data![index]['first_name']}'
                          ' ${snapshot.data![index]['last_name']}'),
                    subtitle: Text(snapshot.data![index]['email']),
                    trailing: Text(snapshot.data![index]['id'].toString()),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
  );
}
}