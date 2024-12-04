import 'dart:developer';

import 'package:parental/app/view_models/base_view_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePageViewModel extends BaseViewModel {
  final client = Supabase.instance.client;

  Future<void> lockDeviceNow() async {
    try {
      await client.from('power').upsert({
        'device_status': 'lockNow',
        'action_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', 1);

      log('Device locked successfully.');
    } catch (e) {
      log('Error in lockDeviceNow: $e');
    }
  }

  Future<void> addTenMinutes() async {
    try {
      final response =
          await client.from('power').select('action_at').eq('id', 1).single();

      if (response.isEmpty) {
        throw Exception('Failed to fetch action_at: Invalid data');
      }

      final currentActionAt = DateTime.parse(response['action_at']);

      final newActionAt = currentActionAt.add(const Duration(minutes: 10));

      await client.from('power').update({
        'device_status': "lock",
        'action_at': newActionAt.toUtc().toIso8601String(),
      }).eq('id', 1);

      print('Added 10 minutes successfully. New action_at: $newActionAt');
    } catch (e) {
      log('Error in addTenMinutes: $e');
    }
  }
}
