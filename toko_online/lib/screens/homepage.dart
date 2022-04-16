import 'dart:convert';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toko_online/screens/add_product.dart';
import 'package:toko_online/screens/edit_product.dart';
import 'package:toko_online/screens/product_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = 'http://192.168.42.99:8000/api/products';

  // android 10.0.2.2
  Future getProducts() async{
    var response = await http.get(Uri.parse(url));
        if (kDebugMode) {
          print(json.decode(response.body));
        }
      
    return json.decode(response.body);
  }

  Future deleteProducts(String productId) async {
    String url = 'http://192.168.42.99:8000/api/products/' + productId;

    var response = await http.delete(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddProduct()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Center(child: Text('Eko Store')),
      ),
      body: FutureBuilder(
        future: getProducts(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data['data'].length,
              itemBuilder: (context, int index) {
                return Container(
                  height: 180,
                  child: Card(
                    elevation: 5,
                    child: Row(
                      children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetail(product: snapshot.data['data'][index],)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0)),
                          padding: const EdgeInsets.all(5),
                          height: 120,
                          width: 120,
                          child: Image.network(
                            snapshot.data['data'][index]['image_url'],
                            fit: BoxFit.cover,
                          ),
                          ),
                      ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    snapshot.data['data'][index]['name'],
                                  style: const TextStyle(
                                    fontSize:20.0,
                                    fontWeight: FontWeight.bold),
                                    ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(snapshot.data['data'][index]['description'])),
                                Row(
                                  mainAxisAlignment:        MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                        onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (contex) => EditProduct(product: snapshot.data
                                        ['data']
                                        [index],)));
                                        },
                                          child: const Icon(Icons.edit)),
                                        GestureDetector(
                                          onTap: (){
                                            deleteProducts(snapshot.data['data'][index]['id'].toString()).then((value)
                                            {
                                              setState(() {});
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product berhasil di hapus")));
                                            });
                                        },
                                          child: const Icon(Icons.delete)),
                                          ]
                                        ),
                                    Text(snapshot.data['data'][index]['price'].toString()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
            });
          } else {
            return const Text('Data error');
          }
        }
      )
    );
  }
}