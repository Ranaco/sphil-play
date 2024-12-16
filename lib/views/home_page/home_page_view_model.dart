import 'dart:developer';

import 'package:parental/app/view_models/base_view_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class HomePageViewModel extends BaseViewModel {
  final client = Supabase.instance.client;
  late Map<String, dynamic> _appUsage = {};
  late Map<String, dynamic> _appStatus = {};
  late String _enabled = "";

  // Getters
  bool? appStatus(String app) => _appStatus[app];
  Map<String, dynamic> get totalAppUsage => _appUsage;
  List<String> get apps => ["com.toveedo.tablet", "com.yidflicks.app"];
  Map<String, dynamic> get appUsage => {
        for (final key in _appUsage.keys)
          if (!key.contains('com.toveedo.tguard')) key: _appUsage[key]
      };
  String get enabled => _enabled;

  Timer? _timer;

  HomePageViewModel() {
    setBusyAndNotify(true);
    Future.wait([init(), fetchAppStatus()])
        .then((va) => setBusy(false))
        .catchError((err) {
      log("Error in HomePageViewModel: $err");
    });
  }

  Future<void> init() async {
    checkEnableRealtime();
    startPeriodicFetch();
  }

  Future<void> checkEnableRealtime() async {
    var res =
        await client.from('power').select('device_status').eq('id', 1).single();
    _enabled = res['device_status'];
    notifyListeners();
    try {
      client
          .from("power")
          .stream(primaryKey: ['id', 'updated_at'])
          .eq("id", 1)
          .listen((data) {
            log("Data received: $data");
            if (data.isNotEmpty) {
              _enabled = data[0]['device_status'];
              notifyListeners();
              log("Enabled: $_enabled");
            }
          });
      notifyListeners();
    } catch (e) {
      log('Error in checkEnableRealtime: $e');
    }
  }

  Future<void> updateAppUsage() async {
    try {
      var response =
          await client.from('power').select('app_usage').eq('id', 1).single();
      if (response.isEmpty) {
        throw Exception('Failed to fetch data: Empty response');
      }

      log(response['app_usage'].toString());

      log('Data fetched successfully: $response');
      _appUsage.addAll(response['app_usage']);
      notifyListeners();
    } catch (e) {
      log('Error in updateAppUsage: $e');
    }
  }

  void startPeriodicFetch() {
    updateAppUsage();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      try {
        updateAppUsage();
      } catch (e) {
        log('Error in periodic fetch: $e');
      }
    });
  }

  Future<void> fetchAppStatus() async {
    try {
      final data =
          await client.from('power').select("enabled").eq('id', 1).single();
      _appStatus = Map<String, dynamic>.from(data['enabled']);
      notifyListeners();
    } catch (e) {
      log('Error in fetchAppStatus: $e');
    }
  }

  Future<void> lockDeviceNow() async {
    try {
      await client.from('power').update({
        'action_to': 'lockNow',
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
        'action_to': "lock",
        'action_at': newActionAt.toUtc().toIso8601String(),
      }).eq('id', 1);

      log('Added 10 minutes successfully. New action_at: $newActionAt');
    } catch (e) {
      log('Error in addTenMinutes: $e');
    }
  }

  Future<void> setAppTimeLimit(String app, int limit) async {
    var data =
        await client.from("power").select("app_limit").eq("id", 1).single();

    final appLimit = Map<String, dynamic>.from(data['app_limit']);

    appLimit.update(app, (val) => limit, ifAbsent: () => limit);

    log("message $appLimit");

    await client.from("power").update({
      "app_limit": appLimit,
    }).eq("id", 1);
  }

  Future<void> setAppStatus(String app, bool status) async {
    _appStatus[app] = status;
    log(_appStatus.toString());
    notifyListeners();
    final data =
        await client.from("power").select("enabled").eq("id", 1).single();

    final appStatus = Map<String, dynamic>.from(data['enabled']);
    appStatus.update(app, (val) => status, ifAbsent: () => status);

    await client.from("power").update({
      "enabled": appStatus,
    }).eq("id", 1);
  }

  Map<String, dynamic> miliToHrsAndMins(dynamic milli) {
    var milliseconds = int.parse(milli.toString());
    final hours = milliseconds ~/ 3600000;
    final minutes = (milliseconds % 3600000) ~/ 60000;
    return {
      'hrs': hours,
      'mins': minutes,
    };
  }

  @override
  void dispose() {
    _timer?.cancel();
    log('Timer disposed.');
    super.dispose();
  }
}
