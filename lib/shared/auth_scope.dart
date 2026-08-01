import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Resolves the current signed-in user's uid from the auth provider above the
/// widget tree. Returns an empty string when no user is signed in.
///
/// Prefer passing the uid down explicitly (e.g. via repositories) over calling
/// this from deep widget layers.
String myUID(BuildContext context) {
  final user = Provider.of<User?>(context, listen: false);
  return user?.uid ?? '';
}
