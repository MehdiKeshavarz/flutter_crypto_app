import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_crypto/providers/crypto_data_provider.dart';
import 'package:flutter_application_crypto/providers/market_view_provider.dart';
import 'package:flutter_application_crypto/providers/theme_provider.dart';
import 'package:flutter_application_crypto/ui/main_wrapper.dart';
import 'package:flutter_application_crypto/ui/ui_helper/theme_switcher.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => CryptoDataProvider()),
      ChangeNotifierProvider(create: (context) => MarketViewProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context,themeProvider,child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode:themeProvider.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          home: const Directionality(
            textDirection: TextDirection.ltr,
            child:MainWrapper(),
          ),
        );
      }
    );


  }
}
