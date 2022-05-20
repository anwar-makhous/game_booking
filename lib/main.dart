import 'package:flutter/material.dart';
import 'package:game_booking/Controllers/games_provider.dart';
import 'package:game_booking/Controllers/user_provider.dart';
import 'package:game_booking/Views/Pages/home_page.dart';
import 'package:game_booking/Views/Pages/game_form.dart';
import 'package:game_booking/translations/codegen_loader.g.dart';
import 'package:game_booking/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      assetLoader: const CodegenLoader(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GamesProvider>(
          create: (context) => GamesProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: context.locale.languageCode == "en" ? 'Yalla Goal' : "يلا غول",
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        routes: {
          "/": (context) {
            Provider.of<GamesProvider>(context, listen: false).restoreList();
            return MyHomePage(title: LocaleKeys.appTitle.tr());
          },
          "/AddNewGame": (context) => const GameForm(),
          "/EditGame": (context) => const GameForm(),
        },
      ),
    );
  }
}
