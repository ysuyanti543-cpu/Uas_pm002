import 'package:flutter/material.dart';

import 'pages/login_page.dart';
import 'pages/admin_page.dart';
import 'pages/resident_page.dart';
import 'pages/available_sellers.dart'; // <- pastikan ini berisi LayananPage
import 'pages/seller_page.dart';
import 'pages/administrasi_page.dart';
import 'pages/administrasi_kependudukan_page.dart';
import 'pages/manage_user_page.dart';
import 'pages/persetujuan_petugas_page.dart';
import 'pages/aspirasi_report_page.dart';
import 'pages/submit_aspirasi_page.dart';
import 'pages/aspirasi_qr_scanner_page.dart';

import 'services/mock_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MockService.instance.initSampleData().then(
        (_) => runApp(const MyApp()),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aspirasi DPR',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB71C1C),
          primary: const Color(0xFFB71C1C),
          secondary: const Color(0xFFFFD700),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFB71C1C),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (c) => const LoginPage(),
        AdminPage.routeName: (c) => const AdminPage(),
        SellerPage.routeName: (c) => const SellerPage(),
        LayananPage.routeName: (c) => const LayananPage(),
        ResidentPage.routeName: (c) => const ResidentPage(),
        ManageUserPage.routeName: (c) => const ManageUserPage(),
        AdministrasiPage.routeName: (c) => const AdministrasiPage(),
        AdministrasiKependudukanPage.routeName: (c) =>
            const AdministrasiKependudukanPage(),
        PersetujuanPetugasPage.routeName: (c) =>
            const PersetujuanPetugasPage(),
        AspirasiReportPage.routeName: (c) =>
            const AspirasiReportPage(),
        SubmitAspirasiPage.routeName: (c) =>
            const SubmitAspirasiPage(),
        AspirasiQrScannerPage.routeName: (c) =>
            const AspirasiQrScannerPage(),
      },
    );
  }
}
