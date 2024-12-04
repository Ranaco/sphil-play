import 'package:auto_route/auto_route.dart';
import 'package:parental/views/home_page/home_page_view.dart';

part 'app.router.gr.dart';

@AutoRouterConfig(replaceInRouteName: "View,Route")
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes =>
      [AutoRoute(page: HomePageRoute.page, initial: true)];
}
