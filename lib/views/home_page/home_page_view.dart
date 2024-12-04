import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:parental/views/home_page/home_page_view_model.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return (ChangeNotifierProvider(
      create: (_) => HomePageViewModel(),
      builder: (context, _) {
        final model = context.watch<HomePageViewModel>();
        return Scaffold(
          backgroundColor: const Color(0xfffbf6ee),
          body: SafeArea(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: ListView(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 35, vertical: 30),
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  Image.asset("assets/icons/logo.png"),
                  const Align(
                    alignment: Alignment.center,
                    child: Text("Status"),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        color: Color(0xff66ED5B),
                        size: 10,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("ONLINE",
                          style: TextStyle(
                              color: Color(
                                0xff54C64F,
                              ),
                              fontSize: 10,
                              fontWeight: FontWeight.w700))
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 160,
                        width: 160,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: const Color(0xffECE3D6),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/icons/time.png",
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                const Text(
                                  "Time Today",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(TextSpan(
                                    text: "4",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                          text: " Hours",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400))
                                    ])),
                                Text.rich(TextSpan(
                                    text: "15",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                          text: " Minutes",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400))
                                    ]))
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 150,
                        width: 150,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: const Color(0xffE4DED5),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/icons/flash.png",
                                  height: 24,
                                  width: 15,
                                ),
                                const SizedBox(
                                  width: 4.5,
                                ),
                                const Text(
                                  "Quick Actions",
                                  style: TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                InkWell(
                                  onTap: model.lockDeviceNow,
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          "assets/icons/lock.png",
                                          height: 15,
                                          width: 15,
                                        ),
                                        const Text(
                                          "LOCK NOW",
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: model.addTenMinutes,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          "assets/icons/add_ten.png",
                                          height: 15,
                                          width: 15,
                                        ),
                                        const SizedBox(
                                          width: 7,
                                        ),
                                        const Text(
                                          "+10 Minutes",
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Color(0xff65B741),
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 21, vertical: 15),
                    width: double.infinity,
                    height: 115,
                    decoration: BoxDecoration(
                        color: const Color(0xffECE3D6),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/icons/chart.png",
                              height: 22,
                              width: 22,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Usage Breakdown",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ));
  }
}
