import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social/config/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'features/auth/data/firebase_auth_repo.dart';
import 'features/profile/domain/repository/profile_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: "https://owkmnmrdaloxkasnoxyj.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im93a21ubXJkYWxveGthc25veHlqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk2MjY0MjYsImV4cCI6MjA1NTIwMjQyNn0.8UOW4sI2Big1NnWNQAdk183dfb3U7iCrp7-S1JBJBLs"
  );

  runApp( MyApp());
}

