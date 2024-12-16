import 'package:auto_route/auto_route.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:parental/views/home_page/home_page_view_model.dart';
import 'package:parental/widgets/tiles/action_tile.dart';
import 'package:parental/widgets/tiles/ratio_tile.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var isSmallScreen = size.width < 400;

    return ChangeNotifierProvider(
      create: (_) => HomePageViewModel(),
      builder: (context, _) {
        final model = context.watch<HomePageViewModel>();
        final totalAppUsage = model.totalAppUsage;
        final appUsage = model.appUsage;

        final timeToday = totalAppUsage['com.toveedo.tguard'] ?? 0;
        final convertedTime = model.miliToHrsAndMins(timeToday);

        Widget timeLimitBottomSheet() {
          return Container(
            color: Colors.white,
            width: double.infinity,
            height: 390,
            child: Column(
              children: List.generate(
                model.apps.length,
                (index) {
                  String name = model.apps[index].split(".")[1];

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    width: size.width,
                    height: 90,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                        ),
                        GestureDetector(
                          onTap: () async {
                            var selectedDuration = await showDurationPicker(
                              context: context,
                              initialTime: const Duration(seconds: 0),
                            );
                            if (selectedDuration != null) {
                              model.setAppTimeLimit(model.apps[index],
                                  selectedDuration.inMilliseconds);
                            }
                          },
                          child: const Icon(
                            Icons.timer,
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }

        Widget appStateSheet(BuildContext context) {
          return ChangeNotifierProvider.value(
              value: context.watch<HomePageViewModel>(),
              builder: (context, _) {
                return Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 390,
                  child: Column(
                    children: List.generate(
                      model.apps.length,
                      (index) {
                        bool isEnabled =
                            model.appStatus(model.apps[index]) ?? false;
                        String name = model.apps[index].split(".")[1];

                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          width: size.width,
                          height: 90,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.ltr,
                              ),
                              Switch(
                                  value: isEnabled,
                                  onChanged: (val) => model.setAppStatus(
                                      model.apps[index], val)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              });
        }

        if (model.busy) {
          return const Scaffold(
            backgroundColor: Color(0xfffbf6ee),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
            backgroundColor: const Color(0xfffbf6ee),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 35, vertical: 30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 35),
                      Image.asset("assets/icons/logo.png"),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Status",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.circle,
                            color: Color(0xff66ED5B),
                            size: 10,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            model.enabled.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xff54C64F),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: size.width * 0.35,
                            width: size.width * 0.4,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/time.png",
                                      width: isSmallScreen ? 16 : 20,
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      "Time Today",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: isSmallScreen ? 12 : 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        text: convertedTime['hrs'].toString(),
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 25 : 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: " Hours",
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 12 : 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: convertedTime['mins'].toString(),
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 25 : 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: " Minutes",
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 12 : 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Quick Actions Box
                          Container(
                            height: size.width * 0.35,
                            width: size.width * 0.4,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/flash.png",
                                      height: isSmallScreen ? 18 : 24,
                                      width: isSmallScreen ? 12 : 15,
                                    ),
                                    const SizedBox(width: 4.5),
                                    Text(
                                      "Quick Actions",
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: model.lockDeviceNow,
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              "assets/icons/lock.png",
                                              height: isSmallScreen ? 12 : 15,
                                              width: isSmallScreen ? 12 : 15,
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Text(
                                              "LOCK NOW",
                                              style: TextStyle(
                                                fontSize:
                                                    isSmallScreen ? 9 : 11,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    InkWell(
                                      onTap: model.addTenMinutes,
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              "assets/icons/add_ten.png",
                                              height: isSmallScreen ? 12 : 15,
                                              width: isSmallScreen ? 12 : 15,
                                            ),
                                            const SizedBox(width: 7),
                                            Text(
                                              "+10 Minutes",
                                              style: TextStyle(
                                                fontSize:
                                                    isSmallScreen ? 9 : 11,
                                                color: const Color(0xff65B741),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Usage Breakdown",
                                  style: TextStyle(
                                      fontSize: isSmallScreen ? 18 : 21,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 15),
                            if (appUsage.isNotEmpty)
                              RatioTile(appUsage: appUsage),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ActionTile(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (context_) => ListenableProvider.value(
                            value: model,
                            child: appStateSheet(context),
                          ),
                        ),
                        description: "Enable and disable apps",
                        icon: "assets/icons/app_tile.png",
                        title: "Apps",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ActionTile(
                        onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (context) => timeLimitBottomSheet()),
                        description: "Limit the times spent on apps",
                        icon: "assets/icons/sand_clock.png",
                        title: "App Time Limits",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ActionTile(
                        onTap: () async {
                          var duration = await showDurationPicker(
                              context: context,
                              initialTime: const Duration(seconds: 0));
                          if (duration != null) {
                            model.setAppTimeLimit(
                                "com.toveedo.tguard", duration.inMilliseconds);
                          }
                        },
                        description: "Set the total time allowed",
                        icon: "assets/icons/weather.png",
                        title: "Total Daily Time",
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
