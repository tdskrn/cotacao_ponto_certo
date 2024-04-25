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
    String response = await checkConectivity();

    if (response != "None") {
      await setProducts();
    }
  }

  Future<void> setProducts() async {
    try {
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
        }
      }
    } catch (e) {
      print('Erro ao carregar produtos do Firestore: $e');
    }
  }
}
