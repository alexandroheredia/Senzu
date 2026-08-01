/// Central Firestore handles.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference<Map<String, dynamic>> dbUsersCollection = FirebaseFirestore.instance.collection('users');

final CollectionReference<Map<String, dynamic>> dbFoodsCollection = FirebaseFirestore.instance.collection('foods');

final FirebaseFirestore db = FirebaseFirestore.instance;
