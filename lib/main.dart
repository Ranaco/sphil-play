import "package:flutter/material.dart";
import "package:parental/app/app.locator.dart";
import "package:parental/app/app.router.dart";
import "package:parental/app/constants.dart";
import "package:supabase_flutter/supabase_flutter.dart";

void main() {
  setupLocator();
  Supabase.initialize(
      anonKey: Constants.SUPABASE_KEY, url: Constants.SUPABASE_URL);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final router = locator<AppRouter>();
    return (MaterialApp.router(
      routerConfig: router.config(),
      debugShowCheckedModeBanner: false,
      title: "Parental Control",
    ));
  }
}
