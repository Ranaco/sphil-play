import 'package:get_it/get_it.dart';
import 'package:parental/app/app.router.dart';
import 'package:parental/app/services/google_analytics_service.dart';
import 'package:parental/app/services/supabase_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<GoogleAnalyticsService>(GoogleAnalyticsService());
  locator.registerSingleton<AppRouter>(AppRouter());
  locator.registerSingleton<SupabaseService>(SupabaseService());
}
