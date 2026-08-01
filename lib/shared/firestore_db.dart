/// Central Firestore handles.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

final dbUsersCollection = FirebaseFirestore.instance.collection('users');

final dbFoodsCollection = FirebaseFirestore.instance.collection('foods');

final db = FirebaseFirestore.instance;
