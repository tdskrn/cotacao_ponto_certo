import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class LocalBase {
  Map<String, dynamic> _products = {};
  Map<String, dynamic> get products => _products;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Box _localDataBox;

  DateTime? _lastSyncDateTime;

  Future<void> hiveInitialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(
      appDocumentDir.path,
    );
    _localDataBox = await Hive.openBox('local_data');

    print(_localDataBox.get('last_synchronize'));

    if (_localDataBox.containsKey('last_synchronize')) {
      String? lastSync = _localDataBox.get('last_synchronize');
      if (lastSync != null) {
        _lastSyncDateTime =
            DateTime.parse(_localDataBox.get('last_synchronize'));
      }
    } else {
      _localDataBox.put('last_synchronize', DateTime.now().toString());
    }
  }

  Future<String> checkConectivity() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return "Mobile";
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return "Wifi";
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      return "Ethernet";
    }
    return "None";
  }

  Future<void> loadProducts() async {
    await hiveInitialize();

    await setProducts();
  }

  Future<void> setProducts() async {
    try {
      String connectivity = await checkConectivity();

      if (connectivity != "None") {
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
            .collection('products')
            .where('last_modified', isLessThan: _lastSyncDateTime)
            .get();
        for (var doc in querySnapshot.docs) {
          DateTime lastModified = (doc['last_modified'] as Timestamp).toDate();
          if (_lastSyncDateTime == null ||
              lastModified.isBefore(_lastSyncDateTime!)) {
            // Atualizar dados locais
            _products[doc.id] = doc.data();

            // Atualizar data de sincronização local
            _localDataBox.put('last_synchronize', DateTime.now().toString());
            print('carreguei online');
          }
        }

        // Salvar os produtos do Firestore na coleção local
        await _saveProductsToLocal();
        print('salvei');
        print(_localDataBox.values);
      } else {
        // Carregar os produtos salvos localmente
        await _loadProductsFromLocal();
        print(_localDataBox.values);
      }
    } catch (e) {
      print('Erro ao carregar produtos do Firestore: $e');
    }
  }

  Future<void> _saveProductsToLocal() async {
    try {
      await _localDataBox.clear(); // Limpar a coleção local antes de salvar
      _products.forEach((productId, productData) {
        _localDataBox.put(productId, productData);
      });
    } catch (e) {
      print('Erro ao salvar produtos localmente: $e');
    }
  }

  Future<void> _loadProductsFromLocal() async {
    try {
      _products.clear(); // Limpar os produtos em memória antes de carregar
      var values =
          _localDataBox.values.toList(); // Converter os valores para uma lista
      for (var i = 0; i < values.length; i++) {
        var productData = values[i];
        if (productData is Map<String, dynamic>) {
          _products[productData['productId']] = productData;
        } else {
          print('Erro ao carregar produto: Dados inválidos na posição $i');
        }
      }
    } catch (e) {
      print('Erro ao carregar produtos locais: $e');
    }
  }
}
