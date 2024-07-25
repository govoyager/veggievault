import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

final today = DateTime.now();
final formattedDate = '${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}'; // Format yyyymmdd


class dailyPrice extends StatefulWidget {
  const dailyPrice({super.key});

  @override
  State<dailyPrice> createState() => _dailyPriceState();
}

class _dailyPriceState extends State<dailyPrice> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late Box productsBox;


  @override
  void initState() {
    super.initState();
    productsBox = Hive.box('productsBox');
    _loadProducts();
  }

  bool _isAscending = true;


  Future<void> _loadProducts() async {
    if (productsBox.isEmpty) {
      final productsSnapshot = await _firestore.collection('products').get();
      final products = productsSnapshot.docs.map((doc) => {
        'name': doc['name'],
        'price': doc.data().containsKey('price') ? doc['price'] : null,
      }).toList();
      for (var product in products) {
        productsBox.add(product);
      }
    }
    setState(() {});
  }

  Future<void> _refreshProducts() async {
    final productsSnapshot = await _firestore.collection('products').get();
    final products = productsSnapshot.docs.map((doc) => {
      'name': doc['name'],
      'price': doc.data().containsKey('price') ? doc['price'] : null,
    }).toList();
    await productsBox.clear();
    for (var product in products) {
      productsBox.add(product);
    }
    setState(() {});
  }

  void _addProduct() {
    final TextEditingController _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Product'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Enter product name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  final newProduct = {'name': _nameController.text};
                  _firestore.collection('products').add(newProduct);
                  productsBox.add(newProduct);
                  setState(() {});
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _updatePrice(String productName, String productId) {
    final TextEditingController _priceController = TextEditingController();
    IconData _selectedIcon = Icons.wb_sunny; // Default icon
    final iconFields = {
      Icons.wb_sunny: 'sunPrice',
      Icons.nightlight_round: 'moonPrice'
    };

    Future<void> _fetchExistingPrice() async {
      final docSnapshot = await _firestore.collection('products').doc(productId).collection('prices').doc(formattedDate).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final price = data?[iconFields[_selectedIcon]] ?? 0.0;
        _priceController.text = price.toString();
      }
    }

    // Show dialog and fetch existing price
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Fetch the existing price when the dialog is opened
            _fetchExistingPrice();
            return AlertDialog(
              title: Text(
                'Update - $productName',
                style: TextStyle(fontSize: 20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIcon = Icons.wb_sunny; // Select sun icon
                            _fetchExistingPrice(); // Fetch price for sun icon
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedIcon == Icons.wb_sunny ? Colors.blueAccent : Colors.transparent,
                          ),
                          child: Icon(
                            Icons.wb_sunny,
                            size: 30,
                            color: _selectedIcon == Icons.wb_sunny ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIcon = Icons.nightlight_round; // Select moon icon
                            _fetchExistingPrice(); // Fetch price for moon icon
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedIcon == Icons.nightlight_round ? Colors.blueAccent : Colors.transparent,
                          ),
                          child: Icon(
                            Icons.nightlight_round,
                            size: 30,
                            color: _selectedIcon == Icons.nightlight_round ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Space between buttons and text field
                  TextField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      hintText: 'Enter product price',
                      prefixIcon: Icon(_selectedIcon), // Display selected icon
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (_priceController.text.isNotEmpty) {
                      final newPrice = double.parse(_priceController.text);
                      final iconField = iconFields[_selectedIcon]!;

                      _firestore.collection('products').doc(productId).collection('prices').doc(formattedDate).set({
                        iconField: newPrice,
                      }, SetOptions(merge: true)).then((_) {
                        // Optionally, update local storage here if needed
                        final productIndex = productsBox.values.toList().indexWhere((element) => element['name'] == productName);
                        productsBox.putAt(productIndex, {
                          'name': productName,
                          'price': newPrice.toDouble(),
                        });
                        setState(() {});
                      });

                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {

    final List filteredProducts = productsBox.values.where((product) {
      return product['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery);
    }).toList();

    filteredProducts.sort((a, b) {
      final nameA = a['name'].toLowerCase();
      final nameB = b['name'].toLowerCase();

      if (_isAscending) {
        return nameA.compareTo(nameB); // Ascending
      } else {
        return nameB.compareTo(nameA); // Descending
      }
    });

    return GestureDetector(
        onTap: () {
      FocusScope.of(context).unfocus();
    },
        child:Scaffold(
      appBar: AppBar(
        title: Text(
          'Daily Price',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add,color: Colors.white,),
            onPressed: _addProduct,
          ),
        ],
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search,color: Colors.white,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Row(
            children: [
              SizedBox(width: 15,),

                    Text(
                      'Product',
                      style: TextStyle(color: Colors.white),
                    ),

              Spacer(flex: 1,),
              Container(
                padding: EdgeInsets.all(1.0),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/gif/live.gif',
                        height: 30,width: 30,
                      ),
                      Text('Live',style: TextStyle(color: Colors.red),),
                    ]
                )
              ),
              SizedBox(width: 10,),
            ],
          ),
          SizedBox(height: 5,),
          Container(height: 1,color: Colors.black,),
          SizedBox(height: 5,),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshProducts,
              child: Scrollbar(
                child: ListView.separated(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    final productName = product['name'];

                    Future<Map<String, dynamic>> fetchPrices() async {
                      try {
                        final today = DateTime.now();
                        final formattedDate = '${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}'; // Format yyyymmdd
                        final previousDate = today.subtract(Duration(days: 1));
                        final formattedPreviousDate = '${previousDate.year}${previousDate.month.toString().padLeft(2, '0')}${previousDate.day.toString().padLeft(2, '0')}'; // Format yyyymmdd for previous day

                        final docSnapshot = await _firestore.collection('products').where('name', isEqualTo: productName).get();
                        if (docSnapshot.docs.isNotEmpty) {
                          final productId = docSnapshot.docs.first.id;

                          final currentDayDoc = await _firestore.collection('products').doc(productId).collection('prices').doc(formattedDate).get();
                          final previousDayDoc = await _firestore.collection('products').doc(productId).collection('prices').doc(formattedPreviousDate).get();

                          final currentSunPriceStr = currentDayDoc.data()?['sunPrice']?.toString() ?? '0';
                          final previousSunPriceStr = previousDayDoc.data()?['sunPrice']?.toString() ?? '0';
                          final currentMoonPriceStr = currentDayDoc.data()?['moonPrice']?.toString() ?? '0';
                          final previousMoonPriceStr = previousDayDoc.data()?['moonPrice']?.toString() ?? '0';

                          final currentSunPrice = double.tryParse(currentSunPriceStr) ?? 0.0;
                          final previousSunPrice = double.tryParse(previousSunPriceStr) ?? 0.0;
                          final currentMoonPrice = double.tryParse(currentMoonPriceStr) ?? 0.0;
                          final previousMoonPrice = double.tryParse(previousMoonPriceStr) ?? 0.0;

                          return {
                            'sunPrice': currentSunPriceStr,
                            'moonPrice': currentMoonPriceStr,
                            'currentDayHasPrice': currentDayDoc.exists,
                            'previousSunPrice': previousSunPrice,
                            'previousMoonPrice': previousMoonPrice,
                          };
                        } else {
                          return {
                            'sunPrice': 'Not set',
                            'moonPrice': 'Not set',
                            'currentDayHasPrice': false,
                            'previousSunPrice': 0.0,
                            'previousMoonPrice': 0.0,
                          };
                        }
                      } catch (e) {
                        print('Error fetching prices: $e'); // Log error for debugging
                        return {
                          'sunPrice': 'Error',
                          'moonPrice': 'Error',
                          'currentDayHasPrice': false,
                          'previousSunPrice': 0.0,
                          'previousMoonPrice': 0.0,
                        };
                      }
                    }

                    return FutureBuilder<Map<String, dynamic>>(
                      future: fetchPrices(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                          if (snapshot.hasError) {
                            return ListTile(
                              leading: Icon(Icons.error),
                              title: Text('Error fetching prices'),
                            );
                          }

                          final sunPriceStr = snapshot.data!['sunPrice'];
                          final moonPriceStr = snapshot.data!['moonPrice'];
                          final currentDayHasPrice = snapshot.data!['currentDayHasPrice'] as bool;
                          final previousSunPrice = snapshot.data!['previousSunPrice'] as double;
                          final previousMoonPrice = snapshot.data!['previousMoonPrice'] as double;
                          final currentSunPrice = double.tryParse(sunPriceStr) ?? 0.0;
                          final currentMoonPrice = double.tryParse(moonPriceStr) ?? 0.0;

                          final sunPriceColor = currentSunPrice >= previousSunPrice ? Colors.green : Colors.red;
                          final moonPriceColor = currentMoonPrice >= previousMoonPrice ? Colors.green : Colors.red;

                          final sunPercentageChange = previousSunPrice != 0.0
                              ? ((currentSunPrice - previousSunPrice) / previousSunPrice) * 100
                              : 0.0;
                          final moonPercentageChange = previousMoonPrice != 0.0
                              ? ((currentMoonPrice - previousMoonPrice) / previousMoonPrice) * 100
                              : 0.0;

                          return ListTile(
                            leading: Image.asset(
                              'assets/$productName.png',
                              height: 40,
                              width: 40,
                            ),
                            title: Text(
                              productName,
                              style: TextStyle(color: Colors.white,
                              fontSize: 14),
                            ),
                            trailing: Container(
                              constraints: BoxConstraints(maxWidth: 170), // Adjust the max width as needed
                              child: Row(
                                mainAxisSize: MainAxisSize.max, // Ensure the Row takes the full width available
                                children: [
                                  // Sun data with conditional highlighting
                                  Expanded(
                                    child: Container(
                                      color: DateTime.now().hour >= 12
                                          ? Colors.grey.withOpacity(0.3)
                                          : Colors.transparent,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.wb_sunny_rounded,
                                                  color: currentDayHasPrice ? sunPriceColor : Colors.yellow,
                                                ),
                                                Text(
                                                  ' RM$sunPriceStr',
                                                  style: TextStyle(
                                                    color: currentDayHasPrice ? sunPriceColor : Colors.yellow,
                                                    fontSize: 10
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '${sunPercentageChange.toStringAsFixed(2)}%',
                                              style: TextStyle(
                                                fontSize: 8,
                                                color: currentDayHasPrice ? sunPriceColor : Colors.yellow,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(width: 10),
                                  Container(color: Colors.white,width: 1,),// Adds some space between the rows
                                  Expanded(
                                    child: Container(
                                      color: DateTime.now().hour < 12
                                          ? Colors.grey.withOpacity(0.3)
                                          : Colors.transparent,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.nightlight_round,
                                                  color: currentDayHasPrice ? moonPriceColor : Colors.yellow,
                                                ),
                                                Text(
                                                  ' RM$moonPriceStr',
                                                  style: TextStyle(
                                                    color: currentDayHasPrice ? moonPriceColor : Colors.yellow,
                                                    fontSize: 10
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '${moonPercentageChange.toStringAsFixed(2)}%',
                                              style: TextStyle(
                                                fontSize: 8,
                                                color: currentDayHasPrice ? moonPriceColor : Colors.yellow,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              _firestore
                                  .collection('products')
                                  .where('name', isEqualTo: productName)
                                  .get()
                                  .then((value) {
                                final productId = value.docs.first.id;
                                _updatePrice(productName, productId);
                              });
                            },
                          );
                        } else if (snapshot.hasError) {
                          return ListTile(
                            leading: Icon(Icons.error),
                            title: Text('Error fetching prices'),
                          );
                        } else {
                          return ListTile(
                            leading: CircularProgressIndicator(),
                            title: Text(productName),
                          );
                        }
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}