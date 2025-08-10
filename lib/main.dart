import 'package:flutter/material.dart';
import 'package:todo/pages/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://yqqikehtroeeikrtlwns.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlxcWlrZWh0cm9lZWlrcnRsd25zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY0OTE2NjUsImV4cCI6MjA1MjA2NzY2NX0.2umCckFJVRmnnm0u_QrXloNgnxrTx5dojNbhIxrBYUc",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NotePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
