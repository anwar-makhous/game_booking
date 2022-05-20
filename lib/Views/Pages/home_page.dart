import 'dart:io';

import 'package:flutter/material.dart';
import 'package:game_booking/Controllers/games_provider.dart';
import 'package:game_booking/Models/game.dart';
import 'package:game_booking/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, "/AddNewGame"),
          icon: const Icon(Icons.add),
        ),
        actions: [
          optionsMenu(context),
        ],
      ),
      body: Consumer<GamesProvider>(
        builder: (context, gamesProvider, child) {
          List<Game> _gamesList = gamesProvider.gamesList;
          if (_gamesList.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .05,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/AddNewGame"),
                      child: Icon(
                        Icons.add_box_rounded,
                        color: Theme.of(context).primaryColor,
                        size: MediaQuery.of(context).size.height * .2,
                      ),
                    ),
                    Text(
                      LocaleKeys.noBookedGames.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * .04,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: _gamesList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/EditGame",
                      arguments: _gamesList[index].id),
                  child: Card(
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Theme.of(context).primaryColor.withOpacity(.8),
                        width: 2.0,
                      ),
                    ),
                    margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * .025,
                      left: MediaQuery.of(context).size.width * .025,
                      top: MediaQuery.of(context).size.height * .02,
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .02,
                        bottom: MediaQuery.of(context).size.height * .02,
                        left: context.locale.languageCode == "en"
                            ? MediaQuery.of(context).size.width * .05
                            : MediaQuery.of(context).size.width * .1,
                        right: context.locale.languageCode == "en"
                            ? MediaQuery.of(context).size.width * .1
                            : MediaQuery.of(context).size.width * .05,
                      ),
                      title: Text(_gamesList[index].title),
                      subtitle: Text(
                          '${_gamesList[index].maxPlayersNo} ${LocaleKeys.maximumPlayersNo.tr()}'),
                      leading: SizedBox(
                        width: MediaQuery.of(context).size.width * .2,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(40)),
                          child: (_gamesList[index].imgURL! == "")
                              ? Image.asset('assets/images/Football.png')
                              : Image.file(
                                  File(_gamesList[index].imgURL!),
                                ),
                        ),
                      ),
                      trailing: Text(
                        DateFormat.E(context.locale.languageCode)
                            .addPattern(" d MMM\n")
                            .add_jm()
                            .format(_gamesList[index].date),
                        textAlign: context.locale.languageCode == "en"
                            ? TextAlign.right
                            : TextAlign.left,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  PopupMenuButton<dynamic> optionsMenu(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: PopupMenuButton(
              offset: Offset(
                  context.locale.languageCode == "en"
                      ? -MediaQuery.of(context).size.width * .3
                      : MediaQuery.of(context).size.width * .2,
                  0),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_left,
                    color: Colors.black,
                  ),
                  Text(LocaleKeys.sortBy.tr()),
                ],
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () {
                      Provider.of<GamesProvider>(context, listen: false)
                          .sortBy("Title");
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocaleKeys.title.tr()),
                        Provider.of<GamesProvider>(context, listen: false)
                                .isSortedByTitle
                            ? const Icon(Icons.check, color: Colors.green)
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      Provider.of<GamesProvider>(context, listen: false)
                          .sortBy("Date");
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocaleKeys.date.tr()),
                        !Provider.of<GamesProvider>(context, listen: false)
                                .isSortedByTitle
                            ? const Icon(Icons.check, color: Colors.green)
                            : const SizedBox(),
                      ],
                    ),
                  )
                ];
              },
            ),
          ),
          PopupMenuItem(
            child: PopupMenuButton(
              offset: Offset(
                  context.locale.languageCode == "en"
                      ? -MediaQuery.of(context).size.width * .3
                      : MediaQuery.of(context).size.width * .2,
                  0),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_left,
                    color: Colors.black,
                  ),
                  Text(LocaleKeys.language.tr()),
                ],
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () async {
                      await context.setLocale(const Locale("en"));
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocaleKeys.english.tr()),
                        context.locale.languageCode == "en"
                            ? const Icon(Icons.check, color: Colors.green)
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      await context.setLocale(const Locale("ar"));
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocaleKeys.arabic.tr()),
                        context.locale.languageCode == "ar"
                            ? const Icon(Icons.check, color: Colors.green)
                            : const SizedBox(),
                      ],
                    ),
                  )
                ];
              },
            ),
          ),
        ];
      },
    );
  }
}
