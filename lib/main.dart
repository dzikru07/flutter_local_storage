// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_storage/model/product_list/product.dart';
import 'package:flutter_local_storage/model/product_list/product_list.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final box = GetStorage();

  ProductList data = ProductList();
  ProductList pureData = ProductList();

  getLocalData() async {
    final getData = await box.read('products');
    if (getData != null) {
      data = ProductList.fromJson(getData);
    }
  }

  @override
  void initState() {
    super.initState();
    getLocalData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Flutter Local Storage",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              filterData();
            },
            icon: const Icon(
              Icons.filter_alt,
              color: Colors.white,
            ),
          ),
          // make icon to reset data
          IconButton(
            onPressed: () {
              setState(() {
                getLocalData();
              });
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ],
      ),
      // make fab flutter
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (data.products == null) {
            fetchJSONData().then((jsonData) {
              // Do something with the JSON data.
              setState(() {
                box.write('products', jsonData);
                data = jsonData;
                pureData = jsonData;
                print(data.products?.first.title);
              });
            }).catchError((error) {
              // Handle any errors that occurred.
              print(error);
            });
          } else {
            setState(() {
              box.remove('products');
              data = ProductList();
            });
          }
        },
        child: Icon(data.products != null ? Icons.clear : Icons.download),
      ),
      body: data.products == null
          ? const Center(
              child: Text("No Data"),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      "${data.products?[index].title} - ${data.products?[index].price}"),
                );
              },
              itemCount: data.products?.length),
    );
  }

  filterData() {
    // final filteredData =
    //     data.products?.where((element) => element.title!.contains('a'));
    // make filter for price more than
    final filteredData = data.products
        ?.where((element) => element.price! > 1000 && element.price! < 1200);
    setState(() {
      data.products = filteredData?.toList();
    });
    print(filteredData);
  }
}

Future<ProductList> fetchJSONData() async {
  Uri url = Uri.parse('https://dummyjson.com/products');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final jsonResponse = ProductList.fromJson(json.decode(response.body));
    return jsonResponse;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load JSON data');
  }
}
