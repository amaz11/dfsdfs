import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/utils/app_routes.dart';
import 'package:trealapp/core/utils/dimensions.dart';
import 'package:trealapp/core/widget/drawer.dart';
import 'package:trealapp/module/auth/controller/auth_controller.dart';
import 'package:trealapp/module/auth/controller/drawer_controller.dart';
import 'package:trealapp/module/auth/view/splash_screen.dart';
import 'core/utils/dependencies.dart' as dep;
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await dep.init();
  initiallizeGet();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

Future<void> initiallizeGet() async {
  await Get.putAsync(() async {
    return Dimensions();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.find<AuthController>();
    final DrawerControllerr drawerController =
        Get.put<DrawerControllerr>(DrawerControllerr());

    return GetMaterialApp(
      title: 'Treal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(234, 244, 243, 1)),
        useMaterial3: true,
      ),
      builder: (context, child) {
        // List of pages where the Drawer should not be shown
        final List<String> pagesWithoutDrawer = [
          AppRoutes.loginScreen,
          AppRoutes.attdenceSubmitScreen
        ];
        return Obx(() {
          final bool shouldShowDrawer =
              pagesWithoutDrawer.contains(drawerController.currentRoute.value);
          return SafeArea(
              child: Scaffold(
            drawer: shouldShowDrawer ? null : const AppDrawer(),
            body: child,
          ));
        });
      },
      // initialRoute: AppRoutes.splashScreen,
      getPages: AppRoutes.routes,
      home: const SplashScreen(),
    );
  }
}
