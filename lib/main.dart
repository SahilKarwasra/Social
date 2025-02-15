import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social/config/firebase_options.dart';

import 'app.dart';
import 'features/auth/data/firebase_auth_repo.dart';
import 'features/profile/domain/repository/profile_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp( MyApp());
}

