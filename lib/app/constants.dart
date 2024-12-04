import 'package:supabase_flutter/supabase_flutter.dart';

class Constants {
  static const SUPABASE_URL = "https://ptzumvjwnetznstbeiqw.supabase.co";
  static const SUPABASE_KEY =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB0enVtdmp3bmV0em5zdGJlaXF3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjE5MDQ4MzQsImV4cCI6MjAzNzQ4MDgzNH0.RisqwWGwP2Jyw6NPW44ouEhTDmBHe7HFy-UXdqZXGoM";
  static var supabaseClient = () => SupabaseClient(SUPABASE_URL, SUPABASE_KEY);
}
